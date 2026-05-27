import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../controllers/settings_controller.dart';
import '../models/score_card.dart';
import '../utils/game_utils.dart';

class CategoryOption {
  final int value;
  final String label;
  final String? mode;
  final bool isTachado;

  const CategoryOption({
    required this.value,
    required this.label,
    this.mode,
    this.isTachado = false,
  });
}

class ScorePickerModal extends StatefulWidget {
  final String playerId;
  final String playerName;
  final String categoryKey;

  const ScorePickerModal({
    super.key,
    required this.playerId,
    required this.playerName,
    required this.categoryKey,
  });

  @override
  State<ScorePickerModal> createState() => _ScorePickerModalState();
}

List<CategoryOption> getCategoryOptions(BuildContext context, String categoryKey) {
  switch (categoryKey) {
    case 'balas':
      return const [
        CategoryOption(value: 0, label: 'Tachar Balas', isTachado: true),
        CategoryOption(value: 1, label: '1 Bala', mode: 'normal'),
        CategoryOption(value: 2, label: '2 Balas', mode: 'normal'),
        CategoryOption(value: 3, label: '3 Balas', mode: 'normal'),
        CategoryOption(value: 4, label: '4 Balas', mode: 'normal'),
        CategoryOption(value: 5, label: '5 Balas', mode: 'normal'),
      ];
    case 'duques':
      return const [
        CategoryOption(value: 0, label: 'Tachar Duques', isTachado: true),
        CategoryOption(value: 2, label: '1 Duque', mode: 'normal'),
        CategoryOption(value: 4, label: '2 Duques', mode: 'normal'),
        CategoryOption(value: 6, label: '3 Duques', mode: 'normal'),
        CategoryOption(value: 8, label: '4 Duques', mode: 'normal'),
        CategoryOption(value: 10, label: '5 Duques', mode: 'normal'),
      ];
    case 'trenes':
      return const [
        CategoryOption(value: 0, label: 'Tachar Trenes', isTachado: true),
        CategoryOption(value: 3, label: '1 Tren', mode: 'normal'),
        CategoryOption(value: 6, label: '2 Trenes', mode: 'normal'),
        CategoryOption(value: 9, label: '3 Trenes', mode: 'normal'),
        CategoryOption(value: 12, label: '4 Trenes', mode: 'normal'),
        CategoryOption(value: 15, label: '5 Trenes', mode: 'normal'),
      ];
    case 'cuadras':
      return const [
        CategoryOption(value: 0, label: 'Tachar Cuadras', isTachado: true),
        CategoryOption(value: 4, label: '1 Cuadra', mode: 'normal'),
        CategoryOption(value: 8, label: '2 Cuadras', mode: 'normal'),
        CategoryOption(value: 12, label: '3 Cuadras', mode: 'normal'),
        CategoryOption(value: 16, label: '4 Cuadras', mode: 'normal'),
        CategoryOption(value: 20, label: '5 Cuadras', mode: 'normal'),
      ];
    case 'quinas':
      return const [
        CategoryOption(value: 0, label: 'Tachar Quinas', isTachado: true),
        CategoryOption(value: 5, label: '1 Quina', mode: 'normal'),
        CategoryOption(value: 10, label: '2 Quinas', mode: 'normal'),
        CategoryOption(value: 15, label: '3 Quinas', mode: 'normal'),
        CategoryOption(value: 20, label: '4 Quinas', mode: 'normal'),
        CategoryOption(value: 25, label: '5 Quinas', mode: 'normal'),
      ];
    case 'senas':
      return const [
        CategoryOption(value: 0, label: 'Tachar Senas', isTachado: true),
        CategoryOption(value: 6, label: '1 Sena', mode: 'normal'),
        CategoryOption(value: 12, label: '2 Senas', mode: 'normal'),
        CategoryOption(value: 18, label: '3 Senas', mode: 'normal'),
        CategoryOption(value: 24, label: '4 Senas', mode: 'normal'),
        CategoryOption(value: 30, label: '5 Senas', mode: 'normal'),
      ];
    case 'escalera':
      return const [
        CategoryOption(value: 0, label: 'Tachar Escalera', isTachado: true),
        CategoryOption(value: 20, label: 'Escalera de 3 tiros', mode: 'tres_tiros'),
        CategoryOption(value: 25, label: 'Escalera de mano', mode: 'mano'),
      ];
    case 'full':
      return const [
        CategoryOption(value: 0, label: 'Tachar Full', isTachado: true),
        CategoryOption(value: 30, label: 'Full de 3 tiros', mode: 'tres_tiros'),
        CategoryOption(value: 35, label: 'Full de mano', mode: 'mano'),
      ];
    case 'poker':
      return const [
        CategoryOption(value: 0, label: 'Tachar Póker', isTachado: true),
        CategoryOption(value: 40, label: 'Póker de 3 tiros', mode: 'tres_tiros'),
        CategoryOption(value: 45, label: 'Póker de mano', mode: 'mano'),
      ];
    case 'grande':
      final isMano = context.read<SettingsController>().grande1Mano;
      return [
        const CategoryOption(value: 0, label: 'Tachar Grande', isTachado: true),
        const CategoryOption(value: 50, label: 'Grande de mesa', mode: 'normal'),
        if (isMano)
          const CategoryOption(value: 55, label: 'Grande de mano', mode: 'mano'),
      ];
    case 'grande2':
      final isInstaWin = context.read<SettingsController>().grande2Behavior == 'instaWin';
      final isMano = context.read<SettingsController>().grande1Mano;
      return [
        const CategoryOption(value: 0, label: 'Tachar Grande 2', isTachado: true),
        if (isInstaWin)
          const CategoryOption(value: 0, label: 'Ganó Grande 2 (Victoria)', mode: 'normal')
        else ...[
          const CategoryOption(value: 50, label: 'Grande 2 de mesa', mode: 'normal'),
          if (isMano)
            const CategoryOption(value: 55, label: 'Grande 2 de mano', mode: 'mano'),
        ],
      ];
    default:
      return const [];
  }
}

