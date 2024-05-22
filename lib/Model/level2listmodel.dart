// To parse this JSON data, do
//
//     final leve2List = leve2ListFromMap(jsonString);

import 'dart:convert';

Leve2List leve2ListFromMap(String str) => Leve2List.fromMap(json.decode(str));

String leve2ListToMap(Leve2List data) => json.encode(data.toMap());

class Leve2List {
  String status;
  List<Datum> data;

  Leve2List({
    required this.status,
    required this.data,
  });

  factory Leve2List.fromMap(Map<String, dynamic> json) => Leve2List(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class Datum {
  String level1Id;
  String level2Id;
  String level2Name;

  Datum({
    required this.level1Id,
    required this.level2Id,
    required this.level2Name,
  });

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    level1Id: json["Level1Id"],
    level2Id: json["Level2Id"],
    level2Name: json["Level2Name"],
  );

  Map<String, dynamic> toMap() => {
    "Level1Id": level1Id,
    "Level2Id": level2Id,
    "Level2Name": level2Name,
  };
}
