class EstadoAutModel {
  EstadoAutModel(
      {this.idEstado, required this.descripcion, required this.estado});

  int? idEstado;
  String descripcion;
  String estado;

  factory EstadoAutModel.fromJson(Map<String, dynamic> json) => EstadoAutModel(
      idEstado: json["id_estado_autorizacion"],
      descripcion: json["descripcion"],
      estado: json["estado"]);

  Map<String, dynamic> toJson() =>
      {"descripcion": descripcion, "estado": estado};
}
