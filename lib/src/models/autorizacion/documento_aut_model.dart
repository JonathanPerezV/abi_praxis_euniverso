import 'package:intl/intl.dart';

class DocumentoAutModel {
  DocumentoAutModel({
    this.idDoc,
    this.tipoDoc,
    this.idUsuarioCreacion,
    this.estado,
    required this.codDoc,
    this.fechaCreacion,
    this.horaCreacion,
    this.idAut,
    required this.idPersona,
    required this.codImg,
    this.idNube,
  });

  int? idDoc;
  int? idAut;
  int idPersona;
  int? idUsuarioCreacion;
  String codDoc;
  String? tipoDoc;
  String codImg;
  String? estado;
  String? fechaCreacion = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String? horaCreacion = DateFormat("HH:mm").format(DateTime.now());
  int? idNube;

  factory DocumentoAutModel.fromJson(Map<String, dynamic> json) =>
      DocumentoAutModel(
          idDoc: json["id_documento"],
          idAut: json["id_autorizacion"],
          idPersona: json["id_persona"],
          codDoc: json["codigo_documento"],
          tipoDoc: json["tipo_documento"],
          codImg: json["codigo_imagen"],
          fechaCreacion: json["fecha_creacion"],
          horaCreacion: json["hora_creacion"],
          idUsuarioCreacion: json["usuario_creacion"] ?? 1,
          estado: json["estado"],
          idNube: json["id_rds"]);

  Map<String, dynamic> toJson() => {
        "id_autorizacion": idAut,
        "id_persona": idPersona,
        "codigo_documento": codDoc,
        "tipo_documento": tipoDoc,
        "codigo_imagen": codImg,
        "fecha_creacion": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "hora_creacion": DateFormat("HH:mm").format(DateTime.now()),
        "estado": "A",
        "id_rds": idNube,
      };
}
