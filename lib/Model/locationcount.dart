// To parse this JSON data, do
//
//     final locationCount = locationCountFromMap(jsonString);

import 'dart:convert';

LocationCount locationCountFromMap(String str) =>
    LocationCount.fromMap(json.decode(str));

String locationCountToMap(LocationCount data) => json.encode(data.toMap());

class LocationCount {
  String status;
  List<DatumLocMdl> data;
  String locationId;
  int total;

  LocationCount({
    required this.status,
    required this.data,
    required this.locationId,
    required this.total,
  });

  factory LocationCount.fromMap(Map<String, dynamic> json) => LocationCount(
        status: json["status"],
        data: List<DatumLocMdl>.from(
            json["data"].map((x) => DatumLocMdl.fromMap(x))),
        locationId: json["location_id"],
        total: json["total"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "location_id": locationId,
        "total": total,
      };
}

class DatumLocMdl {
  int id;
  String name;
  int level1;
  String lat;
  String lon;
  int level2;
  int level3;
  String count;

  DatumLocMdl({
    required this.id,
    required this.name,
    required this.level1,
    required this.lat,
    required this.lon,
    required this.level2,
    required this.level3,
    required this.count,
  });

  factory DatumLocMdl.fromMap(Map<String, dynamic> json) => DatumLocMdl(
        id: json["id"],
        name: json["name"],
        level1: json["level1"],
        lat: json["lat"],
        lon: json["lon"],
        level2: json["level2"],
        level3: json["level3"],
        count: json["count"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "level1": level1,
        "lat": lat,
        "lon": lon,
        "level2": level2,
        "level3": level3,
        "count": count,
      };
}
