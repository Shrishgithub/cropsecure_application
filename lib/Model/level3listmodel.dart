// To parse this JSON data, do
//
//     final level3List = level3ListFromMap(jsonString);

import 'dart:convert';

Level3List level3ListFromMap(String str) =>
    Level3List.fromMap(json.decode(str));

String level3ListToMap(Level3List data) => json.encode(data.toMap());

class Level3List {
  String status;
  List<Datum> data;

  Level3List({
    required this.status,
    required this.data,
  });

  factory Level3List.fromMap(Map<String, dynamic> json) => Level3List(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Datum {
  String level2Id;
  String level3Id;
  String level3Name;

  Datum({
    required this.level2Id,
    required this.level3Id,
    required this.level3Name,
  });

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        level2Id: json["Level2Id"],
        level3Id: json["Level3Id"],
        level3Name: json["Level3Name"],
      );

  Map<String, dynamic> toMap() => {
        "Level2Id": level2Id,
        "Level3Id": level3Id,
        "Level3Name": level3Name,
      };
}
