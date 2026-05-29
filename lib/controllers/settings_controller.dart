import 'package:flutter/foundation.dart';
import '../services/settings_service.dart';

class SettingsController extends ChangeNotifier {
  final SettingsService _settingsService;

  SettingsController(this._settingsService);

  bool get showHeader => _settingsService.showHeader;
  bool get showViewSelector => _settingsService.showViewSelector;
  int get grandesCount => _settingsService.grandesCount;
  String get grande2Behavior => _settingsService.grande2Behavior;
  bool get grande1Mano => _settingsService.grande1Mano;
  bool get fastScoring => _settingsService.fastScoring;
  bool get isDarkMode => _settingsService.isDarkMode;
  String get lastNames => _settingsService.lastNames;

  Future<void> toggleShowHeader() async {
    await _settingsService.setShowHeader(!showHeader);
    notifyListeners();
  }

  Future<void> toggleShowViewSelector() async {
    await _settingsService.setShowViewSelector(!showViewSelector);
    notifyListeners();
  }

  Future<void> setGrandesCount(int count) async {
    if (count != 1 && count != 2) return;
    await _settingsService.setGrandesCount(count);
    notifyListeners();
  }

  Future<void> setGrande2Behavior(String behavior) async {
    if (behavior != 'points' && behavior != 'instaWin') return;
    await _settingsService.setGrande2Behavior(behavior);
    notifyListeners();
  }

  Future<void> toggleGrande1Mano() async {
    await _settingsService.setGrande1Mano(!grande1Mano);
    notifyListeners();
  }

  Future<void> toggleFastScoring() async {
    await _settingsService.setFastScoring(!fastScoring);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    await _settingsService.setIsDarkMode(!isDarkMode);
    notifyListeners();
  }

  Future<void> setLastNames(String names) async {
    await _settingsService.setLastNames(names);
    notifyListeners();
  }
}
