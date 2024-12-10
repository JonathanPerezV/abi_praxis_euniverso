import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/models/usuario/contactos/contactos_model.dart';
import 'package:abi_praxis_app/src/models/usuario/persona_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WSContactos {
  final String _url = dotenv.env["ws_persona"]!;

  Future<int> insertarContactoPersona(
      PersonaModel persona, int idTitularRDS, int idTipoContacto,
      {required int idPersonaLocal, required int idContactoLocal}) async {
    final db = await initDatabase();

    try {
      final insert = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "insert_contacto",
            "info": persona.toJson()
              ..remove("id_rds")
              ..addAll(
                  {"id_titular": idTitularRDS, "tipo_contacto": idTipoContacto})
          }));

      if (insert.statusCode > 199 && insert.statusCode < 300) {
        final decode = jsonDecode(insert.body);
        final idRDSPersona = decode["id_persona"];
        final idRDSContacto = decode["id_contacto_persona"];
        debugPrint(
            "PERSONA INSERTADA CORRECTAMENTE - ID RDS: $idRDSPersona - ID CONTACTO RDS: $idRDSContacto");

        final res = await db.rawUpdate(
            "UPDATE tbl_persona SET id_rds = ? WHERE id_persona = ?",
            [idRDSPersona, idPersonaLocal]);

        debugPrint("ID RDS LOCAL DEL CONTACTO ACTUALIZADO: $res");

        final cont = await db.rawUpdate(
            "UPDATE tbl_contacto_persona SET id_rds = ? WHERE id_contacto_persona = ?",
            [idRDSContacto, idContactoLocal]);

        debugPrint("ID RDS LOCAL DEL CONTACTO ACTUALIZADO: $cont");

        return idRDSPersona;
      } else {
        return 0;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<List<ContactosPersonaModel>> obtenerContactosXtitular(
      int idTitular) async {
    List<ContactosPersonaModel> listContactos = [];

    try {
      final res = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "contacto",
            "info": {"id_titular": idTitular}
          }));

      if (res.statusCode > 199 && res.statusCode < 300) {
        final body = jsonDecode(res.body);
        final listResult = List<Map<String, dynamic>>.from(body["result"]);

        if (listResult.isNotEmpty) {
          final db = await initDatabase();

          listContactos = await Future.wait(listResult.map((e) async {
            var persona = PersonaModel.fromJson(e["persona"]);
            persona.idRDS = persona.idPersona;
            await db.insert(
                "tbl_persona", persona.toJson()..remove("id_persona"));

            var newContact = ContactosPersonaModel.fromJson(e["contacto"]);
            newContact.idNube = newContact.idContactoPersona;

            return newContact;
          }).toList());

          return listContactos;
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
