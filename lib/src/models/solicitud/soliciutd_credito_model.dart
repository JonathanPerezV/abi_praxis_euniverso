import 'dart:convert';

import 'package:intl/intl.dart';

class SolicitudCreditoModel {
  int? idSolicitud;
  int idAutorizacion;
  int idPersona;
  int idPromotor;
  int idTipoProducto;
  String? monto;
  String datosPersonales; //codificado - convertir a map
  String datosConyuge; //codificado - convertir a map
  String datosGarante; //codificado - convertir a map
  String refPersonales; //codificado - convertir a map
  String refEconomicas; //codificado - convertir a map
  String solicitudProd; //codificado - convertir a map
  String autorizacion; //codificado - convertir a map
  String? documentos;
  String? motivoRechazo;
  String? codigoPDF;
  String? fechaCreacion;
  String? horaCreacion;
  int? usuarioCreacion;
  int estado;

  SolicitudCreditoModel(
      {this.idSolicitud,
      required this.usuarioCreacion,
      required this.idAutorizacion,
      required this.idPersona,
      required this.idPromotor,
      required this.idTipoProducto,
      this.monto,
      required this.datosPersonales,
      this.documentos,
      required this.datosConyuge,
      required this.datosGarante,
      required this.refPersonales,
      required this.refEconomicas,
      required this.solicitudProd,
      required this.autorizacion,
      this.motivoRechazo,
      this.codigoPDF,
      required this.estado,
      this.fechaCreacion,
      this.horaCreacion});

  Map<String, dynamic> toJson() => {
        "id_autorizacion": idAutorizacion,
        "id_persona": idPersona,
        "id_promotor": idPromotor,
        "id_tipo_producto": idTipoProducto,
        "monto": monto,
        "datos_personales": jsonEncode(datosPersonales),
        "datos_conyuge": jsonEncode(datosConyuge),
        "datos_garante": jsonEncode(datosGarante),
        "referencias_personales": jsonEncode(refPersonales),
        "referencias_economicas": jsonEncode(refEconomicas),
        "solicitud_producto": jsonEncode(solicitudProd),
        "autorizacion": jsonEncode(autorizacion),
        "documentos": jsonEncode(documentos),
        "motivo": motivoRechazo,
        "codigo_pdf": codigoPDF,
        "estado": estado,
        "fecha_creacion": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "hora_creacion": DateFormat("HH:mm:ss").format(DateTime.now()),
        "usuario_creacion": usuarioCreacion
      };

  factory SolicitudCreditoModel.fromJson(Map<String, dynamic> json) {
    return SolicitudCreditoModel(
        idSolicitud: json["id_solicitud"],
        idAutorizacion: json["id_autorizacion"],
        idPersona: json["id_persona"],
        idPromotor: json["id_promotor"],
        idTipoProducto: json["id_tipo_producto"],
        datosPersonales: jsonDecode(json["datos_personales"]),
        datosConyuge: jsonDecode(json["datos_conyuge"]),
        datosGarante: jsonDecode(json["datos_garante"]),
        refPersonales: jsonDecode(json["referencias_personales"]),
        refEconomicas: jsonDecode(json["referencias_economicas"]),
        solicitudProd: jsonDecode(json["solicitud_producto"]),
        autorizacion: jsonDecode(json["autorizacion"]),
        documentos: jsonDecode(json["documentos"]),
        codigoPDF: json["codigo_pdf"],
        monto: json["monto"],
        motivoRechazo: json["motivo"],
        estado: json["estado"],
        fechaCreacion: json["fecha_creacion"],
        horaCreacion: json["hora_creacion"],
        usuarioCreacion: json["usuario_creacion"] ?? 1);
  }
}
