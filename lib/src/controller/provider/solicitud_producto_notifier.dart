import 'dart:convert';

import 'package:flutter/material.dart';

class SolicitudProductoNotifier extends ChangeNotifier {
  //todo obtener todo el mapa
  String toJson() => jsonEncode({"solicitud": _solicitud});

  //todo Mapa y obtencion de valor de solicitud de producto
  final Map<String, dynamic> _solicitud = {
    "monto": null,
    "destino": null,
    "otro_destino": null,
    "pago_cuota": null,
    "plazo": null,
    "frecuencia": null,
  };
  String? getValueSolicitud(String key) => _solicitud[key].toString();

  void updateValueSolicitud(String key, String? value) {
    _solicitud[key] = value;
    notifyListeners();
  }

  void limpiarDatos() {
    _solicitud["monto"] = null;
    _solicitud["destino"] = null;
    _solicitud["otro_destino"] = null;
    _solicitud["pago_cuota"] = null;
    _solicitud["plazo"] = null;
    _solicitud["frecuencia"] = null;

    notifyListeners();
  }
}
