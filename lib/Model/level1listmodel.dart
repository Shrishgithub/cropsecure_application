// To parse this JSON data, do
//
//     final leve1List = leve1ListFromMap(jsonString);

import 'dart:convert';

Leve1List leve1ListFromMap(String str) => Leve1List.fromMap(json.decode(str));

String leve1ListToMap(Leve1List data) => json.encode(data.toMap());

class Leve1List {
    String status;
    List<Datum> data;

    Leve1List({
        required this.status,
        required this.data,
    });

    factory Leve1List.fromMap(Map<String, dynamic> json) => Leve1List(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
    };
}

class Datum {
    int id;
    String name;

    Datum({
        required this.id,
        required this.name,
    });

    factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
    };
}
