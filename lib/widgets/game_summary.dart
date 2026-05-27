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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF15242C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A3F4D)),
      ),
      child: Row(
        children: [
          _buildInfoChip(
            '🎯',
            currentPlayer.name,
            'Turno',
          ),
          _buildDivider(),
          _buildInfoChip(
            '🔄',
            'Ronda ${game.currentRound}',
            '',
          ),
          _buildDivider(),
          _buildInfoChip(
            '👑',
            leader?.name ?? 'Empate',
            leader != null ? '${leader.total} pts' : '',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String emoji, String title, String subtitle) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 2),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: const Color(0xFF94A3B8),
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 32,
      color: const Color(0xFF2A3F4D),
    );
  }
}
