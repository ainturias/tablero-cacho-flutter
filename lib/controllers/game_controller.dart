import 'package:flutter/foundation.dart';
import '../models/game.dart';
import '../models/player.dart';
import '../models/score_card.dart';
import '../services/local_storage_service.dart';
import '../services/settings_service.dart';
import '../utils/game_utils.dart';

import 'dart:math';

class GameController extends ChangeNotifier {
  final LocalStorageService _storage;
  final SettingsService _settingsService;
  Game? _currentGame;
  bool _hasSavedGame = false;

  GameController(this._storage, this._settingsService) {
    _hasSavedGame = _storage.hasSavedGame();
  }

  Game? get currentGame => _currentGame;
  bool get hasSavedGame => _hasSavedGame;
  bool get hasActiveGame => _currentGame != null && !_currentGame!.isFinished;

  // --- Game Lifecycle ---

  void createGame(List<String> playerNames) {
    final players = playerNames.map((name) {
      return Player(id: generateId(), name: name);
    }).toList();

    final randomIndex = Random().nextInt(players.length);

    _currentGame = Game(
      id: generateId(),
      players: players,
      currentPlayerIndex: randomIndex,
    );
    _autoSave();
    notifyListeners();
  }

  void loadSavedGame() {
    final game = _storage.loadGame();
    if (game != null) {
      _currentGame = game;
      notifyListeners();
    }
  }

  Future<void> resetGame() async {
    _currentGame = null;
    await _storage.clearGame();
    _hasSavedGame = false;
    notifyListeners();
  }

  void finishGame() {
    if (_currentGame == null) return;
    _currentGame!.isFinished = true;
    _autoSave();
    notifyListeners();
  }

  void returnToBoard() {
    if (_currentGame == null) return;
    _currentGame!.isFinished = false;
    _autoSave();
    notifyListeners();
  }

  // --- Scoring Category ---

  void updateScoreCategory(String playerId, String categoryKey, ScoreEntry? entry) {
    if (_currentGame == null) return;

    final playerIndex =
        _currentGame!.players.indexWhere((p) => p.id == playerId);
    if (playerIndex == -1) return;

    final player = _currentGame!.players[playerIndex];
    final oldScoreCard = player.scoreCard;
    final newScoreCard = oldScoreCard.copyWithEntry(categoryKey, entry);

    // Format last change description
    String? lastChange;
    if (entry != null && entry.marked) {
      final categoryLabel = categoryKey.toUpperCase();
      final valueStr = entry.isTachado ? 'X' : '${entry.value}';
      final modeStr = entry.mode == 'mano' ? ' (M)' : (entry.mode == 'tres_tiros' ? ' (3T)' : '');
      lastChange = '$categoryLabel: $valueStr$modeStr';
    } else {
      lastChange = 'Borrado: ${categoryKey.toUpperCase()}';
    }

    // Determine if player won by Grande 2 (if behavior is instaWin)
    bool isWinnerByGrande2 = false;
    final behavior = _settingsService.grande2Behavior;
    if (categoryKey == 'grande2' &&
        entry != null &&
        entry.marked &&
        !entry.isTachado &&
        behavior == 'instaWin') {
      isWinnerByGrande2 = true;
    }

    final updatedPlayer = player.copyWith(
      scoreCard: newScoreCard,
      isWinnerByDormida: isWinnerByGrande2,
      lastChange: lastChange,
    );

    _currentGame!.players[playerIndex] = updatedPlayer;
    _currentGame!.updatedAt = DateTime.now();

    // If won by Grande 2, finish game
    if (isWinnerByGrande2) {
      _currentGame!.isFinished = true;
    } else {
      // Check if Grande 2 was unmarked and they were previously the winner, restore isFinished to false
      if (categoryKey == 'grande2' && player.isWinnerByDormida && (entry == null || !entry.marked || entry.isTachado)) {
        _currentGame!.isFinished = false;
      }
    }

    // Auto-advance to next player (only if we did a new score and it's not a Grande 2 win, which ends the game)
    if (entry != null && entry.marked && !_currentGame!.isFinished) {
      // Only auto-advance if the player we scored is the current active player
      if (playerIndex == _currentGame!.currentPlayerIndex) {
        if (_currentGame!.viewMode == ViewMode.single) {
          Future.delayed(const Duration(milliseconds: 800), () {
            if (_currentGame != null && !_currentGame!.isFinished) {
              _advanceToNextPlayer();
              notifyListeners();
            }
          });
        } else {
          _advanceToNextPlayer();
        }
      }
    }

    triggerHaptic();
    _autoSave();
    notifyListeners();
  }

  // --- Navigation ---

  void setViewMode(ViewMode mode) {
    if (_currentGame == null) return;
    _currentGame!.viewMode = mode;
    _autoSave();
    notifyListeners();
  }

  void nextPlayer() {
    if (_currentGame == null) return;
    _currentGame!.currentPlayerIndex =
        (_currentGame!.currentPlayerIndex + 1) % _currentGame!.players.length;
    _autoSave();
    notifyListeners();
  }

  void previousPlayer() {
    if (_currentGame == null) return;
    final len = _currentGame!.players.length;
    _currentGame!.currentPlayerIndex =
        (_currentGame!.currentPlayerIndex - 1 + len) % len;
    _autoSave();
    notifyListeners();
  }

  void setCurrentPlayer(int index) {
    if (_currentGame == null) return;
    if (index < 0 || index >= _currentGame!.players.length) return;
    _currentGame!.currentPlayerIndex = index;
    _autoSave();
    notifyListeners();
  }

  // --- Helpers ---

  Player? getLeader() => _currentGame?.leader;

  int getCurrentRound() => _currentGame?.currentRound ?? 1;

  void _advanceToNextPlayer() {
    if (_currentGame == null) return;
    _currentGame!.currentPlayerIndex =
        (_currentGame!.currentPlayerIndex + 1) % _currentGame!.players.length;
  }

  void _autoSave() {
    if (_currentGame != null) {
      _storage.saveGame(_currentGame!);
      _hasSavedGame = true;
    }
  }
}
