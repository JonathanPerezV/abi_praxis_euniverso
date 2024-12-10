class RelacionModel {
  RelacionModel({this.idRelacion, required this.nombreRelacion});

  int? idRelacion;
  String nombreRelacion;

  factory RelacionModel.fromJson(Map<String, dynamic> json) => RelacionModel(
      idRelacion: json["id_relacion"], nombreRelacion: json["nombre_relacion"]);

  Map<String, dynamic> toJson() => {"nombre_relacion": nombreRelacion};
}
