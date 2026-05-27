import 'score_card.dart';

class Player {
  final String id;
  final String name;
  final ScoreCard scoreCard;
  final bool isWinnerByDormida;
  final String? lastChange;

  Player({
    required this.id,
    required this.name,
    ScoreCard? scoreCard,
    this.isWinnerByDormida = false,
    this.lastChange,
  }) : scoreCard = scoreCard ?? ScoreCard();

  int get total => scoreCard.total;
  int get currentTurn => scoreCard.completedCategoriesCount + 1;

  Player copyWith({
    String? id,
    String? name,
    ScoreCard? scoreCard,
    bool? isWinnerByDormida,
    String? lastChange,
  }) =>
      Player(
        id: id ?? this.id,
        name: name ?? this.name,
        scoreCard: scoreCard ?? this.scoreCard,
        isWinnerByDormida: isWinnerByDormida ?? this.isWinnerByDormida,
        lastChange: lastChange ?? this.lastChange,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'scoreCard': scoreCard.toJson(),
        'isWinnerByDormida': isWinnerByDormida,
        'lastChange': lastChange,
      };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        id: json['id'] as String,
        name: json['name'] as String,
        scoreCard: ScoreCard.fromJson(json['scoreCard'] as Map<String, dynamic>),
        isWinnerByDormida: json['isWinnerByDormida'] as bool? ?? false,
        lastChange: json['lastChange'] as String?,
      );
}
