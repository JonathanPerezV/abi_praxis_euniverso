import 'dart:typed_data';

import 'package:intl/intl.dart';

class DocsModel {
  int? idDoc;
  int idAgenda;
  int usuarioCreacion;
  String nombreDoc;
  String? codImg;
  String? fechaCreacion = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String? horaCreacion = DateFormat("HH:mm").format(DateTime.now());
  String? estado;
  int? idNube;

  DocsModel(
      {this.idDoc,
      required this.nombreDoc,
      required this.codImg,
      required this.idAgenda,
      this.fechaCreacion,
      this.horaCreacion,
      this.estado,
      required this.usuarioCreacion,
      this.idNube});

  Map<String, dynamic> toJson() => {
        "nombre_documento": nombreDoc,
        "usuario_creacion": usuarioCreacion,
        "codigo_imagen": codImg,
        "id_agenda": idAgenda,
        "fecha_creacion": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "hora_creacion": DateFormat("HH:mm").format(DateTime.now()),
        "estado": "A",
        "id_rds": idNube,
      };

  factory DocsModel.fromJson(Map<String, dynamic> json) => DocsModel(
      idDoc: json["id_documento_agenda"],
      idAgenda: json["id_agenda"],
      nombreDoc: json["nombre_documento"],
      codImg: json["codigo_imagen"],
      fechaCreacion: json["fecha_creacion"],
      horaCreacion: json["hora_creacion"],
      estado: json["estado"],
      usuarioCreacion: json["usuario_creacion"] ?? 1,
      idNube: json["id_rds"]);
}
