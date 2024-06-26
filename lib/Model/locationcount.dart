// // To parse this JSON data, do
// //
// //     final locationCount = locationCountFromMap(jsonString);

import 'dart:convert';

LocationCount locationCountFromMap(String str) =>
    LocationCount.fromMap(json.decode(str));

String locationCountToMap(LocationCount data) => json.encode(data.toMap());

class LocationCount {
  String status;
  ParamData? paramData;
  List<DatumLocMdl> data;
  String locationId;
  // DateTime date;
  int total;

  LocationCount({
    required this.status,
    required this.paramData,
    required this.data,
    required this.locationId,
    // required this.date,
    required this.total,
  });

  factory LocationCount.fromMap(Map<String?, dynamic> json) => LocationCount(
        status: json["status"],
        // paramData: ParamData.fromMap(json["param_date"]),
        paramData: json["param_data"] != null
            ? ParamData.fromMap(json["param_data"])
            : null,
        data: List<DatumLocMdl>.from(
            json["data"].map((x) => DatumLocMdl.fromMap(x))),
        locationId: json["location_id"],
        // date: DateTime.parse(json["date"]),
        total: json["total"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "param_data": paramData?.toMap(),
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "location_id": locationId,
        // "date":
        //     "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
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
        level3: json["level3"] ?? -1,
        count: json["count"].toString(),
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

class ParamData {
  ParamDataMap maxTemp;
  ParamDataMap minTemp;
  Temp maxRain;

  ParamData({
    required this.maxTemp,
    required this.minTemp,
    required this.maxRain,
  });

  factory ParamData.fromMap(Map<String, dynamic> json) => ParamData(
        maxTemp: ParamDataMap.fromMap(json["MaxTemp"]),
        minTemp: ParamDataMap.fromMap(json["MinTemp"]),
        maxRain: Temp.fromMap(json["MaxRain"]),
      );

  Map<String, dynamic> toMap() => {
        "MaxTemp": maxTemp.toMap(),
        "MinTemp": minTemp.toMap(),
        "MaxRain": maxRain.toMap(),
      };
}

class ParamDataMap {
  String datavalue;
  String id;

  ParamDataMap({
    required this.datavalue,
    required this.id,
  });

  factory ParamDataMap.fromMap(Map<String, dynamic> json) => ParamDataMap(
        datavalue: json["datavalue"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "datavalue": datavalue,
        "id": id,
      };
}

class Temp {
  int datavalue;
  String id;

  Temp({
    required this.datavalue,
    required this.id,
  });

  factory Temp.fromMap(Map<String, dynamic> json) => Temp(
        datavalue: json["datavalue"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "datavalue": datavalue,
        "id": id,
      };
}
