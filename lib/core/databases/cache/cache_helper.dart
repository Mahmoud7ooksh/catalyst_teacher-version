import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print(
      'DEBUG: CacheHelper initialized. Token: ${sharedPreferences.getString('token')}',
    );
  }

  static Future<dynamic> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else if (value is bool) {
      await sharedPreferences.setBool(key, value);
    } else if (value is int) {
      await sharedPreferences.setInt(key, value);
    } else if (value is double) {
      await sharedPreferences.setDouble(key, value);
    }
  }

  static Future<dynamic> getData({required String key}) async {
    // Ensure initialized if called statically/unexpectedly, though init() should handle it.
    // However, SharedPreferences.getInstance() is a singleton so calling it again is safe.
    // Direct access to late variable checks are better.
    try {
      print(
        'DEBUG: CacheHelper.getData key: $key, value: ${sharedPreferences.get(key)}',
      );
      return sharedPreferences.get(key);
    } catch (e) {
      print('DEBUG: CacheHelper error reading $key: $e');
      return null;
    }
  }

  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  static Future<bool> clearAllData() async {
    return await sharedPreferences.clear();
  }
}
