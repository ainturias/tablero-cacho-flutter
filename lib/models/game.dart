import 'player.dart';

enum ViewMode { grid, single, list }

class Game {
  final String id;
  final List<Player> players;
  int currentPlayerIndex;
  ViewMode viewMode;
  bool isFinished;
  final DateTime createdAt;
  DateTime updatedAt;

  Game({
    required this.id,
    required this.players,
    this.currentPlayerIndex = 0,
    this.viewMode = ViewMode.grid,
    this.isFinished = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Player get currentPlayer => players[currentPlayerIndex];

  Player? get leader {
    if (players.every((p) => p.total == 0)) return null;
    final sorted = List<Player>.from(players)
      ..sort((a, b) => b.total.compareTo(a.total));
    if (sorted.length > 1 && sorted[0].total == sorted[1].total) return null;
    return sorted.first;
  }

  bool isPlayerLeading(String playerId) {
    if (players.every((p) => p.total == 0)) return false;
    final player = players.firstWhere((p) => p.id == playerId);
    return player.total == maxTotal;
  }

  int get currentRound {
    if (players.isEmpty) return 1;
    final minTurns = players.map((p) => p.scoreCard.completedCategoriesCount).reduce(
        (a, b) => a < b ? a : b);
    return minTurns + 1;
  }

  int get maxTotal {
    if (players.isEmpty) return 0;
    return players.map((p) => p.total).reduce((a, b) => a > b ? a : b);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'players': players.map((p) => p.toJson()).toList(),
        'currentPlayerIndex': currentPlayerIndex,
        'viewMode': viewMode.name,
        'isFinished': isFinished,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        id: json['id'] as String,
        players: (json['players'] as List<dynamic>)
            .map((p) => Player.fromJson(p as Map<String, dynamic>))
            .toList(),
        currentPlayerIndex: json['currentPlayerIndex'] as int,
        viewMode: ViewMode.values.firstWhere(
          (v) => v.name == json['viewMode'],
          orElse: () => ViewMode.grid,
        ),
        isFinished: json['isFinished'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
