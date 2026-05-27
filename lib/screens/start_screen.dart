import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
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
                  'Tablero de Cacho',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Anota tus resultados de forma rápida',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Names input
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nombres de jugadores',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _namesController,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 15),
                  decoration: const InputDecoration(
                    hintText: 'Alex, Deivid, Jose',
                    prefixIcon:
                        Icon(Icons.people_outline, color: Color(0xFF94A3B8)),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Separados por comas o espacios. Si dejas vacío, se usarán nombres por defecto.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Player count selector
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Cantidad de jugadores',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildPlayerCountSelector(),
                const SizedBox(height: 40),

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
                  'Solo para anotar resultados con dados físicos 🎲',
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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(9, (i) {
        final count = i + 2;
        final isSelected = count == _playerCount;

        return GestureDetector(
          onTap: () {
            setState(() => _playerCount = count);
            triggerHaptic();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 58,
            height: 44,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF10B981)
                  : const Color(0xFF15242C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF10B981)
                    : const Color(0xFF2A3F4D),
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
                  color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
