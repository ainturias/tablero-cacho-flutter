import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/player.dart';
import 'cacho_score_grid.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final bool isActive;
  final bool isLeader;
  final void Function(String categoryKey) onCategoryTap;

  const PlayerCard({
    super.key,
    required this.player,
    this.isActive = false,
    this.isLeader = false,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isLeader
        ? const Color(0xFFF59E0B)
        : isActive
            ? const Color(0xFF10B981)
            : const Color(0xFF2A3F4D);

    final glowColor = isLeader
        ? const Color(0xFFF59E0B).withValues(alpha: 0.2)
        : isActive
            ? const Color(0xFF10B981).withValues(alpha: 0.15)
            : Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF15242C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: (isActive || isLeader) ? 1.5 : 1.0,
        ),
        boxShadow: [
          if (isActive || isLeader)
            BoxShadow(
              color: glowColor,
              blurRadius: 16,
              spreadRadius: 1,
            ),
        ],
      ),
      child: Stack(
        children: [
          // Background turn number
          Positioned(
            right: 8,
            top: 4,
            child: Text(
              '${player.currentTurn}',
              style: GoogleFonts.inter(
                fontSize: 64,
                fontWeight: FontWeight.w900,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: name + leader icon
                Row(
                  children: [
                    if (isLeader)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Text('👑', style: TextStyle(fontSize: 13)),
                      ),
                    Expanded(
                      child: Text(
                        player.name,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isLeader
                              ? const Color(0xFFFBBF24)
                              : Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isActive)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // Cacho Grid
                Expanded(
                  child: SingleChildScrollView(
                    child: CachoScoreGrid(
                      scoreCard: player.scoreCard,
                      compact: true,
                      onCellTap: onCategoryTap,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Footer: categories completed + total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      player.isWinnerByDormida
                          ? 'DORMIDA 🏆'
                          : '${player.scoreCard.completedCategoriesCount}/11 llenas',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${player.total}',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