class _ScorePickerModalState extends State<ScorePickerModal> {
  bool _forceEditMode = false;

  List<CategoryOption> _getOptions() {
    return getCategoryOptions(context, widget.categoryKey);
  }

  void _selectOption(CategoryOption option) {
    final controller = context.read<GameController>();
    final entry = ScoreEntry(
      value: option.value,
      label: option.isTachado ? 'X' : (option.mode == 'mano' ? 'M' : (option.mode == 'tres_tiros' ? '3T' : '')),
      marked: true,
      isTachado: option.isTachado,
      mode: option.mode,
    );
    controller.updateScoreCategory(widget.playerId, widget.categoryKey, entry);
    Navigator.of(context).pop();
  }

  void _clearCategory() {
    final controller = context.read<GameController>();
    controller.updateScoreCategory(widget.playerId, widget.categoryKey, null);
    Navigator.of(context).pop();
  }

  void _tacharCategory() {
    final controller = context.read<GameController>();
    final entry = ScoreEntry(
      value: 0,
      label: 'X',
      marked: true,
      isTachado: true,
      mode: 'normal',
    );
    controller.updateScoreCategory(widget.playerId, widget.categoryKey, entry);
    Navigator.of(context).pop();
  }

  String _getCategoryTitle() {
    if (widget.categoryKey == 'grande2') return 'GRANDE 2';
    return widget.categoryKey.toUpperCase();
  }

  String _getCategoryExplanation() {
    switch (widget.categoryKey) {
      case 'balas':
        return 'Suma de dados con el número 1';
      case 'duques':
        return 'Suma de dados con el número 2';
      case 'trenes':
        return 'Suma de dados con el número 3';
      case 'cuadras':
        return 'Suma de dados con el número 4';
      case 'quinas':
        return 'Suma de dados con el número 5';
      case 'senas':
        return 'Suma de dados con el número 6';
      case 'escalera':
        return 'Números correlativos (1-2-3-4-5 o 2-3-4-5-6)';
      case 'full':
        return 'Tres dados de un valor y dos de otro';
      case 'poker':
        return 'Cuatro dados del mismo valor';
      case 'grande':
        final isMano = context.read<SettingsController>().grande1Mano;
        return isMano
            ? 'Cinco dados del mismo valor. Anota 50 pts (de mesa) o 55 pts (de mano).'
            : 'Cinco dados del mismo valor. Anota 50 puntos.';
      case 'grande2':
        final isInstaWin = context.read<SettingsController>().grande2Behavior == 'instaWin';
        final isMano = context.read<SettingsController>().grande1Mano;
        if (isInstaWin) {
          return 'Cinco dados iguales en tu segundo tiro. ¡Gana la partida directamente!';
        } else {
          return isMano
              ? 'Cinco dados iguales en tu segundo tiro. Anota 50 pts (de mesa) o 55 pts (de mano).'
              : 'Cinco dados iguales en tu segundo tiro. Anota 50 puntos.';
        }
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<GameController>();
    final player = controller.currentGame?.players
        .firstWhere((p) => p.id == widget.playerId);
    final entry = player?.scoreCard.getEntry(widget.categoryKey) ?? ScoreEntry.empty();
    final hasValue = entry.marked;

    // Show options menu if category already has value and we are not forcing edit mode
    final showOptionsMenu = hasValue && !_forceEditMode;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Text(
                widget.playerName,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _getCategoryTitle(),
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getCategoryExplanation(),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF64748B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              if (showOptionsMenu) ...[
                // OPTIONS MENU (Edit, Clear, Tachar)
                _buildMenuButton(
                  icon: Icons.edit_rounded,
                  label: 'Editar Anotación',
                  color: const Color(0xFF3B82F6),
                  onTap: () {
                    setState(() => _forceEditMode = true);
                    triggerHaptic();
                  },
                ),
                const SizedBox(height: 10),
                _buildMenuButton(
                  icon: Icons.delete_outline_rounded,
                  label: 'Borrar Anotación',
                  color: const Color(0xFFEF4444),
                  onTap: _clearCategory,
                ),
                const SizedBox(height: 10),
                if (!entry.isTachado) ...[
                  _buildMenuButton(
                    icon: Icons.close_rounded,
                    label: 'Tachar Casilla (0 pts)',
                    color: const Color(0xFFF59E0B),
                    onTap: _tacharCategory,
                  ),
                  const SizedBox(height: 10),
                ],
              ] else ...[
                // SCORE VALUES SELECTION
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.45,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: _getOptions().map((option) {
                        Color buttonColor = const Color(0xFF10B981); // Green for normal
                        if (option.isTachado) {
                          buttonColor = const Color(0xFFEF4444); // Red for tachar
                        } else if (widget.categoryKey == 'escalera' ||
                            widget.categoryKey == 'full' ||
                            widget.categoryKey == 'poker' ||
                            widget.categoryKey == 'grande' ||
                            widget.categoryKey == 'grande2') {
                          buttonColor = const Color(0xFF3B82F6); // Blue for special hands
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: InkWell(
                            onTap: () => _selectOption(option),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: buttonColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: buttonColor.withValues(alpha: 0.25),
                                    width: 1.2),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    option.label,
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    option.isTachado
                                        ? 'X'
                                        : (widget.categoryKey == 'grande2' && option.value == 0 && !option.isTachado
                                            ? '👑'
                                            : '${option.value}'),
                                    style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: buttonColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Cancel button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25), width: 1.2),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, color: color.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}
