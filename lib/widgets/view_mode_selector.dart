import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game.dart';
import '../utils/game_utils.dart';

class ViewModeSelector extends StatelessWidget {
  final ViewMode currentMode;
  final ValueChanged<ViewMode> onChanged;

  const ViewModeSelector({
    super.key,
    required this.currentMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF15242C),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2A3F4D)),
        ),
        child: Row(
          children: ViewMode.values.map((mode) {
            final isSelected = mode == currentMode;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  onChanged(mode);
                  triggerHaptic();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF10B981)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getIcon(mode),
                        size: 16,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getLabel(mode),
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF94A3B8),
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
    );
  }

  IconData _getIcon(ViewMode mode) {
    switch (mode) {
      case ViewMode.grid:
        return Icons.grid_view_rounded;
      case ViewMode.single:
        return Icons.person_rounded;
      case ViewMode.list:
        return Icons.view_list_rounded;
    }
  }

  String _getLabel(ViewMode mode) {
    switch (mode) {
      case ViewMode.grid:
        return 'Tarjetas';
      case ViewMode.single:
        return 'Jugador';
      case ViewMode.list:
        return 'Lista';
    }
  }
}
