import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isOnboardingComplete =>
      _prefs.getBool('onboardingComplete') ?? false;
  static Future<void> setOnboardingComplete() =>
      _prefs.setBool('onboardingComplete', true);

  static String get city => _prefs.getString('city') ?? 'Минск';
  static Future<void> setCity(String value) => _prefs.setString('city', value);

  static String get gender => _prefs.getString('gender') ?? 'Мужской';
  static Future<void> setGender(String value) =>
      _prefs.setString('gender', value);

  static String get ageGroup => _prefs.getString('ageGroup') ?? '20-30';
  static Future<void> setAgeGroup(String value) =>
      _prefs.setString('ageGroup', value);

  static double get coldSensitivity =>
      _prefs.getDouble('coldSensitivity') ?? 2.0;
  static Future<void> setColdSensitivity(double value) =>
      _prefs.setDouble('coldSensitivity', value);

  static String get style => _prefs.getString('style') ?? 'Casual';
  static Future<void> setStyle(String value) =>
      _prefs.setString('style', value);

  static String get colorPalette =>
      _prefs.getString('colorPalette') ?? 'Базовые';
  static Future<void> setColorPalette(String value) =>
      _prefs.setString('colorPalette', value);

  static String? get lastOutfitJson => _prefs.getString('lastOutfitJson');
  static Future<void> setLastOutfitJson(String value) =>
      _prefs.setString('lastOutfitJson', value);

  static int? get lastOutfitTimestamp => _prefs.getInt('lastOutfitTimestamp');
  static Future<void> setLastOutfitTimestamp(int value) =>
      _prefs.setInt('lastOutfitTimestamp', value);

  static Future<void> clearLastOutfit() async {
    await _prefs.remove('lastOutfitJson');
    await _prefs.remove('lastOutfitTimestamp');
  }
}
