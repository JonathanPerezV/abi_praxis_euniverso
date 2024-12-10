import 'dart:convert';

import 'package:flutter/material.dart';

class ConyugeNotifier extends ChangeNotifier {
  //todo obtener mapa completo para subir a base:
  String toJson() => jsonEncode({
        "datos": datos,
        "nacimiento": nacimiento,
        "identificacion": identificacion,
        "educacion": educacion,
        "actividad_principal": actividadPrin,
        "estado_civil": estadoCivil,
      });

  //todo obtener Mapas por subsecciones
  Map<String, dynamic> get datos => _datos;
  Map<String, dynamic> get nacimiento => _nacimiento;
  Map<String, dynamic> get identificacion => _identificacion;
  Map<String, dynamic> get educacion => _educacion;
  Map<String, dynamic> get actividadPrin => _actividadEcon;
  Map<String, dynamic> get estadoCivil => _estadoCivil;

  //todo mapa y obtención de datos del conyuge
  final Map<String, dynamic> _datos = {
    "nombres": null,
    "apellidos": null,
    "celular1": null,
    "celular2": null
  };
  String? getValueDatos(key) => _datos[key].toString();

  //todo mapa y obtención de datos de nacimiento del conyuge
  final Map<String, dynamic> _nacimiento = {
    "pais": null,
    "provincia": null,
    "ciudad": null,
    "fecha": null,
    "edad": null,
    "genero": null
  };
  String? getValueNacimiento(key) => _nacimiento[key].toString();

  //todo mapa y obtención de datos de identificación del conyuge
  final Map<String, dynamic> _identificacion = {
    "cedula": null,
    "ruc_id": null,
    "pasaporte": null,
    "fecha_exp_p": null,
    "fecha_cad_p": null,
    "fecha_entrada": null,
    "estado_migratorio": null,
  };
  String? getValueIdentificacion(key) => _identificacion[key].toString();

  //todo mapa y obtención de datos de educación del conyuge
  final Map<String, dynamic> _educacion = {
    "estudio": null,
    "profesion": null,
    "otra_profesion": null,
  };
  String? getValueEducacion(key) => _educacion[key].toString();

  //todo mapa y obtención de datos de Actividad económica del conyuge
  final Map<String, dynamic> _actividadEcon = {
    "relacion_laboral": null,
    "tiempo_negocio": null,
    "sueldo": null,
    "nombre": null,
    "ruc": null,
    "provincia": null,
    "ciudad": null,
    "parroquia": null,
    "barrio": null,
    "direccion": null,
    "referencia": null,
    "origen_ingresos": null,
    "otra_actividad": null,
    "info_actividad": null
  };
  String? getValueActividadEcon(key) => _actividadEcon[key].toString();

  //todo mapa y obtención de datos de Estado civil del conyuge
  final Map<String, dynamic> _estadoCivil = {
    "estado_civil": null,
  };
  String? getValueEstadoCivil(key) => _estadoCivil[key].toString();

  //todo MÉTODOS PARA ACTUALIZAR VALORES
  void updateValueDatos(String key, String? value) {
    _datos[key] = value;
    notifyListeners();
  }

  void updateValueNacimiento(String key, String? value) {
    _nacimiento[key] = value;
    notifyListeners();
  }

  void updateValueIdentificacion(String key, String? value) {
    _identificacion[key] = value;
    notifyListeners();
  }

  void updateValueEducacion(String key, String? value) {
    _educacion[key] = value;
    notifyListeners();
  }

  void updateValueActividadEcon(String key, String? value) {
    _actividadEcon[key] = value;
    notifyListeners();
  }

  void updateValueEstadoCivil(String key, String? value) {
    _estadoCivil[key] = value;
    notifyListeners();
  }

  void limpiarDatos() {
    _datos["nombres"] = null;
    _datos["apellidos"] = null;
    _datos["celular1"] = null;
    _datos["celular2"] = null;

    _nacimiento["pais"] = null;
    _nacimiento["provincia"] = null;
    _nacimiento["ciudad"] = null;
    _nacimiento["fecha"] = null;
    _nacimiento["edad"] = null;
    _nacimiento["genero"] = null;

    _identificacion["cedula"] = null;
    _identificacion["ruc_id"] = null;
    _identificacion["pasaporte"] = null;
    _identificacion["fecha_exp_p"] = null;
    _identificacion["fecha_cad_p"] = null;
    _identificacion["fecha_entrada"] = null;
    _identificacion["estado_migratorio"] = null;

    _educacion["estudio"] = null;
    _educacion["profesion"] = null;
    _educacion["otra_profesion"] = null;

    _actividadEcon["relacion_laboral"] = null;
    _actividadEcon["tiempo_negocio"] = null;
    _actividadEcon["sueldo"] = null;
    _actividadEcon["nombre"] = null;
    _actividadEcon["ruc"] = null;
    _actividadEcon["provincia"] = null;
    _actividadEcon["ciudad"] = null;
    _actividadEcon["parroquia"] = null;
    _actividadEcon["barrio"] = null;
    _actividadEcon["direccion"] = null;
    _actividadEcon["referencia"] = null;
    _actividadEcon["origen_ingresos"] = null;
    _actividadEcon["otra_actividad"] = null;
    _actividadEcon["info_actividad"] = null;

    _estadoCivil["estado_civil"] = null;

    notifyListeners();
  }
}
