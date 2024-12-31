import 'dart:convert';

import 'package:flutter/material.dart';

class BeneficiarioNotifier extends ChangeNotifier {
  String toJson() => jsonEncode({"beneficiario": beneficiario});

  Map<String, dynamic> get beneficiario => _beneficiario;

  final Map<String, dynamic> _beneficiario = {
    "nombres": null,
    "apellidos": null,
    "celular1": null,
    "celular2": null,
    "tipo_identificacion": null,
    "numero_identificacion": null,
    "direccion_entrega": null,
    "latitud": null,
    "longitud": null,
  };
  String? getValueBeneficiario(String key) => _beneficiario[key];

  void updateValueBeneficiario(String key, String? value) {
    _beneficiario[key] = value;
    notifyListeners();
  }

  void limpiarDatos() {
    _beneficiario["nombres"] = null;
    _beneficiario["apellidos"] = null;
    _beneficiario["tipo_identificacion"] = null;
    _beneficiario["numero_identificacion"] = null;
    _beneficiario["direccion_entrega"] = null;
    _beneficiario["latitud"] = null;
    _beneficiario["longitud"] = null;
  }
}
