import 'package:intl/intl.dart';

class ClienteModel {
  int? idCliente;
  int idPersona;
  int idPromotor;

  ///
  ///Estado 0= ACTIVO | 1= INACTIVO
  ///
  int? estado;
  String? mora;
  String? calificacion;
  int? usuarioCreacion;
  String? fechaCreacion = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String? horaCreacion = DateFormat("HH:mm").format(DateTime.now());
  int? idNube;

  ClienteModel(
      {required this.idPersona,
      required this.idPromotor,
      this.estado,
      this.idCliente,
      this.calificacion,
      this.mora,
      this.fechaCreacion,
      this.horaCreacion,
      required this.usuarioCreacion,
      this.idNube});

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
        idCliente: json["id_cliente"],
        idPersona: json["id_persona"],
        idPromotor: json["id_promotor"],
        mora: json["mora"],
        calificacion: json["calificacion"],
        fechaCreacion: json["fecha_creacion"],
        horaCreacion: json["hora_creacion"],
        usuarioCreacion: json["usuario_creacion"] ?? 1,
        estado: json["estado"],
        idNube: json["id_rds"]);
  }

  Map<String, dynamic> toJson() => {
        "estado": estado,
        "id_persona": idPersona,
        "id_promotor": idPromotor,
        "usuario_creacion": usuarioCreacion,
        "mora": mora ?? 0,
        "calificacion": calificacion ?? 0,
        "fecha_creacion": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "hora_creacion": DateFormat("HH:mm").format(DateTime.now()),
        "id_rds": idNube
      };
}
