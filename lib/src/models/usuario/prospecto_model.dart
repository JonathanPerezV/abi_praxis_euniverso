import 'package:intl/intl.dart';

class ProspectoModel {
  int? idProspecto;
  int idPersona;
  int idPromotor;

  ///
  ///Estado 0= ACTIVO | 1= INACTIVO
  ///
  int estado;
  String? fechaCreacion = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String? horaCreacion = DateFormat("HH:mm").format(DateTime.now());
  int usuarioCreacion;
  int? idNube;

  ProspectoModel(
      {required this.estado,
      required this.idPersona,
      required this.idPromotor,
      this.idProspecto,
      this.fechaCreacion,
      this.horaCreacion,
      required this.usuarioCreacion,
      this.idNube});

  factory ProspectoModel.fromJson(Map<String, dynamic> json) {
    return ProspectoModel(
        estado: json["estado"],
        idPersona: json["id_persona"],
        idProspecto: json["id_prospecto"],
        idPromotor: json["id_promotor"],
        fechaCreacion: json["fecha_creacion"],
        horaCreacion: json["hora_creacion"],
        usuarioCreacion: json["usuario_creacion"] ?? 1,
        idNube: json["id_rds"]);
  }

  Map<String, dynamic> toJson() => {
        "estado": estado,
        "id_persona": idPersona,
        "fecha_creacion": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "hora_creacion": DateFormat("HH:mm").format(DateTime.now()),
        "id_promotor": idPromotor,
        "usuario_creacion": usuarioCreacion,
        "id_rds": idNube,
      };
}
