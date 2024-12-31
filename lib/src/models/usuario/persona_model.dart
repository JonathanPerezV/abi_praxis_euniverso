import 'package:intl/intl.dart';

class PersonaModel {
  int? idPersona;
  int? usuarioCreacion;
  final String? numeroIdentificacion;
  final String nombres;
  final String apellidos;
  final String? celular1;
  final String? celular2;
  final String? direccion;
  final String? sector;
  final String? latitud;
  final String? longitud;
  final String? direccionTrabajo;
  final String? latitudTrabajo;
  final String? longitudTrabajo;
  final String? referencia;
  final String? referenciaTrabajo;
  final String? mail;
  final String? empresaNegocio;
  final int? pais;
  final int? provincia;
  final int? ciudad;
  final String? fotoReferenciaCasa;
  final String? fotoReferenciaTrabajo;
  final String? fechaUpdate;
  final String? fechaNacimiento;
  final String? edad;
  final String? genero;
  final String? observacion;
  int? idRDS;
  final String? parentesco;

  ///
  ///Estado A= ACTIVO | I= INACTIVO
  ///
  String? estado;
  int? idAux; //id prospecto o id cliente

  PersonaModel(
      {this.idPersona,
      this.parentesco,
      this.numeroIdentificacion,
      required this.usuarioCreacion,
      required this.nombres,
      required this.apellidos,
      this.celular1,
      this.celular2,
      this.direccion,
      this.sector,
      this.latitud,
      this.longitud,
      this.direccionTrabajo,
      this.latitudTrabajo,
      this.longitudTrabajo,
      this.referencia,
      this.referenciaTrabajo,
      this.mail,
      this.empresaNegocio,
      this.pais,
      this.provincia,
      this.ciudad,
      this.fotoReferenciaCasa,
      this.fotoReferenciaTrabajo,
      this.fechaUpdate,
      this.fechaNacimiento,
      this.edad,
      this.genero,
      this.observacion,
      this.estado,
      this.idAux,
      this.idRDS});

  Map<String, dynamic> toJson() => {
        "id_persona": idPersona,
        "usuario_creacion": usuarioCreacion,
        "numero_identificacion": numeroIdentificacion,
        "nombres": nombres.toUpperCase(),
        "apellidos": apellidos.toUpperCase(),
        "celular1": celular1,
        "celular2": celular2,
        "direccion": direccion,
        "sector": sector,
        "latitud": latitud,
        "longitud": longitud,
        "direccion_trabajo": direccionTrabajo,
        "latitud_trabajo": latitudTrabajo,
        "longitud_trabajo": longitudTrabajo,
        "referencia": referencia,
        "referencia_trabajo": referenciaTrabajo,
        "mail": mail,
        "empresa_negocio": empresaNegocio,
        "pais": pais,
        "provincia": provincia,
        "ciudad": ciudad,
        "foto_referencia_casa": fotoReferenciaCasa,
        "foto_referencia_trabajo": fotoReferenciaTrabajo,
        "fecha_update": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "fecha_nacimiento": fechaNacimiento,
        "edad": edad,
        "genero": genero,
        "observacion": observacion,
        "estado": estado,
        "id_rds": idRDS
      };

  factory PersonaModel.fromJson(Map<String, dynamic> json) => PersonaModel(
      usuarioCreacion: json["usuario_creacion"] ?? 1,
      idPersona: json["id_persona"],
      numeroIdentificacion: json["numero_identificacion"],
      nombres: json["nombres"],
      apellidos: json["apellidos"],
      celular1: json["celular1"],
      celular2: json["celular2"],
      direccion: json["direccion"],
      sector: json["sector"],
      latitud: json["latitud"],
      longitud: json["longitud"],
      direccionTrabajo: json["direccion_trabajo"],
      latitudTrabajo: json["latitud_trabajo"],
      longitudTrabajo: json["longitud_trabajo"],
      referencia: json["referencia"],
      referenciaTrabajo: json["referencia_trabajo"],
      mail: json["mail"],
      empresaNegocio: json["empresa_negocio"],
      pais: json["pais"],
      provincia: json["provincia"],
      ciudad: json["ciudad"],
      fotoReferenciaCasa: json["foto_referencia_casa"],
      fotoReferenciaTrabajo: json["foto_referencia_trabajo"],
      fechaUpdate: json["fecha_update"],
      fechaNacimiento: json["fecha_nacimiento"],
      edad: json["edad"],
      genero: json["genero"],
      observacion: json["observacion"],
      estado: json["estado"],
      idAux: json["id_aux"],
      idRDS: json["id_rds"]);
}
