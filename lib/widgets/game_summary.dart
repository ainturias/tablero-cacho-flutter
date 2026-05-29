import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game.dart';

class GameSummaryWidget extends StatelessWidget {
  final Game game;

  const GameSummaryWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final leader = game.leader;
    final currentPlayer = game.currentPlayer;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Ronda (Left)
          Expanded(
            flex: 1,
            child: _buildSideBadge(
              context,
              icon: Icons.loop_rounded,
              color: const Color(0xFF64748B),
              title: 'Ronda',
              value: '${game.currentRound}',
            ),
          ),

          // Turno (Center, prominent)
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'TURNO ACTUAL',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    currentPlayer.name,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Lider (Right)
          Expanded(
            flex: 1,
            child: _buildSideBadge(
              context,
              icon: Icons.emoji_events_rounded,
              color: const Color(0xFFF59E0B),
              title: 'Líder',
              value: leader?.name ?? '-',
              subtitle: leader != null ? '${leader.total} pts' : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideBadge(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    String? subtitle,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ],
    );
  }
}
