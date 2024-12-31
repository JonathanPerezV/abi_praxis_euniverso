class PlaceInfoModel {
  PlaceInfoModel({
    required this.businessStatus,
    required this.formattedAddress,
    required this.geometry,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconMaskBaseUri,
    required this.name,
    required this.openingHours,
    required this.photos,
    required this.placeId,
    required this.rating,
    required this.reference,
    required this.types,
    required this.userRatingsTotal,
  });

  final String? businessStatus;
  final String? formattedAddress;
  final Geometry? geometry;
  final String? icon;
  final String? iconBackgroundColor;
  final String? iconMaskBaseUri;
  final String? name;
  final OpeningHours? openingHours;
  final List<Photo> photos;
  final String? placeId;
  final dynamic rating;
  final String? reference;
  final List<String> types;
  final int? userRatingsTotal;

  factory PlaceInfoModel.fromJson(Map<String, dynamic> json) {
    return PlaceInfoModel(
      businessStatus: json["business_status"],
      formattedAddress: json["formatted_address"],
      geometry:
          json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
      icon: json["icon"],
      iconBackgroundColor: json["icon_background_color"],
      iconMaskBaseUri: json["icon_mask_base_uri"],
      name: json["name"],
      openingHours: json["opening_hours"] == null
          ? null
          : OpeningHours.fromJson(json["opening_hours"]),
      photos: json["photos"] == null
          ? []
          : List<Photo>.from(json["photos"]!.map((x) => Photo.fromJson(x))),
      placeId: json["place_id"],
      rating: json["rating"],
      reference: json["reference"],
      types: json["types"] == null
          ? []
          : List<String>.from(json["types"]!.map((x) => x)),
      userRatingsTotal: json["user_ratings_total"],
    );
  }
}

class Geometry {
  Geometry({
    required this.location,
    required this.viewport,
  });

  final Location? location;
  final Viewport? viewport;

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location:
          json["location"] == null ? null : Location.fromJson(json["location"]),
      viewport:
          json["viewport"] == null ? null : Viewport.fromJson(json["viewport"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
        "viewport": viewport?.toJson(),
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

class Viewport {
  Viewport({
    required this.northeast,
    required this.southwest,
  });

  final Location? northeast;
  final Location? southwest;

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
      northeast: json["northeast"] == null
          ? null
          : Location.fromJson(json["northeast"]),
      southwest: json["southwest"] == null
          ? null
          : Location.fromJson(json["southwest"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "northeast": northeast?.toJson(),
        "southwest": southwest?.toJson(),
      };
}

class OpeningHours {
  OpeningHours({
    required this.openNow,
  });

  final bool? openNow;

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    return OpeningHours(
      openNow: json["open_now"],
    );
  }

  Map<String, dynamic> toJson() => {
        "open_now": openNow,
      };
}

class Photo {
  Photo({
    required this.height,
    required this.htmlAttributions,
    required this.photoReference,
    required this.width,
  });

  final int? height;
  final List<String> htmlAttributions;
  final String? photoReference;
  final int? width;

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      height: json["height"],
      htmlAttributions: json["html_attributions"] == null
          ? []
          : List<String>.from(json["html_attributions"]!.map((x) => x)),
      photoReference: json["photo_reference"],
      width: json["width"],
    );
  }

  Map<String, dynamic> toJson() => {
        "height": height,
        "html_attributions": htmlAttributions.map((x) => x).toList(),
        "photo_reference": photoReference,
        "width": width,
      };
}
