import 'dart:convert';

import 'package:abi_praxis_app/src/models/usuario/persona_model.dart';
import 'package:flutter/material.dart';

class TitularNotifier extends ChangeNotifier {
  //todo obtener mapa completo para subir a base:
  String toJson() => jsonEncode({"datos": datos});

  //todo obtener Mapas por subsecciones
  Map<String, dynamic> get datos => _datos;

  //todo mapa y obtencion de valor de mapa TITULAR
  final Map<String, dynamic> _datos = {
    "nombres": null,
    "apellidos": null,
    "celular1": null,
    "celular2": null,
    "telefono": null,
    "correo": null,
  };
  String? getValueTitular(String key) => _datos[key].toString();

  //todo actualizar dato del titular
  void updateValueTitular(String key, String? value) {
    _datos[key] = value;
    notifyListeners();
  }

  void limpiarDatos() {
    _datos["nombres"] = null;
    _datos["apellidos"] = null;
    _datos["celular1"] = null;
    _datos["celular2"] = null;
    _datos["telefono"] = null;
    _datos["correo"] = null;

    notifyListeners();
  }
}
