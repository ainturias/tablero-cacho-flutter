import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../models/player.dart';
import '../utils/game_utils.dart';

class FinalResultScreen extends StatelessWidget {
  const FinalResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(
      builder: (context, controller, _) {
        final game = controller.currentGame!;
        
        // Sort: Winner by Dormida always comes first. Otherwise, sort by points.
        final sorted = List<Player>.from(game.players)
          ..sort((a, b) {
            if (a.isWinnerByDormida && !b.isWinnerByDormida) return -1;
            if (!a.isWinnerByDormida && b.isWinnerByDormida) return 1;
            return b.total.compareTo(a.total);
          });

        return Scaffold(
          backgroundColor: const Color(0xFF0F1A20),
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
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Winner card
                  if (sorted.isNotEmpty) _buildWinnerCard(sorted.first),
                  const SizedBox(height: 24),

                  // Ranking list
                  ...sorted.asMap().entries.map((entry) {
                    return _buildRankingRow(entry.key, entry.value);
                  }),

                  const SizedBox(height: 32),

                  // Buttons
                  ElevatedButton.icon(
                    onPressed: () {
                      final text = formatShareText(game.players);
                      Clipboard.setData(ClipboardData(text: text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Resultado copiado al portapapeles'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.share_rounded),
                    label: Text(
                      'Compartir Resultado',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 12),
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

  Widget _buildWinnerCard(Player winner) {
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
            '👑',
            style: GoogleFonts.inter(fontSize: 36),
          ),
          const SizedBox(height: 8),
          Text(
            winner.name,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFFBBF24),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            winner.isWinnerByDormida ? 'GANÓ DORMIDA 🏆' : '${winner.total} puntos',
            style: GoogleFonts.inter(
              fontSize: winner.isWinnerByDormida ? 22 : 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${winner.scoreCard.completedCategoriesCount}/11 categorías llenas',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingRow(int index, Player player) {
    final isFirst = index == 0;
    final medal = index == 0
        ? '🥇'
        : index == 1
            ? '🥈'
            : index == 2
                ? '🥉'
                : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isFirst
            ? const Color(0xFFF59E0B).withValues(alpha: 0.08)
            : const Color(0xFF15242C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFirst
              ? const Color(0xFFF59E0B).withValues(alpha: 0.3)
              : const Color(0xFF2A3F4D),
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
                    '${index + 1}',
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
                    color: Colors.white,
                  ),
                ),
                Text(
                  player.isWinnerByDormida
                      ? 'Victoria por Dormida'
                      : '${player.scoreCard.completedCategoriesCount}/11 llenas',
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
            player.isWinnerByDormida ? 'DORMIDA' : '${player.total}',
            style: GoogleFonts.inter(
              fontSize: player.isWinnerByDormida ? 15 : 20,
              fontWeight: FontWeight.w800,
              color: isFirst ? const Color(0xFFFBBF24) : Colors.white,
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
