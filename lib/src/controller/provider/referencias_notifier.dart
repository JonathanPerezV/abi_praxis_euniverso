import 'dart:convert';

import 'package:flutter/material.dart';

class ReferenciasNotifier extends ChangeNotifier {
  //todo obtener mapa completo para subir a base:
  String toJson() => jsonEncode({
        "referencias": {
          "referencia_1": _ref1,
          "referencia_2": _ref2,
        },
      });

  //todo mapa y obtención de datos de referencia 1
  final Map<String, dynamic> _ref1 = {
    "id_persona": null,
    "nombres": null,
    "apellidos": null,
    "celular1": null,
    "celular2": null,
    "telefono": null,
    "direccion": null,
    "latitud": null,
    "longitud": null,
    "relacion": null,
    "otra_relacion": null,
    "relacion_laboral": null,
    "actividad": null,
  };
  String? getValueRef1(key) => _ref1[key].toString();

  //todo mapa y obtención de datos de referencia 2
  final Map<String, dynamic> _ref2 = {
    "id_persona": null,
    "nombres": null,
    "apellidos": null,
    "celular1": null,
    "celular2": null,
    "telefono": null,
    "direccion": null,
    "latitud": null,
    "longitud": null,
    "relacion": null,
    "otra_relacion": null,
    "relacion_laboral": null,
    "actividad": null,
  };
  String? getValueRef2(key) => _ref2[key].toString();

  //todo funciones para actualizar valor
  void updateValueRef1(String key, String? value) {
    _ref1[key] = value!;
    notifyListeners();
  }

  void updateValueRef2(String key, String? value) {
    _ref2[key] = value!;
    notifyListeners();
  }

  void limpiarDatos() {
    _ref1["id_persona"] = null;
    _ref1["nombres"] = null;
    _ref1["apellidos"] = null;
    _ref1["celular1"] = null;
    _ref1["celular2"] = null;
    _ref1["telefono"] = null;
    _ref1["direccion"] = null;
    _ref1["latitud"] = null;
    _ref1["longitud"] = null;
    _ref1["relacion"] = null;
    _ref1["otra_relacion"] = null;
    _ref1["relacion_laboral"] = null;
    _ref1["actividad"] = null;

    _ref2["id_persona"] = null;
    _ref2["nombres"] = null;
    _ref2["apellidos"] = null;
    _ref2["celular1"] = null;
    _ref2["celular2"] = null;
    _ref2["telefono"] = null;
    _ref2["direccion"] = null;
    _ref2["latitud"] = null;
    _ref2["longitud"] = null;
    _ref2["relacion"] = null;
    _ref2["otra_relacion"] = null;
    _ref2["relacion_laboral"] = null;
    _ref2["actividad"] = null;

    notifyListeners();
  }
}
