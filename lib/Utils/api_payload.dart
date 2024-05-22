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
}
