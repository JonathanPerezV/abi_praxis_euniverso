import 'dart:convert';

import 'package:abi_praxis_app/src/models/usuario/persona_model.dart';
import 'package:flutter/material.dart';

class TitularNotifier extends ChangeNotifier {
  //todo obtener mapa completo para subir a base:
  String toJson() => jsonEncode({
        "datos": datos,
        "nacimiento": nacimiento,
        "identificacion": identificacion,
        "residencia": residencia,
        "educacion": educacion,
        "actividad_principal": actividadPrin,
        "actividad_secundaria": actvidadSec,
        "economia": sitEconomica,
        "estado_civil": estadoCivil,
      });

  //todo obtener Mapas por subsecciones
  Map<String, dynamic> get datos => _datos;
  Map<String, dynamic> get nacimiento => _nacimiento;
  Map<String, dynamic> get identificacion => _identificacion;
  Map<String, dynamic> get residencia => _residencia;
  Map<String, dynamic> get educacion => _educacion;
  Map<String, dynamic> get actividadPrin => _actEconPrin;
  Map<String, dynamic> get actvidadSec => _actEconSecun;
  Map<String, dynamic> get sitEconomica => _sitEconomica;
  Map<String, dynamic> get estadoCivil =>
      _estCivil..addAll({"dependientes": _dependientes});

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

  //todo mapa y obtencion de valor de mapa NACIMIENTO - TITULAR
  final Map<String, dynamic> _nacimiento = {
    "pais": null,
    "provincia": null,
    "ciudad": null,
    "fecha": null,
    "edad": null,
    "genero": null,
    "etnia": null,
    "otra_etnia": null,
  };
  String? getValueNacimiento(String key) => _nacimiento[key].toString();

  //todo mapa y obtencion de valor de mapa IDENTIFICACION - TITULAR
  final Map<String, dynamic> _identificacion = {
    "cedula": null,
    "ruc_id": null,
    "pasaporte": null,
    "fecha_exp_p": null,
    "fecha_cad_p": null,
    "fecha_entrada": null,
    "estado_migratorio": null,
  };
  String? getValueIdentificacion(String key) => _identificacion[key].toString();

  //todo mapa y obtencion de valor de mapa RESIDENCIA - TITULAR
  final Map<String, dynamic> _residencia = {
    "pais": null,
    "provincia": null,
    "ciudad": null,
    "parroquia": null,
    "barrio": null,
    "direccion": null,
    "latitud": null,
    "longitud": null,
    "tipo_vivienda": null,
    "valor": null,
    "tiempo_vivienda": null,
    "sector": null,
  };
  String? getValueResidencia(String key) => _residencia[key].toString();

  //todo mapa y obtencion de valor de mapa EDUCACION - TITULAR
  final Map<String, dynamic> _educacion = {
    "estudio": null,
    "profesion": null,
    "otra_profesion": null,
  };
  String? getValueEducacion(String key) => _educacion[key].toString();

  //todo mapa y obtencion de valor de mapa ACT ECON PRIN -  TITULAR
  final Map<String, dynamic> _actEconPrin = {
    "relacion_laboral": null,
    "tipo_negocio": null,
    "tiempo_negocio": null,
    "sector": null,
    "actividad": null,
    "codigo_act": null,
    "certificado": null,
    "nombre": null,
    "ruc": null,
    "num_empleados": null,
    "num_empleados_contratar": null,
    "tipo_local": null,
    "provincia": null,
    "ciudad": null,
    "parroquia": null,
    "barrio": null,
    "direccion": null,
    "latitud": null,
    "longitud": null,
    "referencia": null,
    "origen_ingresos": null,
    "inicio_trabajo": null,
    "correo": null,
    "telefono": null,
    "cargo": null,
    "inicio_trabajo_ant": null,
    "salida_trabajo_ant": null,
    "otra_actividad": null,
    "info_actividad": null
  };
  String? getValueActPrin(String key) => _actEconPrin[key].toString();

  //todo mapa y obtencion de valor de mapa ACT ECON SECU - TITULAR
  final Map<String, dynamic> _actEconSecun = {
    "relacion_laboral": null,
    "tipo_negocio": null,
    "tiempo_negocio": null,
    "sector": null,
    "actividad": null,
    "codigo_act": null,
    "certificado": null,
    "nombre": null,
    "ruc": null,
    "num_empleados": null,
    "num_empleados_contratar": null,
    "tipo_local": null,
    "provincia": null,
    "ciudad": null,
    "parroquia": null,
    "barrio": null,
    "direccion": null,
    "latitud": null,
    "longitud": null,
    "referencia": null,
    "origen_ingresos": null,
    "inicio_trabajo": null,
    "correo": null,
    "telefono": null,
    "cargo": null,
    "inicio_trabajo_ant": null,
    "salida_trabajo_ant": null,
    "otra_actividad": null,
    "info_actividad": null
  };
  String? getValueActSec(String key) => _actEconSecun[key].toString();

