//     final busquedaResponse = busquedaResponseFromJson(jsonString);

import 'dart:convert';

BusquedaResponse busquedaResponseFromJson(String str) =>
    BusquedaResponse.fromJson(json.decode(str));

String busquedaResponseToJson(BusquedaResponse data) =>
    json.encode(data.toJson());

class BusquedaResponse {
  BusquedaResponse({
    this.type,
    // this.query,
    this.features,
    this.attribution,
  });

  String? type;
  // List<String>? query;
  List<Feature>? features;
  String? attribution;

  factory BusquedaResponse.fromJson(Map<String, dynamic> json) =>
      BusquedaResponse(
        type: json["type"],
        // query: List<String>.from(json["query"].map((x) => x)),
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
        attribution: json["attribution"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        // "query": List<dynamic>.from(query!.map((x) => x)),
        "features": List<dynamic>.from(features!.map((x) => x.toJson())),
        "attribution": attribution,
      };
}

Feature featureFromJson(String str) => Feature.fromJson(json.decode(str));

class Feature {
  Feature({
    this.id,
    this.type,
    this.placeType,
    this.relevance,
    this.properties,
    this.textEs,
    this.placeNameEs,
    this.text,
    this.placeName,
    this.center,
    this.geometry,
    this.context,
  });

  String? id;
  String? type;
  List<String>? placeType;
  double? relevance;
  Properties? properties;
  String? textEs;
  String? placeNameEs;
  String? text;
  String? placeName;
  List<double>? center;
  Geometry? geometry;
  List<Context>? context;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: json["place_type"] == null
            ? []
            : List<String>.from(json["place_type"].map((x) => x)),
        relevance: json["relevance"]?.toDouble(),
        properties: json["properties"] == null
            ? Properties()
            : Properties.fromJson(json["properties"]),
        textEs: json["text_es"],
        placeNameEs: json["place_name_es"],
        text: json["text"],
        placeName: json["place_name"],
        center: List<double>.from(json["center"].map((x) => x.toDouble())),
        geometry: Geometry.fromJson(json["geometry"]),
        context: json["context"] == null
            ? []
            : List<Context>.from(
                json["context"]?.map((x) => Context.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType!.map((x) => x)),
        "relevance": relevance,
        "properties": properties!.toJson(),
        "text_es": textEs,
        "place_name_es": placeNameEs,
        "text": text,
        "place_name": placeName,
        "center": List<dynamic>.from(center!.map((x) => x)),
        "geometry": geometry!.toJson(),
        "context": List<dynamic>.from(context!.map((x) => x.toJson())),
      };
}

class Context {
  Context({
    this.id,
    this.textEs,
    this.text,
    this.wikidata,
    this.shortCode,
    this.languageEs,
    this.language,
  });

  String? id;
  String? textEs;
  String? text;
  String? wikidata;
  String? shortCode;
  Language? languageEs;
  Language? language;

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: json["id"],
        textEs: json["text_es"],
        text: json["text"],
        wikidata: json["wikidata"],
        shortCode: json["short_code"],
        languageEs: json["language_es"] == null
            ? null
            : languageValues.map[json["language_es"]],
        language: json["language"] == null
            ? null
            : languageValues.map[json["language"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text_es": textEs,
        "text": text,
        "wikidata": wikidata ?? '',
        "short_code": shortCode ?? '',
        "language_es":
            languageEs == null ? null : languageValues.reverse![languageEs],
        "language": language == null ? null : languageValues.reverse![language],
      };
}

// ignore: constant_identifier_names
enum Language { ES }

final languageValues = EnumValues({"es": Language.ES});

class Geometry {
  Geometry({
    this.coordinates,
    this.type,
  });

  List<double>? coordinates;
  String? type;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "coordinates": List<dynamic>.from(coordinates!.map((x) => x)),
        "type": type,
      };
}

class Properties {
  Properties({
    this.foursquare,
    this.landmark,
    this.address,
    this.category,
    this.maki,
  });

  String? foursquare;
  bool? landmark;
  String? address;
  String? category;
  String? maki;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        foursquare: json["foursquare"],
        landmark: json["landmark"],
        address: json["address"],
        category: json["category"],
        maki: json["maki"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "foursquare": foursquare,
        "landmark": landmark,
        "address": address,
        "category": category,
        "maki": maki ?? '',
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
