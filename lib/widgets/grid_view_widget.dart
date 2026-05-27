import 'package:flutter/material.dart';
import '../models/game.dart';
import 'player_card.dart';

class GridViewWidget extends StatelessWidget {
  final Game game;
  final void Function(String playerId, String playerName, String categoryKey) onCategoryTap;

  const GridViewWidget({
    super.key,
    required this.game,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final leader = game.leader;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.70,
        ),
        itemCount: game.players.length,
        itemBuilder: (context, index) {
          final player = game.players[index];
          final isActive = index == game.currentPlayerIndex;
          final isLeader = leader != null && leader.id == player.id;

          return PlayerCard(
            player: player,
            isActive: isActive,
            isLeader: isLeader,
            onCategoryTap: (categoryKey) =>
                onCategoryTap(player.id, player.name, categoryKey),
          );
        },
      ),
    );
  }
}
