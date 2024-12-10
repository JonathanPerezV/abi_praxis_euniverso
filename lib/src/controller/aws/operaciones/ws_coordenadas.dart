import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:abi_praxis_app/src/models/coordenadas_model.dart';

class WsCoordenadas {
  final String _url = dotenv.env["ws_coordenadas"]!;

  Future<int> insertarCoordenada(CoordenadasModel coor) async {
    int res = 0;
    try {
      final data = await http.post(Uri.parse(_url),
          body: jsonEncode({"operacion": "ubicacion", "info": coor.toJson()}));

      final decode = jsonDecode(data.body);
      if (data.statusCode == 200) {
        res = decode["id_ingresado"];
      }
    } catch (e) {
      debugPrint("error $e");
      rethrow;
    }
    return res;
  }
}
