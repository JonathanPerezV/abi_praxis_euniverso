import 'dart:convert';

import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/controller/preferences/user_preferences.dart';
import 'package:abi_praxis_app/src/models/usuario/persona_model.dart';
import 'package:abi_praxis_app/src/models/usuario/prospecto_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WSProspectos {
  final String _url = dotenv.env["ws_prospecto"]!;
  final pfrc = UserPreferences();
  final op = Operations();

  Future<int> insertarProspecto(ProspectoModel pros, {int? idLocal}) async {
    final db = await initDatabase();

    try {
      final insert = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "insert",
            "info": pros.toJson()..remove("id_rds")
          }));

      if (insert.statusCode > 199 && insert.statusCode < 300) {
        final decode = jsonDecode(insert.body);
        final idRds = decode["id_prospecto"];

        //todo luego de insertar a la persona se actualiza el id_rds local con el id de la nube
        final res = await db.rawUpdate(
            "UPDATE tbl_prospecto SET id_rds = ? WHERE id_prospecto = ?",
            [idRds, idLocal]);

        debugPrint("PROSPECTO LOCAL ACTUALIZADO: $res");

        return idRds;
      } else {
        return 0;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<ProspectoModel?> obtenerProspecto(
      {required int idPersonaLocal}) async {
    try {
      final getLocalPros = await op.obtenerProspecto(idPersonaLocal);

      if (getLocalPros != null) {
        final get = await http.post(Uri.parse(_url),
            body: jsonEncode({
              "operacion": "obtener",
              "info": {"id_prospecto": getLocalPros.idNube}
            }));

        if (get.statusCode > 199 && get.statusCode < 300) {
          var decode = jsonDecode(get.body);
          var prospecto = ProspectoModel.fromJson(decode["result"]);
          prospecto.idNube = getLocalPros.idNube;
          return prospecto;
        } else {
          return null;
        }
      } else {
        debugPrint("NO EXISTE ESTE USUARIO COMO PROSPECTO");
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<int> insertarPersonaProspecto(PersonaModel person,
      {int? idPersonaLocal}) async {
    final db = await initDatabase();
    final op = Operations();
    final idPromotor = await pfrc.getIdPromotor();
    final fechaCreacion = DateFormat("yyyy-MM-dd").format(DateTime.now());
    final horaCreacion = DateFormat("HH:mm:ss").format(DateTime.now());

    try {
      final insert = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "insert_prospecto",
            "info": person.toJson()
              ..addAll({
                "id_promotor": idPromotor,
                "fecha_creacion": fechaCreacion,
                "hora_creacion": horaCreacion
              })
              ..remove("id_rds")
          }));

      if (insert.statusCode > 199 && insert.statusCode < 300) {
        final decode = jsonDecode(insert.body);
        final idRDSPersona = decode["id_persona"];
        final idRDSProspecto = decode["id_prospecto"];
        debugPrint("PERSONA INGRESADA CORRECTAMENTE - ID RDS: $idRDSPersona");
        debugPrint(
            "PROSPECTO INGRESADO CORRECTAMENTE - ID RDS: $idRDSProspecto");

        //actualizamos los datos locales con los id de la nube
        final resPerson = await db.rawUpdate(
            "UPDATE tbl_persona SET id_rds = ? WHERE id_persona = ?",
            [idRDSPersona, idPersonaLocal]);

        debugPrint(
            "ID RDS PERSONA LOCAL: ${resPerson != 0 ? "ACTUALIZADO" : "NO ACTUALIZADO"}");

        //obtenemos el idProspecto por medio de la persona
        final prospecto = await op.obtenerProspecto(idPersonaLocal!);

        if (prospecto != null) {
          final resPros = await db.rawUpdate(
              "UPDATE tbl_prospecto SET id_rds = ? WHERE id_prospecto = ?",
              [idRDSProspecto, prospecto.idProspecto]);

          debugPrint(
              "ID RDS PROSPECTO LOCAL: ${resPros != 0 ? "ACTUALIZADO" : "NO ACTUALIZADO"}");
        }

        return idRDSPersona;
      } else {
        return 0;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
