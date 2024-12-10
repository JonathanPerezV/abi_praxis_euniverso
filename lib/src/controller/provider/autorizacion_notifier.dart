import 'dart:convert';

import 'package:flutter/material.dart';

class AutorizacionNotifier extends ChangeNotifier {
  String toJson() => jsonEncode({"autorizacion": _autorizacion});

  final Map<String, dynamic> _autorizacion = {
    "prospecto": null,
    "conyuge": null,
    "garante": null,
    "conyuge_garante": null
  };
  String? getValueAutorizacion(String key) => _autorizacion[key];

  void updateValueAutorizacion(String key, String? value) {
    _autorizacion[key] = value;
    notifyListeners();
  }

  void limpiarDatos() {
    _autorizacion["prospecto"] = null;
    _autorizacion["conyuge"] = null;
    _autorizacion["garante"] = null;
    _autorizacion["conyuge_garante"] = null;
  }
}
