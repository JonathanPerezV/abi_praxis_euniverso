import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/controller/preferences/user_preferences.dart';
import 'package:abi_praxis_app/src/models/calendarEvento/calendar_model.dart';
import 'package:abi_praxis_app/src/models/calendarEvento/correo_model.dart';
import 'package:abi_praxis_app/src/models/calendarEvento/documentos_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WSAgenda {
  static final String _url = dotenv.env["ws_agenda"]!;
  final pfrc = UserPreferences();
  final op = Operations();

  Future<int> insertarAgenda(
      CalendarModel ag, List<CorreoModel> correos, int idAgenda,
      {required int idPersonaRDS}) async {
    List<Map<String, dynamic>> listMails = [];

    if (correos.isNotEmpty) {
      for (var i = 0; i < correos.length; i++) {
        listMails.add(correos[i].toJson());
      }
    }

    ag.idPersona = idPersonaRDS;

    final res = await http.post(Uri.parse(_url),
        body: jsonEncode({
          "operacion": "insert",
          "info": {
            "agenda": [
              ag.toJson()
                ..remove("plan")
                ..remove("id_agenda")
                ..remove("id_rds")
            ],
            "correos": listMails
          }
        }));

    if (res.statusCode > 199 && res.statusCode < 300) {
      final bodyDecode = jsonDecode(res.body);

      final idRDS = bodyDecode["id_agenda"];

      debugPrint("AGENDA INGRESADA - ID RDS: $idRDS");

      await op.actualizarRDSAgendaYcorreos(idAgenda, idRDS);

      return idRDS;
    } else {
      return 0;
    }
  }

  Future<int> actualizarAgenda(CalendarModel ag, int idAgenda) async {
    try {
      final act = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "actualizar",
            "info": ag.toJsonUpdate()..addAll({"id_agenda": idAgenda})
          }));

      if (act.statusCode > 199 && act.statusCode < 300) {
        var decode = jsonDecode(act.body);

        if (decode["status"] == "ok") {
          debugPrint(
              "SE HA ACTUALIZADO LA AGENDA DE LA NUBE CON LA AGENDA LOCAL");
          return 1;
        } else {
          debugPrint("NO SE HA ACTUALIZADO LA AGENDA DE LA NUBE");
          debugPrint("resutlado de aws: ${decode["result"]}");
          return 0;
        }
      } else {
        debugPrint("ERROR DE SERVIDOR INTERNO, NO SE ACTUALIZÓ");
        return 0;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> insertarDocumentosAgenda(
      List<DocsModel> documentos, int idAgenda) async {
    for (var doc in documentos) {
      final res = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "documentos",
            "info": doc.toJson()..remove("id_rds")
          }));

      var decode = jsonDecode(res.body);
      if (res.statusCode > 199 && res.statusCode < 300) {
        if (decode["status"] == "ok") {
          var idDoc = decode["id_documento"];

          await op.actualizarDocumentoAgenda(doc.idDoc!, idDoc);

          debugPrint("DOCUMENTO DE LA AGENDA INGRESADO - ID RDS: $idDoc");
        }
      }
    }
  }

  Future<List<CalendarModel>> obtenerAgenda(
      {int? idAgenda, int? idPersonaRDS}) async {
    final listaAgendas = <CalendarModel>[];

    try {
      final agendas = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "obtener",
            "info": {"id_agenda": idAgenda, "id_persona": idPersonaRDS}
          }));

      if (agendas.statusCode > 199 && agendas.statusCode < 300) {
        final decodeData = jsonDecode(agendas.body);

        var listAgendas = decodeData["result"];

        if (listAgendas.isNotEmpty) {
          debugPrint("*********************************");
          debugPrint("TIENE AGENDAS EN LA NUBE");
          debugPrint("*********************************");
          for (var agendaData in listAgendas) {
            final listDocumentos = <DocsModel>[];
            final listCorreos = <CorreoModel>[];

            var agenda = CalendarModel.fromJson(agendaData["agenda"]);
            var documentos = agendaData["documentos"];
            var correos = agendaData["correos"];

            if (documentos.isNotEmpty) {
              for (var doc in documentos) {
                doc.addAll({"id_agenda": agenda.idAgenda});
                listDocumentos.add(DocsModel.fromJson(doc));
              }
            }

            if (correos.isNotEmpty) {
              for (var correo in correos) {
                correo.addAll({"id_agenda": agenda.idAgenda});
                listCorreos.add(CorreoModel.fromJson(correo));
              }
            }

            agenda.documentos = listDocumentos;
            agenda.correos = listCorreos;

            listaAgendas.add(agenda);
          }
        }
      } else {
        debugPrint("*********************************");
        debugPrint("NO TIENE AGENDAS EN LA NUBE");
        debugPrint("*********************************");
        return listaAgendas;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }

    return listaAgendas;
  }
}
