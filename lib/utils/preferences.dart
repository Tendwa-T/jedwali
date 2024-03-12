import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Future<String> getValue(key) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(key) ?? "";
  }

  Future<void> setValueString(key, value) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString(key, value);
  }

  Future setBooleanValue(String key, bool val) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setBool(key, val);
  }

  Future<bool> getBooleanValue(key) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getBool(key) ?? false;
  }
}
