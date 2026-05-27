import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/game.dart';

class LocalStorageService {
  static const String _boxName = 'cacho_game';
  static const String _gameKey = 'current_game';
  late Box _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  Future<void> saveGame(Game game) async {
    final jsonString = jsonEncode(game.toJson());
    await _box.put(_gameKey, jsonString);
  }

  Game? loadGame() {
    final jsonString = _box.get(_gameKey) as String?;
    if (jsonString == null) return null;
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return Game.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearGame() async {
    await _box.delete(_gameKey);
  }

  bool hasSavedGame() {
    return _box.containsKey(_gameKey);
  }
}
