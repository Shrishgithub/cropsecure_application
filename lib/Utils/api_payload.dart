class ApiPayload {
  static ApiPayload inst = ApiPayload();
  Map login(String ID, String userID, String Password) {
    return {
      "user_id": userID, //"usgic_aws"
      "password": Password, //"usgic@2022"
      "ID": ID, //""
      "sync": "ai_login"
    };
  }

  Map level1(String userId) {
    return {"userId": userId};
  }

  // Map level2()
  Map level2(
    String userId,
    List<String> state,
  ) {
    return {"level1_id": state, "userId": userId};
  }

  Map level3(String userId, List<String> district) {
    return {"level2_id": district, "userId": userId};
  }

  Map locationCount(String userId) {
    return {
      "level1_id": 5,
      "level2_id": [446],
      "userId": userId
    };
  }

  Map locationList(int level1Id, int level2Id, int level3Id, String userId) {
    return {
      "level1_id": level1Id,
      "level2_id": level2Id,
      if (level3Id != -1) "level3_id": level3Id,
      "userId": userId
    };
  }

  Map LocationParam(String userId) {
    return {"userId": userId};
  }

  Map ChartDetail() {
    return {
      "location_id": "6548d6a19e64505b18014b63",
      "from_date": "2024-06-08",
      "to_date": "2024-06-08",
      "parameters": [
        {"id": "MinTemp", "name": "Min Temp"},
        {"id": "MaxTemp", "name": "Max Temp"},
        {"id": "MinMoisture", "name": "Min Hum"},
        {"id": "Rain", "name": "Instant Rain"},
        {"id": "CumulativeRain", "name": "Cumulative Rain"},
        {"id": "MaxWindSpeed", "name": "Max WindSpeed"},
        {"id": "AverageWindSpeed", "name": "Average WindSpeed"},
        {"id": "MaxAtmPres", "name": "Max Atm. Pressure"},
        {"id": "MinAtmPres", "name": "Min Atm. Pressure"},
        {"id": "AverageAtmPres", "name": "Average Atm. Pressure"},
        {"id": "AverageSolarRadiation", "name": "Average Solar Radiation"},
        {"id": "PM2_5", "name": "Average PM 2.5"},
        {"id": "PM10_0", "name": "Average PM 10.0"},
        {"id": "VOC", "name": "Average VOC"},
        {"id": "NOX", "name": "Average NOX"}
      ],
      "userId": "633"
    };
  }
}
