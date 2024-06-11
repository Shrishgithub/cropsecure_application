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
  List<PmDatum> pmData;
  List<VocNoxDatum> vocNoxData;

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
        atmPresData: [],
        // List<AtmPresDatum>.from(
        //     json["AtmPresData"].map((x) => AtmPresDatum.fromMap(x))),
        locData: LocData.fromMap(json["locData"]),
        // pmData: List<dynamic>.from(json["PmData"].map((x) => x)),
        // vocNoxData: List<dynamic>.from(json["VocNoxData"].map((x) => x)),
        pmData:
            List<PmDatum>.from(json["PmData"].map((x) => PmDatum.fromMap(x))),
        vocNoxData: List<VocNoxDatum>.from(
            json["VocNoxData"].map((x) => VocNoxDatum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "TempData": List<dynamic>.from(tempData.map((x) => x.toMap())),
        "RainData": List<dynamic>.from(rainData.map((x) => x.toMap())),
        "WindspeedData":
            List<dynamic>.from(windspeedData.map((x) => x.toMap())),
        "AtmPresData": List<dynamic>.from(atmPresData.map((x) => x.toMap())),
        "locData": locData.toMap(),
        // "PmData": List<dynamic>.from(pmData.map((x) => x)),
        // "VocNoxData": List<dynamic>.from(vocNoxData.map((x) => x)),
        "PmData": List<dynamic>.from(pmData.map((x) => x.toMap())),
        "VocNoxData": List<dynamic>.from(vocNoxData.map((x) => x.toMap())),
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

class PmDatum {
  int avgPm25;
  DateTime deviceDate;
  int avgPm100;

  PmDatum({
    required this.avgPm25,
    required this.deviceDate,
    required this.avgPm100,
  });

  factory PmDatum.fromMap(Map<String, dynamic> json) => PmDatum(
        avgPm25: json["AvgPm_2_5"],
        deviceDate: DateTime.parse(json["DeviceDate"]),
        avgPm100: json["AvgPm_10_0"],
      );

  Map<String, dynamic> toMap() => {
        "AvgPm_2_5": avgPm25,
        "DeviceDate":
            "${deviceDate.year.toString().padLeft(4, '0')}-${deviceDate.month.toString().padLeft(2, '0')}-${deviceDate.day.toString().padLeft(2, '0')}",
        "AvgPm_10_0": avgPm100,
      };
}

class RainDatum {
  String rain;
  DateTime deviceDate;
  String cumulativeRain;

  RainDatum({
    required this.rain,
    required this.deviceDate,
    required this.cumulativeRain,
  });

  factory RainDatum.fromMap(Map<String, dynamic> json) => RainDatum(
        rain: json["Rain"].toString(),
        deviceDate: DateTime.parse(json["DeviceDate"]),
        cumulativeRain: json["CumulativeRain"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "Rain": rain,
        "DeviceDate": deviceDate.toIso8601String(),
        "CumulativeRain": cumulativeRain,
      };
}

class TempDatum {
  String maxTemp;
  String minTemp;
  String minMoisture;
  DateTime deviceDate;

  TempDatum({
    required this.maxTemp,
    required this.minTemp,
    required this.minMoisture,
    required this.deviceDate,
  });

  factory TempDatum.fromMap(Map<String, dynamic> json) => TempDatum(
        maxTemp: json["MaxTemp"],
        minTemp: json["MinTemp"],
        minMoisture: json["MinMoisture"],
        deviceDate: DateTime.parse(json["DeviceDate"]),
      );

  Map<String, dynamic> toMap() => {
        "MaxTemp": maxTemp,
        "MinTemp": minTemp,
        "MinMoisture": minMoisture,
        "DeviceDate": deviceDate.toIso8601String(),
      };
}

class VocNoxDatum {
  int averageVoc;
  DateTime deviceDate;
  int averageNox;

  VocNoxDatum({
    required this.averageVoc,
    required this.deviceDate,
    required this.averageNox,
  });

  factory VocNoxDatum.fromMap(Map<String, dynamic> json) => VocNoxDatum(
        averageVoc: json["AverageVOC"],
        deviceDate: DateTime.parse(json["DeviceDate"]),
        averageNox: json["AverageNOX"],
      );

  Map<String, dynamic> toMap() => {
        "AverageVOC": averageVoc,
        "DeviceDate":
            "${deviceDate.year.toString().padLeft(4, '0')}-${deviceDate.month.toString().padLeft(2, '0')}-${deviceDate.day.toString().padLeft(2, '0')}",
        "AverageNOX": averageNox,
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
