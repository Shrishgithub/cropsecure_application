// To parse this JSON data, do
//
//     final locList = locListFromMap(jsonString);

import 'dart:convert';

LocList locListFromMap(String str) => LocList.fromMap(json.decode(str));

String locListToMap(LocList data) => json.encode(data.toMap());

class LocList {
  String status;
  List<DatumLocList> data;

  LocList({
    required this.status,
    required this.data,
  });

  factory LocList.fromMap(Map<String, dynamic> json) => LocList(
        status: json["status"],
        data: List<DatumLocList>.from(
            json["data"].map((x) => DatumLocList.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class DatumLocList {
  String locationId;
  int id;
  String name;
  int level1;
  int level2;
  int level3;
  String lat;
  String lon;

  DatumLocList({
    required this.locationId,
    required this.id,
    required this.name,
    required this.level1,
    required this.level2,
    required this.level3,
    required this.lat,
    required this.lon,
  });

  factory DatumLocList.fromMap(Map<String, dynamic> json) => DatumLocList(
        locationId: json["locationId"],
        id: json["id"],
        name: json["name"],
        level1: json["level1"],
        level2: json["level2"],
        level3: json["level3"],
        lat: json["lat"],
        lon: json["lon"],
      );

  Map<String, dynamic> toMap() => {
        "locationId": locationId,
        "id": id,
        "name": name,
        "level1": level1,
        "level2": level2,
        "level3": level3,
        "lat": lat,
        "lon": lon,
      };
}


// DatumLocList