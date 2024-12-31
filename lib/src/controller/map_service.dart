import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/mapas/detalle_place_model.dart';
import '../models/mapas/place_model.dart';

class WSSearchPlaces {
  Future<List<PlaceInfoModel>?> obtenerDetallesLugar(String text) async {
    final res = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/place/textsearch/json?query=$text&key=${dotenv.env["api_places"]}"));

    debugPrint("Dirección: $text|");

    if (res.statusCode == 200) {
      var decode = jsonDecode(res.body);
      var list = decode["results"] as List<dynamic>;

      return list.map((e) => PlaceInfoModel.fromJson(e)).toList();
    }

    return null;
  }

  Future<DetallesPlaceModel?> obtenerDireccionXCoordenada(
      LatLng coordenadas) async {
    final res = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${coordenadas.latitude},${coordenadas.longitude}&key=${dotenv.env["api_geocoding"]}"));

    if (res.statusCode == 200) {
      var decode = jsonDecode(res.body);
      debugPrint(decode["error_message"]);
      var list = decode["results"] as List<dynamic>;

      return DetallesPlaceModel.fromJson(list[0]);
    }

    return null;
  }
}
