import 'package:hive_flutter/hive_flutter.dart';

class SettingsService {
  static const String _boxName = 'cacho_settings';
  static const String _keyShowHeader = 'show_header';
  static const String _keyGrandesCount = 'grandes_count';
  static const String _keyGrande2Behavior = 'grande2_behavior';
  static const String _keyGrande1Mano = 'grande1_mano';
  static const String _keyFastScoring = 'fast_scoring';
  static const String _keyIsDarkMode = 'is_dark_mode';
  static const String _keyLastNames = 'last_names';
  static const String _keyShowViewSelector = 'show_view_selector';

  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  bool get showHeader => _box.get(_keyShowHeader, defaultValue: true);
  
  Future<void> setShowHeader(bool value) async {
    await _box.put(_keyShowHeader, value);
  }

  bool get showViewSelector => _box.get(_keyShowViewSelector, defaultValue: true);
  
  Future<void> setShowViewSelector(bool value) async {
    await _box.put(_keyShowViewSelector, value);
  }

  int get grandesCount => _box.get(_keyGrandesCount, defaultValue: 1);

  Future<void> setGrandesCount(int value) async {
    await _box.put(_keyGrandesCount, value);
  }

  String get grande2Behavior => _box.get(_keyGrande2Behavior, defaultValue: 'points');

  Future<void> setGrande2Behavior(String value) async {
    await _box.put(_keyGrande2Behavior, value);
  }

  bool get grande1Mano => _box.get(_keyGrande1Mano, defaultValue: false);

  Future<void> setGrande1Mano(bool value) async {
    await _box.put(_keyGrande1Mano, value);
  }

  bool get fastScoring => _box.get(_keyFastScoring, defaultValue: false);

  Future<void> setFastScoring(bool value) async {
    await _box.put(_keyFastScoring, value);
  }

  bool get isDarkMode => _box.get(_keyIsDarkMode, defaultValue: true);

  Future<void> setIsDarkMode(bool value) async {
    await _box.put(_keyIsDarkMode, value);
  }

  String get lastNames => _box.get(_keyLastNames, defaultValue: '');

  Future<void> setLastNames(String names) async {
    await _box.put(_keyLastNames, names);
  }
}
