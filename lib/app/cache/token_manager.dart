import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _tokenKey = 'token';
  static const String _playIndexKey = 'play_index';
  static const String _playHistoryKey = 'play_history';

  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> savePlayIndex(int? playIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (playIndex == null) {
      await prefs.remove(_playIndexKey);
    } else {
      await prefs.setInt(_playIndexKey, playIndex);
    }
  }

  static Future<int?> getPlayIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_playIndexKey);
  }

  static Future<void> savePlayHistory(String? playHistory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (playHistory == null) {
      await prefs.remove(_playHistoryKey);
    } else {
      await prefs.setString(_playHistoryKey, playHistory);
    }
  }

  static Future<String?> getPlayHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_playHistoryKey);
  }
}
