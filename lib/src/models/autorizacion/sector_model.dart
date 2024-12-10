class SectorModel {
  SectorModel({this.idSector, required this.nombreSector});

  int? idSector;
  String nombreSector;

  factory SectorModel.fromJson(Map<String, dynamic> json) => SectorModel(
      idSector: json["id_sector"], nombreSector: json["nombre_sector"]);

  Map<String, dynamic> toJson() => {"nombre_sector": nombreSector};
}
