import 'package:intl/intl.dart';

class CorreoModel {
  int? idCorreo;
  String correo;
  int? idAgenda;
  String? estado;
  int? usuarioCreacion;
  int? idNube;
  String? fechaCreacion;
  String? horaCreacion;

  CorreoModel({
    required this.correo,
    required this.idAgenda,
    required this.usuarioCreacion,
    this.estado,
    this.idCorreo,
    this.fechaCreacion,
    this.horaCreacion,
    this.idNube,
  });

  Map<String, dynamic> toJson() => {
        "id_agenda": idAgenda,
        "mail": correo,
        "usuario_creacion": usuarioCreacion,
        "estado": "A",
        "fecha_creacion": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "hora_creacion": DateFormat("yyyy-MM-dd").format(DateTime.now())
      };

  factory CorreoModel.fromJson(Map<String, dynamic> json) => CorreoModel(
      usuarioCreacion: json["usuario_creacion"] ?? 1,
      correo: json["mail"],
      idAgenda: json["id_agenda"],
      idCorreo: json["id_correo_agenda"],
      estado: json["estado"],
      idNube: json["id_rds"],
      fechaCreacion: json["fecha_creacion"],
      horaCreacion: json["hora_creacion"]);
}
