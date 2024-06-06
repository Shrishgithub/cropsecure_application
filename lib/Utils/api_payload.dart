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
}
