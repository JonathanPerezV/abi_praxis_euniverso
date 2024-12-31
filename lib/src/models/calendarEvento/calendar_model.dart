import 'package:abi_praxis_app/src/models/calendarEvento/correo_model.dart';
import 'package:abi_praxis_app/src/models/calendarEvento/documentos_model.dart';
import 'package:intl/intl.dart';

class CalendarModel {
  int? usuarioCreacion;
  int? idAgenda;
  int idPersona;
  String fechaReunion;
  String? correo;
  String horaInicio;
  String horaFin;
  int? categoriaProducto;
  int? producto;
  int? plan;
  int? medioContacto;
  int? gestion;
  String? nombres;
  String? apellidos;
  String? empresa;
  String lugarReunion;
  int? resultadoReunion;
  String? observacion;
  String? latitud;
  String? longitud;
  String? latitudLlegada;
  String? longitudLlegada;
  String? asistio;
  String? fotoReferencia;
  String? fechaCreacion = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String? horaCreacion = DateFormat("HH:mm").format(DateTime.now());
  int idPromotor;
  List<DocsModel>? documentos;
  List<CorreoModel>? correos;

  ///
  ///0: ACTIVA - 1: CANCELADA
  ///
  int estado;
  int? idNube;

  CalendarModel(
      {this.idAgenda,
      required this.usuarioCreacion,
      required this.categoriaProducto,
      required this.gestion,
      required this.idPersona,
      required this.lugarReunion,
      required this.medioContacto,
      required this.producto,
      required this.resultadoReunion,
      required this.fechaReunion,
      required this.horaFin,
      required this.horaInicio,
      this.observacion,
      this.latitud,
      this.longitud,
      required this.estado,
      this.fotoReferencia,
      required this.idPromotor,
      this.nombres,
      this.apellidos,
      this.empresa,
      this.plan,
      this.asistio,
      this.latitudLlegada,
      this.longitudLlegada,
      this.fechaCreacion,
      this.horaCreacion,
      this.correo,
      this.idNube,
      this.correos,
      this.documentos});

  Map<String, dynamic> toJson() => {
        "usuario_creacion": usuarioCreacion,
        "id_persona": idPersona,
        "categoria_producto": categoriaProducto,
        "producto": producto,
        "plan": plan,
        "medio_contacto": medioContacto,
        "gestion": gestion,
        "lugar_reunion": lugarReunion,
        "resultado_reunion": resultadoReunion,
        "fecha_reunion": fechaReunion,
        "hora_inicio": horaInicio,
        "hora_fin": horaFin,
        "observacion": observacion,
        "latitud": latitud,
        "longitud": longitud,
        "longitud_llegada": "",
        "latitud_llegada": "",
        "asistio": "",
        "foto_referencia": "",
        "estado": 0,
        "fecha_creacion": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "hora_creacion": DateFormat("HH:mm").format(DateTime.now()),
        "id_promotor": idPromotor,
        "id_rds": idNube,
      };

  Map<String, dynamic> toJsonUpdate() => {
        "usuario_creacion": usuarioCreacion,
        "id_persona": idPersona,
        "categoria_producto": categoriaProducto,
        "producto": producto,
        "plan": plan,
        "medio_contacto": medioContacto,
        "gestion": gestion,
        "lugar_reunion": lugarReunion,
        "resultado_reunion": resultadoReunion,
        "fecha_reunion": fechaReunion,
        "hora_inicio": horaInicio,
        "hora_fin": horaFin,
        "observacion": observacion,
        "latitud": latitud,
        "longitud": longitud,
        "longitud_llegada": "",
        "latitud_llegada": "",
        "asistio": "",
        "foto_referencia": "",
        "estado": 0,
        "id_promotor": idPromotor,
        "fecha_update": DateFormat("yyyy-MM-dd").format(DateTime.now())
      };

  factory CalendarModel.fromJson(Map<String, dynamic> json) => CalendarModel(
      usuarioCreacion: json["usuario_creacion"] ?? 1,
      idAgenda: json["id_agenda"],
      categoriaProducto: json["categoria_producto"],
      empresa: json["empresa_negocio"],
      nombres: json["nombres"],
      apellidos: json["apellidos"],
      gestion: json["gestion"],
      idPersona: json["id_persona"],
      lugarReunion: json["lugar_reunion"],
      medioContacto: json["medio_contacto"],
      producto: json["producto"],
      plan: json["plan"],
      resultadoReunion: json["resultado_reunion"],
      fechaReunion: json["fecha_reunion"],
      horaFin: json["hora_fin"],
      horaInicio: json["hora_inicio"],
      observacion: json["observacion"],
      latitud: json["latitud"],
      longitud: json["longitud"],
      latitudLlegada: json["latitud_llegada"],
      longitudLlegada: json["longitud_llegada"],
      asistio: json["asistio"],
      estado: json["estado"],
      fotoReferencia: json["foto_referencia"],
      fechaCreacion: json["fecha_creacion"],
      horaCreacion: json["hora_creacion"],
      idPromotor: json["id_promotor"] ?? 0,
      correo: json["correo"],
      idNube: json["id_rds"]);
}
