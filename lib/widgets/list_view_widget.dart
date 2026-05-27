import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/game.dart';
import '../models/player.dart';
import '../controllers/game_controller.dart';

class ListViewWidget extends StatelessWidget {
  final Game game;

  const ListViewWidget({
    super.key,
    required this.game,
  });

  void _navigateToPlayer(BuildContext context, String playerId) {
    final controller = context.read<GameController>();
    final playerIndex = game.players.indexWhere((p) => p.id == playerId);
    if (playerIndex != -1) {
      controller.setCurrentPlayer(playerIndex);
      controller.setViewMode(ViewMode.single);
    }
  }

  @override
  Widget build(BuildContext context) {
    final leader = game.leader;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: game.players.length,
      itemBuilder: (context, index) {
        final player = game.players[index];
        final isActive = index == game.currentPlayerIndex;
        final isLeader = leader != null && leader.id == player.id;

        return _buildPlayerRow(context, player, isActive, isLeader);
      },
    );
  }

  Widget _buildPlayerRow(
      BuildContext context, Player player, bool isActive, bool isLeader) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF15242C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isLeader
              ? const Color(0xFFF59E0B).withValues(alpha: 0.5)
              : isActive
                  ? const Color(0xFF10B981).withValues(alpha: 0.4)
                  : const Color(0xFF2A3F4D),
          width: (isActive || isLeader) ? 1.5 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _navigateToPlayer(context, player.id),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Leader / Active indicator
                SizedBox(
                  width: 24,
                  child: isLeader
                      ? const Text('👑', style: TextStyle(fontSize: 16))
                      : isActive
                          ? Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                ),

                // Name and Completed count
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isLeader
                              ? const Color(0xFFFBBF24)
                              : Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        player.isWinnerByDormida
                            ? 'DORMIDA 🏆'
                            : '${player.scoreCard.completedCategoriesCount}/11 completadas',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Last change
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Último cambio',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        player.lastChange ?? '-',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Total Points
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${player.total}',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Go to Dashboard button
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF10B981),
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
