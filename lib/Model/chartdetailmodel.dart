// To parse this JSON data, do
//
//     final chart = chartFromMap(jsonString);

import 'dart:convert';

Chart chartFromMap(String str) => Chart.fromMap(json.decode(str));

String chartToMap(Chart data) => json.encode(data.toMap());

class Chart {
  String status;
  Data data;

  Chart({
    required this.status,
    required this.data,
  });

  factory Chart.fromMap(Map<String, dynamic> json) => Chart(
        status: json["status"],
        data: Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "data": data.toMap(),
      };
}

class Data {
  List<TempDatum> tempData;
  List<RainDatum> rainData;
  List<WindspeedDatum> windspeedData;
  List<AtmPresDatum> atmPresData;
  LocData locData;
  List<dynamic> pmData;
  List<dynamic> vocNoxData;

  Data({
    required this.tempData,
    required this.rainData,
    required this.windspeedData,
    required this.atmPresData,
    required this.locData,
    required this.pmData,
    required this.vocNoxData,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        tempData: List<TempDatum>.from(
            json["TempData"].map((x) => TempDatum.fromMap(x))),
        rainData: List<RainDatum>.from(
            json["RainData"].map((x) => RainDatum.fromMap(x))),
        windspeedData: List<WindspeedDatum>.from(
            json["WindspeedData"].map((x) => WindspeedDatum.fromMap(x))),
        atmPresData: List<AtmPresDatum>.from(
            json["AtmPresData"].map((x) => AtmPresDatum.fromMap(x))),
        locData: LocData.fromMap(json["locData"]),
        pmData: List<dynamic>.from(json["PmData"].map((x) => x)),
        vocNoxData: List<dynamic>.from(json["VocNoxData"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "TempData": List<dynamic>.from(tempData.map((x) => x.toMap())),
        "RainData": List<dynamic>.from(rainData.map((x) => x.toMap())),
        "WindspeedData":
            List<dynamic>.from(windspeedData.map((x) => x.toMap())),
        "AtmPresData": List<dynamic>.from(atmPresData.map((x) => x.toMap())),
        "locData": locData.toMap(),
        "PmData": List<dynamic>.from(pmData.map((x) => x)),
        "VocNoxData": List<dynamic>.from(vocNoxData.map((x) => x)),
      };
}

class AtmPresDatum {
  String averageAtmPres;
  DateTime deviceDate;
  String averageSolarRadiation;

  AtmPresDatum({
    required this.averageAtmPres,
    required this.deviceDate,
    required this.averageSolarRadiation,
  });

  factory AtmPresDatum.fromMap(Map<String, dynamic> json) => AtmPresDatum(
        averageAtmPres: json["AverageAtmPres"],
        deviceDate: DateTime.parse(json["DeviceDate"]),
        averageSolarRadiation: json["AverageSolarRadiation"],
      );

  Map<String, dynamic> toMap() => {
        "AverageAtmPres": averageAtmPres,
        "DeviceDate": deviceDate.toIso8601String(),
        "AverageSolarRadiation": averageSolarRadiation,
      };
}

class LocData {
  int level1Id;
  int level2Id;
  int level3Id;
  String name;
  int locationId;
  String id;
  List<String> locationParameterList;

  LocData({
    required this.level1Id,
    required this.level2Id,
    required this.level3Id,
    required this.name,
    required this.locationId,
    required this.id,
    required this.locationParameterList,
  });

  factory LocData.fromMap(Map<String, dynamic> json) => LocData(
        level1Id: json["level1_id"],
        level2Id: json["level2_id"],
        level3Id: json["level3_id"],
        name: json["name"],
        locationId: json["location_id"],
        id: json["id"],
        locationParameterList:
            List<String>.from(json["locationParameterList"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "level1_id": level1Id,
        "level2_id": level2Id,
        "level3_id": level3Id,
        "name": name,
        "location_id": locationId,
        "id": id,
        "locationParameterList":
            List<dynamic>.from(locationParameterList.map((x) => x)),
      };
}

class RainDatum {
  int rain;
  DateTime deviceDate;
  int cumulativeRain;

  RainDatum({
    required this.rain,
    required this.deviceDate,
    required this.cumulativeRain,
  });

  factory RainDatum.fromMap(Map<String, dynamic> json) => RainDatum(
        rain: json["Rain"],
        deviceDate: DateTime.parse(json["DeviceDate"]),
        cumulativeRain: json["CumulativeRain"],
      );

  Map<String, dynamic> toMap() => {
        "Rain": rain,
        "DeviceDate": deviceDate.toIso8601String(),
        "CumulativeRain": cumulativeRain,
      };
}

class TempDatum {
  double maxTemp;
  double minTemp;
  double minMoisture;
  DateTime deviceDate;

  TempDatum({
    required this.maxTemp,
    required this.minTemp,
    required this.minMoisture,
    required this.deviceDate,
  });

  factory TempDatum.fromMap(Map<String, dynamic> json) => TempDatum(
        maxTemp: json["MaxTemp"]?.toDouble(),
        minTemp: json["MinTemp"]?.toDouble(),
        minMoisture: json["MinMoisture"]?.toDouble(),
        deviceDate: DateTime.parse(json["DeviceDate"]),
      );

  Map<String, dynamic> toMap() => {
        "MaxTemp": maxTemp,
        "MinTemp": minTemp,
        "MinMoisture": minMoisture,
        "DeviceDate": deviceDate.toIso8601String(),
      };
}

class WindspeedDatum {
  String maxWindSpeed;
  DateTime deviceDate;
  String averageWindSpeed;

  WindspeedDatum({
    required this.maxWindSpeed,
    required this.deviceDate,
    required this.averageWindSpeed,
  });

  factory WindspeedDatum.fromMap(Map<String, dynamic> json) => WindspeedDatum(
        maxWindSpeed: json["MaxWindSpeed"],
        deviceDate: DateTime.parse(json["DeviceDate"]),
        averageWindSpeed: json["AverageWindSpeed"],
      );

  Map<String, dynamic> toMap() => {
        "MaxWindSpeed": maxWindSpeed,
        "DeviceDate": deviceDate.toIso8601String(),
        "AverageWindSpeed": averageWindSpeed,
      };
}
