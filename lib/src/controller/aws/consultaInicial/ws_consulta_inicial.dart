import 'dart:convert';
import 'package:abi_praxis_app/main.dart';
import 'package:abi_praxis_app/src/controller/aws/operaciones/ws_contactos.dart';
import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/controller/preferences/user_preferences.dart';
import 'package:abi_praxis_app/src/models/usuario/cliente_model.dart';
import 'package:abi_praxis_app/src/models/usuario/persona_model.dart';
import 'package:abi_praxis_app/src/models/usuario/prospecto_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WsConsultaInicial {
  static final String _url = dotenv.env["ws_consulta_inicial"]!;
  final op = Operations();
  final wsCont = WSContactos();
  final pfrc = UserPreferences();

Future<void> obtenerDatosIniciales() async {
    final idPromotor = await pfrc.getIdPromotor();
    final res = await http.post(Uri.parse(_url),
        body: jsonEncode({"id_promotor": idPromotor}));

    if (res.statusCode > 199 && res.statusCode < 300) {
      final lista = jsonDecode(res.body) as List<dynamic>;
      ProspectoModel? pros;
      ClienteModel? cli;

      for (var i = 0; i < lista.length; i++) {
        var persona = PersonaModel.fromJson(lista[i]["persona"]);
        persona.idRDS = lista[i]["persona"]["id_persona"];
        persona.idPersona = null;

        var idP = await op.insertarPersona(persona);

        if (lista[i]["prospectos"].isNotEmpty) {
          var prospectos = lista[i]["prospectos"][0] as Map<String, dynamic>;
          prospectos.addAll({"id_persona": idP});
          prospectos
              .addAll({"id_rds": lista[i]["prospectos"][0]["id_prospecto"]});
          prospectos.addAll({"id_promotor": idPromotor});
          pros = ProspectoModel.fromJson(prospectos);
          pros.idProspecto = null;

          await op.insertarProspecto(pros);
        }

        if (lista[i]["clientes"].isNotEmpty) {
          var clientes = lista[i]["clientes"][0] as Map<String, dynamic>;
          clientes.addAll({"id_persona": idP});
          clientes.addAll({"id_rds": lista[i]["clientes"][0]["id_cliente"]});
          clientes.addAll({"id_promotor": idPromotor});
          cli = ClienteModel.fromJson(clientes);
          cli.idCliente = null;

          await op.insertarCliente(cli);
        }
      }

      //todo obtener contactos por titular
      await obtenerContactosEinsertar();
    }
  }

  Future<void> obtenerContactosEinsertar() async {
    final personas = await op.obtenerPersonas();

    //recorremos toda la base de personas
    if (personas.isNotEmpty) {
      for (var per in personas) {
        //asignamos el id titular de la persona local
        int idTitularLocal = per.idPersona!;
        int idTitularNube = per.idRDS!;

        //obtenemos los contactos por el titular que estan en la nube(por la persona actual)
        final contactos = await wsCont.obtenerContactosXtitular(per.idRDS!);

        //validamos que tenga contactos
        if (contactos.isNotEmpty) {
          //recorremos la lista de contactos
          for (var cont in contactos) {
            //obtenemos la persona por el id contacto
            final personaContacto = await op.obtenerPersonaXrds(cont.idPersona);

            if (personaContacto != null) {
              //obtenemos el id persona del contacto local
              int idContactoLocal = personaContacto.idPersona!;

              //reemplazamos datos para poder ingresar en la base local el contacto
              cont.idTitular = idTitularLocal; //titular(el que tiene contactos)
              cont.idPersona = idContactoLocal; //el que es contacto del titular

              await op.insertarContactoPersona(cont);
            }
          }
        }
      }
    }
  }
}
