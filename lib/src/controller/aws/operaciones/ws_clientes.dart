import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:abi_praxis_app/src/models/usuario/cliente_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../dataBase/operations.dart';

class WSClientes {
  final String _url = dotenv.env["ws_cliente"]!;
  final op = Operations();

  Future<int> insertarCliente(ClienteModel cli,
      {int? idLocal, int? idPersona}) async {
    final db = await initDatabase();

    try {
      final insert = await http.post(Uri.parse(_url),
          body: jsonEncode(
              {"operacion": "insert", "info": cli.toJson()..remove("id_rds")}));

      if (insert.statusCode > 199 && insert.statusCode < 300) {
        final decode = jsonDecode(insert.body);
        final idRds = decode["id_cliente"];

        //todo luego de insertar a la persona se actualiza el id_rds local con el id de la nube
        final res = await db.rawUpdate(
            "UPDATE tbl_cliente SET id_rds = ? WHERE id_cliente = ?",
            [idRds, idLocal]);

        debugPrint("CLIENTE LOCAL ACTUALIZADO: $res");

        //todo buscar prospecto por id persona
        if (idPersona != null) {
          final prospecto = await db.rawQuery(
                  "SELECT * FROM tbl_prospecto WHERE id_persona = $idPersona")
              as List<Map<String, dynamic>>;

          //todo actualizar prospecto a estado inactivo porque ya es cliente
          if (prospecto.isNotEmpty) {
            final update = await db.rawQuery(
                "UPDATE tbl_prospecto SET estado = 1 WHERE id_prospecto = ${prospecto[0]["id_prospecto"]}");

            debugPrint("PROSPECTO ACTUALIZADO A INACTIVO: $update");
          }
        }

        return idRds;
      } else {
        return 0;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<ClienteModel?> obtenerCliente(
      {int? idCliente, int? idPersonaRDS}) async {
    try {
      final get = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "obtener",
            "info": {"id_persona": idPersonaRDS, "id_cliente": idCliente}
          }));

      if (get.statusCode > 199 && get.statusCode < 300) {
        var decode = jsonDecode(get.body);
        var cliente = ClienteModel.fromJson(decode["result"]);
        return cliente;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
