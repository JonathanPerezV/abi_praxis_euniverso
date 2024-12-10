import 'package:intl/intl.dart';

class AutorizacionModel {
  AutorizacionModel(
      {required this.idPromotor,
      this.actividad,
      this.codActividad,
      this.cuota,
      this.fuente,
      this.idGarante,
      required this.idPersona,
      this.monto,
      this.plazo,
      this.relacionLaboral,
      this.sectorEconomico,
      this.tiempoFunciones,
      this.idAutorizacion,
      this.idCGarante,
      this.idCProspecto,
      this.telefonoTrabajo,
      this.fechaCreacion,
      this.horaCreacion,
      required this.idUsuarioCreacion,
      required this.estado,
      this.idNube});

  int? idAutorizacion;
  int idPromotor;
  int idPersona; //es un prospecto
  int? idCProspecto;
  int? idGarante;
  int? idCGarante;
  int? relacionLaboral;
  String? actividad;
  String? codActividad;
  int? sectorEconomico;
  String? tiempoFunciones;
  String? telefonoTrabajo;
  int? fuente;
  String? monto;
  int? plazo;
  String? cuota;
  String? fechaCreacion = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String? horaCreacion = DateFormat("HH:mm").format(DateTime.now());
  int estado;
  int? idUsuarioCreacion;
  int? idNube;

  factory AutorizacionModel.fromJson(Map<String, dynamic> json) =>
      AutorizacionModel(
          idPromotor: json["id_promotor"],
          idAutorizacion: json["id_autorizacion"],
          actividad: json["actividad"],
          codActividad: json["codigo_actividad"],
          cuota: json["cuota"],
          fuente: json["fuente"],
          idGarante: json["id_garante"],
          idPersona: json["id_persona"],
          monto: json["monto"],
          plazo: json["plazo"],
          relacionLaboral: json["relacion_laboral"],
          sectorEconomico: json["sector_economico"] != null
              ? int.parse(json["sector_economico"])
              : null,
          tiempoFunciones: json["tiempo_funciones"],
          idCGarante: json["id_conyuge_garante"],
          idCProspecto: json["id_conyuge_prospecto"],
          telefonoTrabajo: json["telefono_trabajo"],
          fechaCreacion: json["fecha_creacion"],
          horaCreacion: json["hora_creacion"],
          estado: json["estado"],
          idUsuarioCreacion: json["usuario_creacion"] ?? 1,
          idNube: json["id_rds"]);

  Map<String, dynamic> toJson() => {
        "id_promotor": idPromotor,
        "id_persona": idPersona,
        "id_conyuge_prospecto": idCProspecto,
        "id_garante": idGarante,
        "id_conyuge_garante": idCGarante,
        "relacion_laboral": relacionLaboral,
        "actividad": actividad,
        "codigo_actividad": codActividad,
        "sector_economico": sectorEconomico,
        "tiempo_funciones": tiempoFunciones,
        "telefono_trabajo": telefonoTrabajo,
        "fuente": fuente,
        "monto": monto,
        "plazo": plazo,
        "cuota": cuota,
        "usuario_creacion": idUsuarioCreacion,
        "fecha_creacion": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "hora_creacion": DateFormat("HH:mm").format(DateTime.now()),
        "estado": estado,
      };
}
