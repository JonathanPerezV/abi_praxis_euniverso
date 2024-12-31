import 'dart:convert';

import 'package:intl/intl.dart';

class SolicitudCreditoModel {
  int? idSolicitud;
  int idPersona;
  int idPromotor;
  int idTipoProducto;
  String datosPersonales; //codificado - convertir a map
  String datosBeneficiario; //codificado - convertir a map
  String datosSuscripcion; //codificado - convertir a map
  String autorizacion; //codificado - convertir a map
  String? documentos;
  String? motivoRechazo;
  String? codigoPDF;
  String? fechaCreacion;
  String? horaCreacion;
  int? usuarioCreacion;
  String? codigoContrato;
  int estado;

  SolicitudCreditoModel(
      {this.idSolicitud,
      required this.usuarioCreacion,
      required this.idPersona,
      required this.idPromotor,
      required this.idTipoProducto,
      required this.datosPersonales,
      required this.datosBeneficiario,
      required this.datosSuscripcion,
      this.documentos,
      required this.autorizacion,
      this.motivoRechazo,
      this.codigoPDF,
      required this.estado,
      this.fechaCreacion,
      this.horaCreacion,
      this.codigoContrato});

  Map<String, dynamic> toJson() => {
        "id_persona": idPersona,
        "id_promotor": idPromotor,
        "id_tipo_producto": idTipoProducto,
        "datos_personales": jsonEncode(datosPersonales),
        "datos_beneficiario": jsonEncode(datosBeneficiario),
        "datos_suscripcion": jsonEncode(datosSuscripcion),
        "autorizacion": jsonEncode(autorizacion),
        "documentos": jsonEncode(documentos),
        "motivo": motivoRechazo,
        "codigo_pdf": codigoPDF,
        "estado": estado,
        "codigo_contrato": codigoContrato,
        "fecha_creacion": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "hora_creacion": DateFormat("HH:mm:ss").format(DateTime.now()),
        "usuario_creacion": usuarioCreacion
      };

  factory SolicitudCreditoModel.fromJson(Map<String, dynamic> json) {
    return SolicitudCreditoModel(
        idSolicitud: json["id_solicitud"],
        idPersona: json["id_persona"],
        idPromotor: json["id_promotor"],
        idTipoProducto: json["id_tipo_producto"],
        datosPersonales: jsonDecode(json["datos_personales"]),
        datosBeneficiario: jsonDecode(json["datos_beneficiario"]),
        datosSuscripcion: jsonDecode(json["datos_suscripcion"]),
        autorizacion: jsonDecode(json["autorizacion"]),
        documentos: jsonDecode(json["documentos"]),
        codigoPDF: json["codigo_pdf"],
        motivoRechazo: json["motivo"],
        estado: json["estado"],
        fechaCreacion: json["fecha_creacion"],
        horaCreacion: json["hora_creacion"],
        codigoContrato: json["codigo_contrato"],
        usuarioCreacion: json["usuario_creacion"] ?? 1);
  }
}
