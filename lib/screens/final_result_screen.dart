import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../controllers/settings_controller.dart';
import '../models/player.dart';

class FinalResultScreen extends StatelessWidget {
  const FinalResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final grandesCount = context.watch<SettingsController>().grandesCount;
    return Consumer<GameController>(
      builder: (context, controller, _) {
        final game = controller.currentGame;
        if (game == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // Sort: Winner by Dormida always comes first. Otherwise, sort by points.
        final sorted = List<Player>.from(game.players)
          ..sort((a, b) {
            if (a.isWinnerByDormida && !b.isWinnerByDormida) return -1;
            if (!a.isWinnerByDormida && b.isWinnerByDormida) return 1;
            return b.total.compareTo(a.total);
          });

        // Determine ranks
        final List<int> ranks = [];
        int currentRank = 1;
        for (int i = 0; i < sorted.length; i++) {
          if (i > 0) {
            final prev = sorted[i - 1];
            final curr = sorted[i];
            if (prev.isWinnerByDormida != curr.isWinnerByDormida ||
                prev.total != curr.total) {
              currentRank = i + 1;
            }
          }
          ranks.add(currentRank);
        }

        // Determine winners
        final highestScore = sorted.first.total;
        final isGrande2Winner = sorted.first.isWinnerByDormida;
        final winners = sorted.where((p) => 
            p.isWinnerByDormida || (!isGrande2Winner && p.total == highestScore)).toList();

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Trophy
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.emoji_events_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Resultado Final',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Winner card
                  if (winners.isNotEmpty) _buildWinnerCard(context, winners, grandesCount),
                  const SizedBox(height: 24),

                  // Ranking list
                  ...sorted.asMap().entries.map((entry) {
                    final rank = ranks[entry.key];
                    return _buildRankingRow(context, rank, entry.value, grandesCount);
                  }),

                  const SizedBox(height: 32),

                  // Buttons
                  OutlinedButton(
                    onPressed: () {
                      controller.returnToBoard();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Volver al Tablero',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      controller.resetGame();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text(
                      'Nueva Partida',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWinnerCard(BuildContext context, List<Player> winners, int grandesCount) {
    final isTie = winners.length > 1;
    final winner = winners.first;
    final names = winners.map((p) => p.name).join(' y ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF59E0B).withValues(alpha: 0.15),
            const Color(0xFFF59E0B).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            isTie ? '🤝' : '👑',
            style: GoogleFonts.inter(fontSize: 36),
          ),
          const SizedBox(height: 8),
          if (isTie)
            Text(
              '¡EMPATE!',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFFBBF24),
                letterSpacing: 1.2,
              ),
            ),
          Text(
            names,
            style: GoogleFonts.inter(
              fontSize: isTie ? 20 : 24,
              fontWeight: FontWeight.w800,
              color: isTie ? Theme.of(context).colorScheme.onSurface : const Color(0xFFFBBF24),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            winner.isWinnerByDormida ? 'GANARON POR GRANDE 2 🏆' : '${winner.total} puntos',
            style: GoogleFonts.inter(
              fontSize: winner.isWinnerByDormida ? 22 : 32,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (!isTie) ...[
            const SizedBox(height: 4),
            Text(
              '${winner.scoreCard.completedCategoriesCount}/${grandesCount == 2 ? 11 : 10} categorías llenas',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRankingRow(BuildContext context, int rank, Player player, int grandesCount) {
    final isFirst = rank == 1;
    final medal = rank == 1
        ? '🥇'
        : rank == 2
            ? '🥈'
            : rank == 3
                ? '🥉'
                : null;
 
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isFirst
            ? const Color(0xFFF59E0B).withValues(alpha: 0.08)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFirst
              ? const Color(0xFFF59E0B).withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Row(
        children: [
          // Position
          SizedBox(
            width: 36,
            child: medal != null
                ? Text(medal, style: const TextStyle(fontSize: 20))
                : Text(
                    '$rank',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
          const SizedBox(width: 12),
          // Name and Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  player.isWinnerByDormida
                      ? 'Victoria por Grande 2'
                      : '${player.scoreCard.completedCategoriesCount}/${grandesCount == 2 ? 11 : 10} llenas',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          // Total
          Text(
            player.isWinnerByDormida ? 'GRANDE 2' : '${player.total}',
            style: GoogleFonts.inter(
              fontSize: player.isWinnerByDormida ? 15 : 20,
              fontWeight: FontWeight.w800,
              color: isFirst ? const Color(0xFFFBBF24) : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (!player.isWinnerByDormida) ...[
            Text(
              ' pts',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
