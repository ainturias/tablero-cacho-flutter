import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../models/game.dart';
import '../models/score_card.dart';
import '../widgets/game_summary.dart';
import '../widgets/view_mode_selector.dart';
import '../widgets/grid_view_widget.dart';
import '../widgets/single_player_view.dart';
import '../widgets/list_view_widget.dart';
import '../widgets/score_picker_modal.dart';
import '../widgets/confirm_dialog.dart';
import '../controllers/settings_controller.dart';
import '../utils/game_utils.dart';
import 'final_result_screen.dart';
import 'settings_modal.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  void _showScorePicker(
      BuildContext context, String playerId, String playerName, String categoryKey, TapDownDetails? details) {
    final settings = context.read<SettingsController>();
    if (settings.fastScoring && details != null) {
      _showFastScoreMenu(context, playerId, playerName, categoryKey, details);
    } else {
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
  }

  void _showFastScoreMenu(
      BuildContext context, String playerId, String playerName, String categoryKey, TapDownDetails details) async {
    final controller = context.read<GameController>();
    final options = getCategoryOptions(context, categoryKey);
    final player = controller.currentGame?.players.firstWhere((p) => p.id == playerId);
    final entry = player?.scoreCard.getEntry(categoryKey);
    final hasValue = entry != null && entry.marked;

    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        details.globalPosition,
        details.globalPosition,
      ),
      Offset.zero & overlay.size,
    );

    final selected = await showMenu<String>(
      context: context,
      position: position,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      items: [
        if (hasValue) ...[
          PopupMenuItem<String>(
            value: 'clear',
            child: Row(
              children: [
                const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 18),
                const SizedBox(width: 8),
                Text('Borrar anotación', style: GoogleFonts.inter(color: Colors.red, fontSize: 13)),
              ],
            ),
          ),
          const PopupMenuDivider(),
        ],
        ...options.map((option) {
          final isTachadoVal = option.isTachado;
          final color = isTachadoVal ? Colors.red : Theme.of(context).colorScheme.primary;
          return PopupMenuItem<String>(
            value: '${option.value}|${option.label}|${option.isTachado}|${option.mode ?? "normal"}',
            child: Center(
              child: Text(
                isTachadoVal ? '0' : (categoryKey == 'grande2' && option.value == 0 ? '👑' : '${option.value}'),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }),
      ],
    );

    if (selected != null) {
      if (selected == 'clear') {
        controller.updateScoreCategory(playerId, categoryKey, null);
      } else {
        final parts = selected.split('|');
        final val = int.parse(parts[0]);
        final isTachado = parts[2] == 'true';
        final mode = parts[3];

        final scoreEntry = ScoreEntry(
          value: val,
          label: isTachado ? 'X' : (mode == 'mano' ? 'M' : (mode == 'tres_tiros' ? '3T' : '')),
          marked: true,
          isTachado: isTachado,
          mode: mode,
        );
        controller.updateScoreCategory(playerId, categoryKey, scoreEntry);
      }
      triggerHaptic();
    }
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
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (value) {
                  switch (value) {
                    case 'view':
                      final modes = ViewMode.values;
                      final nextIndex =
                          (modes.indexOf(game.viewMode) + 1) % modes.length;
                      controller.setViewMode(modes[nextIndex]);
                      break;
                    case 'settings':
                      showSettingsModal(context);
                      break;
                    case 'finish':
                      _showFinishConfirm(context);
                      break;
                    case 'reset':
                      _showResetConfirm(context);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(_getViewModeIcon(game.viewMode), size: 20),
                        const SizedBox(width: 12),
                        const Text('Cambiar Vista'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Ajustes'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'finish',
                    child: Row(
                      children: [
                        Icon(Icons.emoji_events_outlined, color: Color(0xFF10B981), size: 20),
                        SizedBox(width: 12),
                        Text('Finalizar Partida', style: TextStyle(color: Color(0xFF10B981))),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'reset',
                    child: Row(
                      children: [
                        Icon(Icons.refresh_rounded, color: Color(0xFFEF4444), size: 20),
                        SizedBox(width: 12),
                        Text('Reiniciar Partida', style: TextStyle(color: Color(0xFFEF4444))),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              if (context.watch<SettingsController>().showHeader)
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
          onCategoryTap: (id, name, catKey, details) => _showScorePicker(context, id, name, catKey, details),
        );
      case ViewMode.single:
        return SinglePlayerView(
          key: const ValueKey('single'),
          game: game,
          onCategoryTap: (id, name, catKey, details) => _showScorePicker(context, id, name, catKey, details),
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
