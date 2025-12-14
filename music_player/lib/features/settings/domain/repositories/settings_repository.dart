abstract class SettingsRepository {
  Future<void> saveThemeMode(String themeMode);
  Future<String> getThemeMode();
  Future<void> saveEqualizerSettings(Map<String, dynamic> settings);
  Future<Map<String, dynamic>> getEqualizerSettings();
  Future<void> clearAllSettings();
}