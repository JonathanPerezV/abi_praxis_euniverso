class PlazoModel {
  PlazoModel({this.idPlazo, required this.nombrePlazo});

  int? idPlazo;
  String nombrePlazo;

  factory PlazoModel.fromJson(Map<String, dynamic> json) =>
      PlazoModel(idPlazo: json["id_plazo"], nombrePlazo: json["nombre_plazo"]);

  Map<String, dynamic> toJson() => {"nombre_plazo": nombrePlazo};
}
