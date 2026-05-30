import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../controllers/settings_controller.dart';
import '../utils/game_utils.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  final _namesController = TextEditingController();
  int _playerCount = 4;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final settings = context.read<SettingsController>();
        if (settings.lastNames.isNotEmpty) {
          _namesController.text = settings.lastNames;
        }
      }
    });
  }

  @override
  void dispose() {
    _namesController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _startGame() {
    final names =
        parsePlayerNames(_namesController.text, _playerCount);

    if (names.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Se necesitan al menos 2 jugadores')),
      );
      return;
    }

    final controller = context.read<GameController>();
    controller.createGame(names);

    // Guardar los nombres para la próxima vez
    if (mounted) {
      context.read<SettingsController>().setLastNames(_namesController.text);
    }

    triggerHaptic();
  }

  void _loadGame() {
    final controller = context.read<GameController>();
    controller.loadSavedGame();
    triggerHaptic();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                // Logo / Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.casino_outlined,
                    size: 40,
                    color: Color(0xFF10B981),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  'Tablero de Cacho de los Bolomanes',
                  style: GoogleFonts.inter(
                    fontSize: 28, // Un poco más pequeño para que quepa bien
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Mauro se la come',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Configuration Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Names input
                      Text(
                        'Nombres de jugadores',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _namesController,
                        style: GoogleFonts.inter(color: Theme.of(context).colorScheme.onSurface, fontSize: 15),
                        decoration: const InputDecoration(
                          hintText: 'Jose, Mauro, Alex',
                          prefixIcon: Icon(Icons.people_outline, color: Color(0xFF94A3B8)),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Separados por comas o espacios. Si dejas vacío, se usarán nombres por defecto.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Player count selector
                      Text(
                        'Cantidad de jugadores',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildPlayerCountSelector(),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // Start button
                ElevatedButton(
                  onPressed: _startGame,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow_rounded, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Iniciar Partida',
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Load game button
                if (controller.hasSavedGame)
                  OutlinedButton(
                    onPressed: _loadGame,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.restore, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Cargar Última Partida',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 48),

                // Footer
                Text(
                  'programming by ainturias',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF475569),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerCountSelector() {
    Widget buildItem(int count) {
      final isSelected = count == _playerCount;
      return GestureDetector(
        onTap: () {
          setState(() => _playerCount = count);
          triggerHaptic();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 44,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF10B981)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF10B981)
                  : Theme.of(context).colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              '$count',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: buildItem(2)),
            const SizedBox(width: 8),
            Expanded(child: buildItem(3)),
            const SizedBox(width: 8),
            Expanded(child: buildItem(4)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: buildItem(5)),
            const SizedBox(width: 8),
            Expanded(child: buildItem(6)),
            const SizedBox(width: 8),
            Expanded(child: buildItem(7)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: buildItem(8)),
            const SizedBox(width: 8),
            Expanded(child: buildItem(9)),
            const SizedBox(width: 8),
            Expanded(child: buildItem(10)),
          ],
        ),
      ],
    );
  }
}
