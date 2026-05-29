import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controllers/settings_controller.dart';
import '../utils/game_utils.dart';

class SettingsModal extends StatelessWidget {
  const SettingsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Text(
                'Ajustes',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),

              // --- SECCIÓN: INTERFAZ ---
              _buildSectionTitle('Interfaz', context),
              const SizedBox(height: 12),
              _buildSettingSwitch(
                context,
                icon: settings.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                iconColor: const Color(0xFFF59E0B),
                title: 'Modo Oscuro',
                description: 'Cambiar entre tema claro y oscuro para el tablero.',
                value: settings.isDarkMode,
                onChanged: (val) {
                  settings.toggleDarkMode();
                  triggerHaptic();
                },
              ),
              const SizedBox(height: 12),
              _buildSettingSwitch(
                context,
                icon: Icons.table_rows_rounded,
                iconColor: const Color(0xFF3B82F6),
                title: 'Cabecera de Juego',
                description: 'Mostrar turno, ronda y líder en la parte superior.',
                value: settings.showHeader,
                onChanged: (val) {
                  settings.toggleShowHeader();
                  triggerHaptic();
                },
              ),
              const SizedBox(height: 12),
              _buildSettingSwitch(
                context,
                icon: Icons.view_carousel_rounded,
                iconColor: const Color(0xFFEAB308),
                title: 'Selector de Vistas',
                description: 'Mostrar las opciones para cambiar entre vista de tarjetas, jugador y lista.',
                value: settings.showViewSelector,
                onChanged: (val) {
                  settings.toggleShowViewSelector();
                  triggerHaptic();
                },
              ),
              const SizedBox(height: 32),

              // --- SECCIÓN: REGLAS DEL JUEGO ---
              _buildSectionTitle('Reglas del Juego', context),
              const SizedBox(height: 12),
              _buildSettingSwitch(
                context,
                icon: Icons.star_rounded,
                iconColor: const Color(0xFF8B5CF6),
                title: 'Grande de mano (55 pts)',
                description: 'Permitir anotar 55 pts si se saca la primera Grande de un solo tiro.',
                value: settings.grande1Mano,
                onChanged: (val) {
                  settings.toggleGrande1Mano();
                  triggerHaptic();
                },
              ),
              const SizedBox(height: 12),
              _buildGrandesCount(context, settings),
              if (settings.grandesCount == 2) ...[
                const SizedBox(height: 12),
                _buildGrande2Behavior(context, settings),
              ],
              const SizedBox(height: 32),

              // --- SECCIÓN: JUGABILIDAD ---
              _buildSectionTitle('Jugabilidad', context),
              const SizedBox(height: 12),
              _buildSettingSwitch(
                context,
                icon: Icons.bolt_rounded,
                iconColor: const Color(0xFF06B6D4),
                title: 'Menú rápido',
                description: 'Anota los puntajes con un menú desplegable pequeño y rápido sin abrir la ventana flotante.',
                value: settings.fastScoring,
                onChanged: (val) {
                  settings.toggleFastScoring();
                  triggerHaptic();
                },
              ),
              
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cerrar',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF94A3B8),
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

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingSwitch(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildGrandesCount(BuildContext context, SettingsController settings) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.casino_rounded,
                  color: Color(0xFFF59E0B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cantidad de Grandes',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '¿Con cuántas grandes deseas jugar?',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildGrandeOption(
                  context,
                  value: 1,
                  label: '1 Grande',
                  isSelected: settings.grandesCount == 1,
                  onTap: () {
                    settings.setGrandesCount(1);
                    triggerHaptic();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGrandeOption(
                  context,
                  value: 2,
                  label: '2 Grandes',
                  isSelected: settings.grandesCount == 2,
                  onTap: () {
                    settings.setGrandesCount(2);
                    triggerHaptic();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrande2Behavior(BuildContext context, SettingsController settings) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Regla de Grande 2',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '¿Qué ocurre al anotar la segunda grande?',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildBehaviorOption(
                  context,
                  value: 'points',
                  label: 'Anotar 50 pts',
                  isSelected: settings.grande2Behavior == 'points',
                  onTap: () {
                    settings.setGrande2Behavior('points');
                    triggerHaptic();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBehaviorOption(
                  context,
                  value: 'instaWin',
                  label: 'Ganar partida',
                  isSelected: settings.grande2Behavior == 'instaWin',
                  onTap: () {
                    settings.setGrande2Behavior('instaWin');
                    triggerHaptic();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrandeOption(
    BuildContext context, {
    required int value,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF59E0B).withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFF59E0B) : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? const Color(0xFFFBBF24) : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildBehaviorOption(
    BuildContext context, {
    required String value,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF10B981).withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF10B981) : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? const Color(0xFF34D399) : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

void showSettingsModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const SettingsModal(),
  );
}
