import 'dart:convert';

import 'package:flutter/material.dart';

class AutorizacionNotifier extends ChangeNotifier {
  String toJson() => jsonEncode({"autorizacion": _autorizacion});

  final Map<String, dynamic> _autorizacion = {
    "titular": null,
  };
  String? getValueAutorizacion(String key) => _autorizacion[key];

  void updateValueAutorizacion(String key, String? value) {
    _autorizacion[key] = value;
    notifyListeners();
  }

  void limpiarDatos() {
    _autorizacion["titular"] = null;
    notifyListeners();
  }
}
