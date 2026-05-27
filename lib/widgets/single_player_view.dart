import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game.dart';
import 'cacho_score_grid.dart';

class SinglePlayerView extends StatelessWidget {
  final Game game;
  final void Function(String playerId, String playerName, String categoryKey) onCategoryTap;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const SinglePlayerView({
    super.key,
    required this.game,
    required this.onCategoryTap,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final player = game.currentPlayer;
    final leader = game.leader;
    final isLeader = leader != null && leader.id == player.id;
    final playerIndex = game.currentPlayerIndex + 1;
    final totalPlayers = game.players.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Player indicator
          Text(
            'Jugador $playerIndex de $totalPlayers',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          // Main card
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF15242C),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isLeader
                      ? const Color(0xFFF59E0B).withValues(alpha: 0.5)
                      : const Color(0xFF10B981).withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isLeader
                        ? const Color(0xFFF59E0B).withValues(alpha: 0.1)
                        : const Color(0xFF10B981).withValues(alpha: 0.08),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isLeader)
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Text('👑', style: TextStyle(fontSize: 24)),
                        ),
                      Flexible(
                        child: Text(
                          player.name,
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: isLeader
                                ? const Color(0xFFFBBF24)
                                : Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Total points / Dormida state
                  if (player.isWinnerByDormida) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBBF24).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        'GANÓ DORMIDA 🏆',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFBBF24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${player.total}',
                          style: GoogleFonts.inter(
                            fontSize: 54,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF10B981),
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'pts',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Cacho Grid (Large)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: CachoScoreGrid(
                          scoreCard: player.scoreCard,
                          compact: false,
                          onCellTap: (categoryKey) =>
                              onCategoryTap(player.id, player.name, categoryKey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Navigation buttons
          Row(
            children: [
              // Previous
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onPrevious,
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: Text(
                    'Anterior',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 52),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Next
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onNext,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: Text(
                    'Siguiente',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 52),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
