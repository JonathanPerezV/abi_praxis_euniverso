import 'package:intl/intl.dart';

class DocumentosSolicitudModel {
  DocumentosSolicitudModel({
    required this.idSolicitud,
    required this.idPersona,
    required this.codigoDocumento,
    required this.tipoDocumento,
    required this.observacion,
    required this.usuarioCreacion,
    required this.isPdf,
    required this.estado,
    this.idDocumento,
    this.fechaCreacion,
    this.horaCreacion,
  });
  int? idDocumento;
  int idPersona;
  int? idSolicitud;
  int isPdf;

  ///
  ///PATH O RUTA DEL DOCUMENTO
  ///
  String codigoDocumento;

  ///
  ///1:Cédula
  ///
  ///2:Impuesto predial
  ///
  ///3:Planilla servicios básicos
  ///
  ///4:Buró de crédito
  ///
  ///5:Justificaciónde actividad económica
  ///
  ///6:Excepción
  ///
  ///7:Otros
  ///
  int tipoDocumento;

  ///opcional...
  String observacion;

  ///fecha actual de envío
  String? fechaCreacion;

  ///hora actual de envío
  String? horaCreacion;

  ///usuario de creación
  int usuarioCreacion;

  ///estado del documento
  String estado;

  factory DocumentosSolicitudModel.fromJson(Map<String, dynamic> json) {
    return DocumentosSolicitudModel(
        idPersona: json["id_persona"],
        isPdf: json["is_pdf"],
        idSolicitud: json["id_solicitud"],
        codigoDocumento: json["codigo_documento"],
        tipoDocumento: json["tipo_documento"],
        observacion: json["observacion"],
        fechaCreacion: json["fecha_creacion"],
        horaCreacion: json["hora_creacion"],
        usuarioCreacion: json["usuario_creacion"],
        estado: json["estado"],
        idDocumento: json["id_documento_solicitud"]);
  }

  Map<String, dynamic> toJson() => {
        "codigo_documento": codigoDocumento,
        "tipo_documento": tipoDocumento,
        "observacion": observacion,
        "fecha_creacion": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "hora_creacion": DateFormat("HH:mm:ss").format(DateTime.now()),
        "id_persona": idPersona,
        "is_pdf": isPdf,
        "usuario_creacion": usuarioCreacion,
        "id_solicitud": idSolicitud,
        "estado": estado
      };
}
