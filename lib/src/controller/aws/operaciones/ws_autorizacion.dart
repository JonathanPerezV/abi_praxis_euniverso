import 'dart:convert';

import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/models/autorizacion/autorizacion_model.dart';
import 'package:abi_praxis_app/src/models/autorizacion/documento_aut_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../preferences/user_preferences.dart';

class WSAutorizacion {
  final String _url = dotenv.env["ws_autorizacion"]!;
  final pfrc = UserPreferences();

  Future<int> insertarAutorizacion(
      AutorizacionModel aut, List<DocumentoAutModel> docs,
      {required int idLocal}) async {
    int idPromotor = await pfrc.getIdPromotor();
    final db = await initDatabase();

    try {
      aut.idPromotor = idPromotor;

      final insert = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "insert",
            "info": {
              "autorizacion": [aut.toJson()],
              "documentos": [
                for (var doc in docs) doc.toJson()..remove("id_rds")
              ]
            }
          }));

      if (insert.statusCode > 199 && insert.statusCode < 300) {
        final decode = jsonDecode(insert.body);
        final idRDS = decode["id_autorizacion"];

        debugPrint("AUTORIZACIÓN INGRESADA CORRECTAMENTE - ID RDS: $idRDS");

        //todo luego  de insertar la autorizacion se actualiza el id rds local con el id de la nube
        final res = await db.rawUpdate("""
        UPDATE tbl_autorizacion
          SET id_rds = ?, 
            estado = ?
              WHERE id_autorizacion = ?""", [idRDS, 3, idLocal]);

        debugPrint(
            "ID RDS LOCAL Y ESTADO FINALIZADO DE LA AUTORIZACIÓN ACTUALIZADA: $res");

        return idRDS;
      } else {
        return 0;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
