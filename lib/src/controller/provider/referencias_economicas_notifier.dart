import 'dart:convert';

import 'package:flutter/material.dart';

class ReferenciasEconomicasNotifier extends ChangeNotifier {
  //todo obtener mapa completo para subir a base:
  String toJson() => jsonEncode({
        "datos_bancarios": _datosBancarios,
        "proveedor": _proveedor,
      });

  //todo mapa y obtención de valor de Datos bancarios
  final Map<String, dynamic> _datosBancarios = {
    "institucion": null,
    "corriente": null,
    "ahorros": null,
    "pdf": null,
    "tc": null,
  };
  String? getValueBancario(String key) => _datosBancarios[key];

  //todo mapa y obtención de valor de proveedor
  final Map<String, dynamic> _proveedor = {
    "institucion": null,
    "contacto": null,
    "celular": null
  };
  String? getValueProveedor(String key) => _proveedor[key];

  void updateValueDatosBancarios(String key, String? value) {
    _datosBancarios[key] = value;
    notifyListeners();
  }

  void updateValueProveedor(String key, String? value) {
    _proveedor[key] = value;
    notifyListeners();
  }

  void limpiarDatos() {
    _datosBancarios["institucion"] = null;
    _datosBancarios["corrientes"] = null;
    _datosBancarios["ahorros"] = null;
    _datosBancarios["pdf"] = null;
    _datosBancarios["tc"] = null;

    _proveedor["institucion"] = null;
    _proveedor["contacto"] = null;
    _proveedor["celular"] = null;

    notifyListeners();
  }
}
