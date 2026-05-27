import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../models/game.dart';
import '../widgets/game_summary.dart';
import '../widgets/view_mode_selector.dart';
import '../widgets/grid_view_widget.dart';
import '../widgets/single_player_view.dart';
import '../widgets/list_view_widget.dart';
import '../widgets/score_picker_modal.dart';
import '../widgets/confirm_dialog.dart';
import 'final_result_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  void _showScorePicker(
      BuildContext context, String playerId, String playerName, String categoryKey) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ScorePickerModal(
        playerId: playerId,
        playerName: playerName,
        categoryKey: categoryKey,
      ),
    );
  }

  void _showResetConfirm(BuildContext context) {
    final controller = context.read<GameController>();
    showDialog<bool>(
      context: context,
      builder: (_) => const ConfirmDialog(
        title: '¿Reiniciar partida?',
        message:
            'Se borrarán todos los puntajes y se volverá a la pantalla de inicio. Esta acción no se puede deshacer.',
        confirmText: 'Reiniciar',
        confirmColor: Color(0xFFEF4444),
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        controller.resetGame();
      }
    });
  }

  void _showFinishConfirm(BuildContext context) {
    final controller = context.read<GameController>();
    final navigator = Navigator.of(context);
    showDialog<bool>(
      context: context,
      builder: (_) => const ConfirmDialog(
        title: '¿Finalizar partida?',
        message: 'Se mostrará el ranking final con los resultados de todos los jugadores.',
        confirmText: 'Finalizar',
        confirmColor: Color(0xFF10B981),
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        controller.finishGame();
        navigator.push(
          MaterialPageRoute(builder: (_) => const FinalResultScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(
      builder: (context, controller, _) {
        final game = controller.currentGame!;

        // Automatically push final result screen if game is finished (e.g. via Dormida win)
        if (game.isFinished && ModalRoute.of(context)?.isCurrent == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const FinalResultScreen()),
            );
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Tablero de Cacho',
            ),
            actions: [
              // View mode cycle button
              IconButton(
                icon: Icon(_getViewModeIcon(game.viewMode)),
                tooltip: 'Cambiar vista',
                onPressed: () {
                  final modes = ViewMode.values;
                  final nextIndex =
                      (modes.indexOf(game.viewMode) + 1) % modes.length;
                  controller.setViewMode(modes[nextIndex]);
                },
              ),
              // Finish button
              IconButton(
                icon: const Icon(Icons.emoji_events_outlined),
                tooltip: 'Finalizar partida',
                onPressed: () => _showFinishConfirm(context),
              ),
              // Reset button
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Reiniciar',
                onPressed: () => _showResetConfirm(context),
              ),
            ],
          ),
          body: Column(
            children: [
              GameSummaryWidget(game: game),
              ViewModeSelector(
                currentMode: game.viewMode,
                onChanged: controller.setViewMode,
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _buildView(context, game, controller),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildView(
      BuildContext context, Game game, GameController controller) {
    switch (game.viewMode) {
      case ViewMode.grid:
        return GridViewWidget(
          key: const ValueKey('grid'),
          game: game,
          onCategoryTap: (id, name, catKey) => _showScorePicker(context, id, name, catKey),
        );
      case ViewMode.single:
        return SinglePlayerView(
          key: const ValueKey('single'),
          game: game,
          onCategoryTap: (id, name, catKey) => _showScorePicker(context, id, name, catKey),
          onNext: controller.nextPlayer,
          onPrevious: controller.previousPlayer,
        );
      case ViewMode.list:
        return ListViewWidget(
          key: const ValueKey('list'),
          game: game,
        );
    }
  }

  IconData _getViewModeIcon(ViewMode mode) {
    switch (mode) {
      case ViewMode.grid:
        return Icons.grid_view_rounded;
      case ViewMode.single:
        return Icons.person_rounded;
      case ViewMode.list:
        return Icons.view_list_rounded;
    }
  }
}
