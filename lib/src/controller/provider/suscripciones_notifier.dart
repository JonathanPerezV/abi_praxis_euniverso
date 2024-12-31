import 'dart:convert';

import 'package:flutter/material.dart';

class SuscripcionesNotifier extends ChangeNotifier {
  String toJson() => jsonEncode({"plan_suscripciones": suscripciones});

  Map<String, dynamic> get suscripciones => _suscripciones;

  final Map<String, dynamic> _suscripciones = {
    "plan": null,
    "id_plan": null,
    "pago": null,
    "id_pago": null,
    "informacion_adicional": null
  };
  String? getValueSuscripcion(String key) => _suscripciones[key].toString();

  void updateValueSuscripcion(String key, String? value) {
    _suscripciones[key] = value;
    notifyListeners();
  }

  void limpiarDatos() {
    _suscripciones["plan"] = null;
    _suscripciones["id_plan"] = null;
    _suscripciones["pago"] = null;
    _suscripciones["id_pago"] = null;
    _suscripciones["informacion_adicional"] = null;
  }
}
