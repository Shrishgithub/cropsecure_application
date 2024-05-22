import 'package:shared_preferences/shared_preferences.dart';

class SharePref {
  static SharePref shred = SharePref();

  /*SET STRING*/
  Future setString(String key, String value) async {
    var sharePref = await SharedPreferences.getInstance();
    sharePref.setString(key, value);
  }

  /*SET BOOL*/
  Future setBool(String key, bool value) async {
    var sharePref = await SharedPreferences.getInstance();
    sharePref.setBool(key, value);
  }

  /*SET INT*/
  Future setInt(String key, int value) async {
    var sharePref = await SharedPreferences.getInstance();
    sharePref.setInt(key, value);
  }

  /*SET DOUBLE*/
  Future setDouble(String key, double value) async {
    var sharePref = await SharedPreferences.getInstance();
    sharePref.setDouble(key, value);
  }

  /*GET STRING*/
  Future<String> getString(String key) async {
    var sharePref = await SharedPreferences.getInstance();
    return sharePref.getString(key) ?? '';
  }

  /*GET INT*/
  Future<int> getInt(String key) async {
    var sharePref = await SharedPreferences.getInstance();
    return sharePref.getInt(key) ?? 0;
  }

  /*GET BOOL*/
  Future<bool> getBool(String key) async {
    var sharePref = await SharedPreferences.getInstance();
    return sharePref.getBool(key) ?? false;
  }

  /*GET DOUBLE*/
  Future<double?> getDouble(String key) async {
    var sharePref = await SharedPreferences.getInstance();
    return sharePref.getDouble(key) ?? 0.00;
  }

  /*CLEAR SHAREPREF*/
  Future<void> clear() async {
    var sharePref = await SharedPreferences.getInstance();
    sharePref.clear();
  }

  /*REMOVE KEY*/
  Future<void> remove(String key) async {
    var sharePref = await SharedPreferences.getInstance();
    sharePref.remove(key);
  }
}
