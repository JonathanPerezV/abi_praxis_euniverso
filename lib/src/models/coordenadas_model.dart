import 'package:intl/intl.dart';

class CoordenadasModel {
  int idPromotor;
  String latitud;
  String longitud;
  String? observacion;
  int? usuarioCreacion;
  int tipoUsuario;

  CoordenadasModel(
      {required this.idPromotor,
      required this.tipoUsuario,
      required this.latitud,
      required this.longitud,
      required this.observacion,
      required this.usuarioCreacion});

  Map<String, dynamic> toJson() => {
        "id_promotor": idPromotor,
        "latitud": latitud,
        "tipo_usuario": tipoUsuario,
        "longitud": longitud,
        "observacion": observacion,
        "usuario_creacion": usuarioCreacion,
        "fecha_creacion": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "hora_creacion": DateFormat("HH:mm:ss").format(DateTime.now())
      };
}