  //todo mapa y obtencion de valor de mapa SIT ECONOMICA - TITULAR
  final Map<String, dynamic> _sitEconomica = {
    "sueldo": null,
    "ventas": null,
    "otro_ingreso": null,
    "info_otro_ingreso": null,
    "total_ingreso": null,
    "gastos_personales": null,
    "gastos_operacionales": null,
    "otro_egreso": null,
    "info_otro_egreso": null,
    "total_egreso": null,
    "saldo": null,
    "efectivo": null,
    "banco": null,
    "cuentas": null,
    "inventarios": null,
    "propiedades": null,
    "vehiculos": null,
    "otro_activo": null,
    "info_otro_activo": null,
    "total_activo": null,
    "pasivo_corto": null,
    "pasivo_largo": null,
    "total_pasivo": null,
    "patrimonio": null,
  };
  String? getValueSitEcon(String key) => _sitEconomica[key].toString();

  //todo mapa y obtencion de valor de mapa ESTADO CIVIL - TITULAR
  final Map<String, dynamic> _estCivil = {
    "estado_civil": null,
  };
  String? getValueEstadoCivil(String key) => _estCivil[key].toString();

  final List<PersonaModel> _dependientes = [];
  List<PersonaModel> get getDependientes => _dependientes;

  //todo actualizar dato del titular
  void updateValueTitular(String key, String? value) {
    _datos[key] = value;
    notifyListeners();
  }

  //todo actualizar dato del nacimiento
  void updateValueNacimiento(String key, String? value) {
    _nacimiento[key] = value;
    notifyListeners();
  }

  //todo actualizar dato de identificacion
  void updateValueIdentificacion(String key, String? value) {
    _identificacion[key] = value;
    notifyListeners();
  }

  //todo actualizar dato de residencia
  void updateValueResidencia(String key, String? value) {
    _residencia[key] = value;
    notifyListeners();
  }

  //todo actualizar dato de educacion
  void updateValueEducacion(String key, String? value) {
    _educacion[key] = value;
    notifyListeners();
  }

  //todo actualzizar dato de Act economica
  void updateValueActEconomica(String key, String? value) {
    _actEconPrin[key] = value;
    notifyListeners();
  }

  //todo actualzizar dato de Act economica 2
  void updateValueActEconomicaSec(String key, String? value) {
    _actEconSecun[key] = value;
    notifyListeners();
  }

  //todo actualizar dato de situacion economica
  void updateValueSitEcon(String key, String? value) {
    _sitEconomica[key] = value;
    notifyListeners();
  }

  //todo actualiza dato de estado civil
  void updateValueEstadoCivil(String key, String? value) {
    _estCivil[key] = value;
    notifyListeners();
  }

  void addDependiente(PersonaModel dep) {
    _dependientes.add(dep);
    notifyListeners();
  }

  void removeDependiente(int id) {
    _dependientes.removeAt(id);
    notifyListeners();
  }

