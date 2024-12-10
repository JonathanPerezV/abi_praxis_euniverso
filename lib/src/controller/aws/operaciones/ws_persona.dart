import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';

import '../../../models/usuario/persona_model.dart';
import '../../preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WSPersona {
  final pfrc = UserPreferences();
  final String _url = dotenv.env["ws_persona"]!;

  Future<Map<String, dynamic>> obtenerDatosPersonaPromotor() async {
    Map<String, dynamic> resultado = {};

    try {
      final pfrc = UserPreferences();
      final getId = await pfrc.getIdPersonaPromotor();

      final user = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "obtener",
            "info": {"id_persona": getId}
          }));

      if (user.statusCode > 199 && user.statusCode < 300) {
        final decode = jsonDecode(user.body);

        resultado = {
          "status": "ok",
          "data": PersonaModel.fromJson(decode["result"])
        };
      } else {
        final decode = jsonDecode(user.body);
        resultado = {"status": "ok", "data": decode[1]};
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
    return resultado;
  }

  Future<PersonaModel?> obtenerDatosPersona(
      int? idPersona, String? cedula) async {
    try {
      final user = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "obtener",
            "info": {"id_persona": idPersona, "cedula": cedula}
          }));

      if (user.statusCode > 199 && user.statusCode < 300) {
        final decode = jsonDecode(user.body);

        return PersonaModel.fromJson(decode["result"]);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<int> insertarPersona(PersonaModel persona,
      {required int? idLocal}) async {
    final db = await initDatabase();

    try {
      final insert = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "insert",
            "info": persona.toJson()..remove("id_rds")
          }));

      if (insert.statusCode > 199 && insert.statusCode < 300) {
        final decode = jsonDecode(insert.body);
        final idRds = decode["id_persona"];

        debugPrint("PERSONA INGRESADA CORRECTAMENTE - ID RDS: $idRds");

        //todo luego de insertar a la persona se actualiza el id_rds local con el id de la nube
        final res = await db.rawUpdate(
            "UPDATE tbl_persona SET id_rds = ? WHERE id_persona = ?",
            [idRds, idLocal]);

        debugPrint("ID RDS LOCAL DE LA PERSONA ACTUALIZADA: $res");

        return idRds;
      } else {
        return 0;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> actualizarCedula(String cedula, int idPersona) async {
    try {
      final update = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "actualizar",
            "info": {
              "id_persona": idPersona,
              "numero_identificacion": cedula,
            }
          }));
      if (update.statusCode > 199 && update.statusCode < 300) {
        debugPrint("CÉDULA DE PERSONA ACTUALIZADA");
      } else {
        debugPrint("NO SE ACTUALIZÓ LA CÉDULA DE LA PERSONA");
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<String> actualizarPersona(PersonaModel persona,
      {required bool isPromotor, int? idPersona}) async {
    final pfrc = UserPreferences();

    final idPersonaPromotor = await pfrc.getIdPersonaPromotor();

    try {
      final user = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "actualizar",
            "info": persona.toJson()
              ..addAll(
                  {"id_persona": isPromotor ? idPersonaPromotor : idPersona!})
              ..remove("id_rds")
          }));

      if (user.statusCode > 199 && user.statusCode < 300) {
        return "si";
      } else {
        final decode = jsonDecode(user.body);
        return decode["result"];
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
