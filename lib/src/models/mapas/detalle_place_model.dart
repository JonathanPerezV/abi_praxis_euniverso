class DetallesPlaceModel {
  DetallesPlaceModel({
    this.formattedAddress,
    this.geometry,
    required this.addressComponents,
  });

  String? formattedAddress;
  Geometry? geometry;
  final List<AddressComponent> addressComponents;

  factory DetallesPlaceModel.fromJson(Map<String, dynamic> json) {
    return DetallesPlaceModel(
      formattedAddress: json["formatted_address"],
      geometry:
          json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
      addressComponents: json["address_components"] == null
          ? []
          : List<AddressComponent>.from(json["address_components"]!
              .map((x) => AddressComponent.fromJson(x))),
    );
  }
}

class AddressComponent {
  AddressComponent({
    this.longName,
    this.types,
  });

  String? longName;
  List<String>? types;

  factory AddressComponent.fromJson(Map<String, dynamic> json) {
    return AddressComponent(
      longName: json["long_name"],
      types: json["types"] == null
          ? []
          : List<String>.from(json["types"]!.map((x) => x)),
    );
  }
}

class Geometry {
  Geometry({
    required this.location,
  });

  final Location? location;

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location:
          json["location"] == null ? null : Location.fromJson(json["location"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
      };
}

class Location {
  Location({
    required this.lat,
    required this.lng,
  });

  final double? lat;
  final double? lng;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json["lat"],
      lng: json["lng"],
    );
  }

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}
