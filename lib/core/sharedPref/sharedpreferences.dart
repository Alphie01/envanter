import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? prefs;

  static Future<void> getSharedInstance() async {
    prefs = await SharedPreferences.getInstance();
  }

  static void addStringToSF(String keyname, String value) {
    prefs!.setString(keyname, value);
    print('object $keyname - $value');
  }

  static void addIntToSF(String keyname, int value) async {
    prefs!.setInt(keyname, value);
  }

  static void addBoolToSF(String keyname, bool value) async {
    prefs!.setBool(keyname, value);
    print(prefs!.setBool(keyname, value));
  }

  static void removeStrValue(String keyname) {
    prefs!.remove(keyname);
  }

  static String getStringValuesSF(String keyname) {
    String stringValue = prefs!.getString(keyname) ?? '';
    return stringValue;
  }

  static bool getBoolValuesSF(String keyname) {
    bool boolValue = prefs!.getBool(keyname) ?? false;
    print(boolValue);
    return boolValue;
  }

  static int getIntValuesSF(String keyname) {
    int intValue = prefs!.getInt(keyname) ?? 0;
    return intValue;
  }

  static void init() {
    getSharedInstance();
  }
}
