class ContactosPersonaModel {
  ContactosPersonaModel(
      {this.estado,
      required this.idPersona,
      this.idContactoPersona,
      required this.idTitular,
      required this.tipoContacto,
      this.observacion,
      this.referencia,
      this.idNube});

  int? idContactoPersona;
  int idTitular;
  int idPersona;
  String? observacion;
  int tipoContacto;
  String? estado;
  int? idNube;
  int? referencia;

  factory ContactosPersonaModel.fromJson(Map<String, dynamic> json) =>
      ContactosPersonaModel(
          idContactoPersona: json["id_contacto_persona"],
          idPersona: json["id_persona"],
          idTitular: json["id_titular"],
          tipoContacto: json["tipo_contacto"],
          observacion: json["observacion"],
          estado: json["estado"],
          idNube: json["id_rds"],
          referencia: json["referencia"]);

  Map<String, dynamic> toJson() => {
        "id_persona": idPersona,
        "id_titular": idTitular,
        "tipo_contacto": tipoContacto,
        "observacion": observacion,
        "estado": "A",
        "referencia": referencia ?? 0,
        "id_rds": idNube,
      };
}
