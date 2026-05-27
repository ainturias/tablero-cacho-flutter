import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
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

class _ScorePickerModalState extends State<ScorePickerModal> {
  bool _forceEditMode = false;

  List<CategoryOption> _getOptions() {
    switch (widget.categoryKey) {
      case 'balas':
        return const [
          CategoryOption(value: 0, label: 'Tachar Balas', isTachado: true),
          CategoryOption(value: 1, label: '1 Bala (de As)', mode: 'normal'),
          CategoryOption(value: 2, label: '2 Balas (de As)', mode: 'normal'),
          CategoryOption(value: 3, label: '3 Balas (de As)', mode: 'normal'),
          CategoryOption(value: 4, label: '4 Balas (de As)', mode: 'normal'),
          CategoryOption(value: 5, label: '5 Balas (de As)', mode: 'normal'),
        ];
      case 'duques':
        return const [
          CategoryOption(value: 0, label: 'Tachar Duques', isTachado: true),
          CategoryOption(value: 2, label: '1 Duque (de 2)', mode: 'normal'),
          CategoryOption(value: 4, label: '2 Duques (de 2)', mode: 'normal'),
          CategoryOption(value: 6, label: '3 Duques (de 2)', mode: 'normal'),
          CategoryOption(value: 8, label: '4 Duques (de 2)', mode: 'normal'),
          CategoryOption(value: 10, label: '5 Duques (de 2)', mode: 'normal'),
        ];
      case 'trenes':
        return const [
          CategoryOption(value: 0, label: 'Tachar Trenes', isTachado: true),
          CategoryOption(value: 3, label: '1 Tren (de 3)', mode: 'normal'),
          CategoryOption(value: 6, label: '2 Trenes (de 3)', mode: 'normal'),
          CategoryOption(value: 9, label: '3 Trenes (de 3)', mode: 'normal'),
          CategoryOption(value: 12, label: '4 Trenes (de 3)', mode: 'normal'),
          CategoryOption(value: 15, label: '5 Trenes (de 3)', mode: 'normal'),
        ];
      case 'cuadras':
        return const [
          CategoryOption(value: 0, label: 'Tachar Cuadras', isTachado: true),
          CategoryOption(value: 4, label: '1 Cuadra (de 4)', mode: 'normal'),
          CategoryOption(value: 8, label: '2 Cuadras (de 4)', mode: 'normal'),
          CategoryOption(value: 12, label: '3 Cuadras (de 4)', mode: 'normal'),
          CategoryOption(value: 16, label: '4 Cuadras (de 4)', mode: 'normal'),
          CategoryOption(value: 20, label: '5 Cuadras (de 4)', mode: 'normal'),
        ];
      case 'quinas':
        return const [
          CategoryOption(value: 0, label: 'Tachar Quinas', isTachado: true),
          CategoryOption(value: 5, label: '1 Quina (de 5)', mode: 'normal'),
          CategoryOption(value: 10, label: '2 Quinas (de 5)', mode: 'normal'),
          CategoryOption(value: 15, label: '3 Quinas (de 5)', mode: 'normal'),
          CategoryOption(value: 20, label: '4 Quinas (de 5)', mode: 'normal'),
          CategoryOption(value: 25, label: '5 Quinas (de 5)', mode: 'normal'),
        ];
      case 'senas':
        return const [
          CategoryOption(value: 0, label: 'Tachar Senas', isTachado: true),
          CategoryOption(value: 6, label: '1 Sena (de 6)', mode: 'normal'),
          CategoryOption(value: 12, label: '2 Senas (de 6)', mode: 'normal'),
          CategoryOption(value: 18, label: '3 Senas (de 6)', mode: 'normal'),
          CategoryOption(value: 24, label: '4 Senas (de 6)', mode: 'normal'),
          CategoryOption(value: 30, label: '5 Senas (de 6)', mode: 'normal'),
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
        return const [
          CategoryOption(value: 0, label: 'Tachar Grande', isTachado: true),
          CategoryOption(value: 50, label: 'Grande', mode: 'normal'),
        ];
      case 'dormida':
        return const [
          CategoryOption(value: 0, label: 'Tachar Dormida', isTachado: true),
          CategoryOption(value: 0, label: 'Ganó Dormida (Victoria)', mode: 'normal'),
        ];
      default:
        return const [];
    }
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
        return 'Cinco dados del mismo valor';
      case 'dormida':
        return 'Cinco dados iguales servidos (mano). ¡Gana el juego!';
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
      decoration: const BoxDecoration(
        color: Color(0xFF15242C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                  color: const Color(0xFF2A3F4D),
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
                  color: Colors.white,
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
                            widget.categoryKey == 'dormida') {
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
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    option.isTachado
                                        ? 'X'
                                        : (widget.categoryKey == 'dormida' && option.value == 0 && !option.isTachado
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
                color: Colors.white,
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