  void limpiarDatos() {
    _datos["nombres"] = null;
    _datos["apellidos"] = null;
    _datos["celular1"] = null;
    _datos["celular2"] = null;
    _datos["telefono"] = null;
    _datos["correo"] = null;

    _nacimiento["pais"] = null;
    _nacimiento["provincia"] = null;
    _nacimiento["ciudad"] = null;
    _nacimiento["fecha"] = null;
    _nacimiento["edad"] = null;
    _nacimiento["genero"] = null;
    _nacimiento["etnia"] = null;
    _nacimiento["otra_etnia"] = null;

    _identificacion["cedula"] = null;
    _identificacion["ruc_id"] = null;
    _identificacion["pasaporte"] = null;
    _identificacion["fecha_exp_p"] = null;
    _identificacion["fecha_cad_p"] = null;
    _identificacion["fecha_entrada"] = null;
    _identificacion["estado_migratorio"] = null;

    _residencia["pais"] = null;
    _residencia["provincia"] = null;
    _residencia["ciudad"] = null;
    _residencia["parroquia"] = null;
    _residencia["barrio"] = null;
    _residencia["direccion"] = null;
    _residencia["latitud"] = null;
    _residencia["longitud"] = null;
    _residencia["tipo_vivienda"] = null;
    _residencia["valor"] = null;
    _residencia["tiempo_vivienda"] = null;
    _residencia["sector"] = null;

    _educacion["estudio"] = null;
    _educacion["profesion"] = null;
    _educacion["otra_profesion"] = null;

    _actEconPrin["relacion_laboral"] = null;
    _actEconPrin["tipo_negocio"] = null;
    _actEconPrin["tiempo_negocio"] = null;
    _actEconPrin["sector"] = null;
    _actEconPrin["actividad"] = null;
    _actEconPrin["codigo_act"] = null;
    _actEconPrin["certificado"] = null;
    _actEconPrin["nombre"] = null;
    _actEconPrin["ruc"] = null;
    _actEconPrin["num_empleados"] = null;
    _actEconPrin["num_empleados_contratar"] = null;
    _actEconPrin["tipo_local"] = null;
    _actEconPrin["provincia"] = null;
    _actEconPrin["ciudad"] = null;
    _actEconPrin["parroquia"] = null;
    _actEconPrin["barrio"] = null;
    _actEconPrin["direccion"] = null;
    _actEconPrin["latitud"] = null;
    _actEconPrin["longitud"] = null;
    _actEconPrin["referencia"] = null;
    _actEconPrin["origen_ingresos"] = null;
    _actEconPrin["inicio_trabajo"] = null;
    _actEconPrin["correo"] = null;
    _actEconPrin["telefono"] = null;
    _actEconPrin["cargo"] = null;
    _actEconPrin["inicio_trabajo_ant"] = null;
    _actEconPrin["salida_trabajo_ant"] = null;
    _actEconPrin["otra_actividad"] = null;
    _actEconPrin["info_actividad"] = null;

    _actEconSecun["relacion_laboral"] = null;
    _actEconSecun["tipo_negocio"] = null;
    _actEconSecun["tiempo_negocio"] = null;

    _actEconSecun["sector"] = null;
    _actEconSecun["actividad"] = null;
    _actEconSecun["codigo_act"] = null;
    _actEconSecun["certificado"] = null;
    _actEconSecun["nombre"] = null;
    _actEconSecun["ruc"] = null;
    _actEconSecun["num_empleados"] = null;
    _actEconSecun["num_empleados_contratar"] = null;
    _actEconSecun["tipo_local"] = null;
    _actEconSecun["provincia"] = null;
    _actEconSecun["ciudad"] = null;
    _actEconSecun["parroquia"] = null;
    _actEconSecun["barrio"] = null;
    _actEconSecun["direccion"] = null;
    _actEconSecun["latitud"] = null;
    _actEconSecun["longitud"] = null;
    _actEconSecun["referencia"] = null;
    _actEconSecun["origen_ingresos"] = null;
    _actEconSecun["inicio_trabajo"] = null;
    _actEconSecun["correo"] = null;
    _actEconSecun["relefono"] = null;
    _actEconSecun["cargo"] = null;
    _actEconSecun["inicio_trabajo_ant"] = null;
    _actEconSecun["salida_trabajo_ant"] = null;
    _actEconSecun["otra_actividad"] = null;
    _actEconSecun["info_actividad"] = null;

    _sitEconomica["sueldo"] = null;
    _sitEconomica["ventas"] = null;
    _sitEconomica["otro_ingreso"] = null;
    _sitEconomica["info_otro_ingreso"] = null;
    _sitEconomica["total_ingreso"] = null;
    _sitEconomica["gastos_personales"] = null;
    _sitEconomica["gastos_operacionales"] = null;
    _sitEconomica["otro_egreso"] = null;
    _sitEconomica["info_otro_egreso"] = null;
    _sitEconomica["total_egreso"] = null;
    _sitEconomica["saldo"] = null;
    _sitEconomica["efectivo"] = null;
    _sitEconomica["banco"] = null;
    _sitEconomica["cuentas"] = null;
    _sitEconomica["inventarios"] = null;
    _sitEconomica["propiedades"] = null;
    _sitEconomica["vehiculos"] = null;
    _sitEconomica["otro_activo"] = null;
    _sitEconomica["info_otro_activo"] = null;
    _sitEconomica["total_activo"] = null;
    _sitEconomica["pasivo_corto"] = null;
    _sitEconomica["pasivo_largo"] = null;
    _sitEconomica["total_pasivo"] = null;
    _sitEconomica["patrimonio"] = null;

    _estCivil["estado_civil"] = null;

    _dependientes.clear();
    notifyListeners();
  }
}
