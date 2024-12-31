import 'package:abi_praxis_app/src/controller/aws/consultaInicial/ws_consulta_inicial.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:abi_praxis_app/src/controller/preferences/app_preferences.dart';
import 'package:abi_praxis_app/src/controller/preferences/user_preferences.dart';
import 'dart:convert';

import '../../background_service.dart';

class WSUsuario {
  final init = WsConsultaInicial();
  final String _url = dotenv.env["ws_usuario_prod"]!;

  Future<String> autenticarUser(
      {required String identification, required String password}) async {
    final pfrc = UserPreferences();
    final apppfrc = AppPreferences();

    //jperez123
    final bytes = utf8.encode(password);
    final convert = md5.convert(bytes).toString();
    try {
      final user = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "auth",
            "info": {"user": identification, "clave": convert}
          }));

      if (user.statusCode > 199 && user.statusCode < 300) {
        String? nombre;
        String? apellido;
        debugPrint("data: ${user.body}");
        final decode = jsonDecode(user.body);

        //await Operations().insertClientesProspectos();
        await pfrc.saveIdPromotor(decode["id_promotor"]);
        await pfrc.saveIdUsuario(decode["id_usuario"]);
        await pfrc.saveIdPersonaPromotor(decode["id_persona"]);
        await pfrc.saveUserIdentification(decode["login"]);
        await pfrc.saveTipoUsuario(decode["id_tipo_usuario"]);
        //todo obtenemos los datos iniciales del promotor
        if (decode["id_tipo_usuario"] == 2) {
          await init.obtenerDatosIniciales();
        }

        if (decode["nombres"].contains(" ")) {
          nombre = decode["nombres"].toString().split(" ")[0];
        } else {
          nombre = decode["nombres"];
        }
        if (decode["apellidos"].contains(" ")) {
          apellido = decode["apellidos"].split(" ")[0];
        } else {
          apellido = decode["apellidos"];
        }
        await pfrc.setFullName("$nombre $apellido");
        await pfrc.setUserName(decode["nombres"]);
        await pfrc.setUserLastName(decode["apellidos"]);
        await pfrc.setUserMail(decode["correo"]);
        await pfrc.savePathPhoto(decode["foto_usuario"]);

        //await initializeWorkManager(); if (data != 0) {
        await initializeService()
            .then((_) => FlutterBackgroundService().invoke("setAsForeground"));

        return "ok";
      } else {
        final decode = jsonDecode(user.body);

        String typeError = decode["status"];
        String errorMessage = decode["result"];

        return "$typeError,$errorMessage";
      }
    } catch (e) {
      debugPrint(e.toString());
      return "error: $e";
    }
  }

  Future<String> actualizarDatoUsuario({required String dato}) async {
    final pfrc = UserPreferences();

    final id = await pfrc.getIdPromotor();

    try {
      final update = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "actualizar",
            "info": {"id_usuario": id, "foto_usuario": dato}
          }));
      if (update.statusCode > 199 && update.statusCode < 300) {
        final decode = jsonDecode(update.body);

        return decode["status"];
      } else {
        final decode = jsonDecode(update.body);

        return decode["result"];
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
