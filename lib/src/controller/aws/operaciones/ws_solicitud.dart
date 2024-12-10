import 'dart:convert';
import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';

import 'package:abi_praxis_app/src/models/solicitud/soliciutd_credito_model.dart';
import 'package:abi_praxis_app/utils/pdf/generate_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WSSolicitud {
  final String _url = dotenv.env["ws_solicitud"]!;
  final op = Operations();

  Future<int> insertarSolicitud(SolicitudCreditoModel sol,
      {int? idSolicitudLocal}) async {
    final db = await initDatabase();

    List<Map<String, dynamic>> documentos = [];

    final docs = await op.obtenerDocumentosXsolicitud(idSolicitudLocal!);

    if (docs.isNotEmpty) {
      for (var doc in docs) {
        final person = await op.obtenerPersona(doc.idPersona);
        if (person != null) doc.idPersona = person.idRDS!;
        documentos.add(doc.toJson()
          ..remove("id_solicitud")
          ..remove("estado")
          ..remove("id_rds"));
      }
    }

    sol.estado = 3;

    var base64 = await generatePdf(sol);

    try {
      final insert = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "insertAll",
            "info": {
              "solicitud": [
                sol.toJson()
                  ..remove("documentos")
                  ..addAll({"codigo_pdf": base64})
              ],
              "documentos": [for (var doc in documentos) doc]
            },
          }));

      if (insert.statusCode > 199 && insert.statusCode < 300) {
        final decode = jsonDecode(insert.body);
        final idRDS = decode["id_solicitud"];

        debugPrint(
            "SOLICITUD Y DOCUMENTOS INGRESADOS - ID RDS SOLICITUD: ${idRDS[0]}");

        //luego de insertar la solicitud se actualiza el id rds local
        final res = await db.rawUpdate(
            "UPDATE tbl_solicitud SET id_rds = ?, estado = ? WHERE id_solicitud = ?",
            [idRDS, 3, idSolicitudLocal]);

        debugPrint("ID RDS LOCAL DE LA SOLICITUD ACTUALIZADA: $res");
        return idRDS[0];
      } else {
        return 0;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
