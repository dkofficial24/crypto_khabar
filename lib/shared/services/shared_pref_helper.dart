import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  Future saveValue(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value.toString());
  }

  Future<String> getValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

}
