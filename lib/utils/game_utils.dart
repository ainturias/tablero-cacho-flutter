import 'package:flutter/services.dart';
import '../models/player.dart';

String generateId() {
  final now = DateTime.now();
  return '${now.microsecondsSinceEpoch}';
}

List<String> parsePlayerNames(String input, int count) {
  final rawNames = input
      .split(RegExp(r'[,\s]+'))
      .where((s) => s.trim().isNotEmpty)
      .map((s) => s.trim().toUpperCase())
      .toList();

  final names = List<String>.from(rawNames);
  while (names.length < count) {
    names.add('JUGADOR ${names.length + 1}');
  }

  return names.take(count).toList();
}

String formatShareText(List<Player> players) {
  final sorted = List<Player>.from(players)
    ..sort((a, b) {
      if (a.isWinnerByDormida && !b.isWinnerByDormida) return -1;
      if (!a.isWinnerByDormida && b.isWinnerByDormida) return 1;
      return b.total.compareTo(a.total);
    });

  final buffer = StringBuffer('🎲 Resultado final - Cacho:\n\n');
  for (int i = 0; i < sorted.length; i++) {
    final player = sorted[i];
    final medal = i == 0
        ? '🥇'
        : i == 1
            ? '🥈'
            : i == 2
                ? '🥉'
                : '  ${i + 1}.';
    final scoreStr = player.isWinnerByDormida ? 'GANÓ POR GRANDE 2 🏆' : '${player.total} pts';
    buffer.writeln('$medal ${player.name} — $scoreStr (${player.scoreCard.completedCategoriesCount}/11 llenas)');
  }
  buffer.writeln('\n📱 Tablero de Cacho');
  return buffer.toString();
}

void triggerHaptic() {
  HapticFeedback.mediumImpact();
}
