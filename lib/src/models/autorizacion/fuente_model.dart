class FuenteModel {
  FuenteModel({this.idFuente, required this.nombreFuente});

  int? idFuente;
  String nombreFuente;

  factory FuenteModel.fromJson(Map<String, dynamic> json) => FuenteModel(
      idFuente: json["id_fuente"], nombreFuente: json["nombre_fuente"]);

  Map<String, dynamic> toJson() => {"nombre_fuente": nombreFuente};
}
