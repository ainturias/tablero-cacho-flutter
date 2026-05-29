import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game.dart';
import '../models/player.dart';
import 'cacho_score_grid.dart';

class SinglePlayerView extends StatefulWidget {
  final Game game;
  final void Function(String playerId, String playerName, String categoryKey, TapDownDetails? details) onCategoryTap;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const SinglePlayerView({
    super.key,
    required this.game,
    required this.onCategoryTap,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<SinglePlayerView> createState() => _SinglePlayerViewState();
}

class _SinglePlayerViewState extends State<SinglePlayerView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.game.currentPlayerIndex);
  }

  @override
  void didUpdateWidget(SinglePlayerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the game's active turn changed, animate to that player's page
    if (widget.game.currentPlayerIndex != oldWidget.game.currentPlayerIndex) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          widget.game.currentPlayerIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_pageController.hasClients) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _goToPreviousPage() {
    if (_pageController.hasClients) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.game.players.length,
            itemBuilder: (context, index) {
              final player = widget.game.players[index];
              return _buildPlayerCard(context, player, index);
            },
          ),
        ),
        
        // Navigation buttons below
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Previous
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _goToPreviousPage,
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: Text(
                    'Anterior',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 52),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Next
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _goToNextPage,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: Text(
                    'Siguiente',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 52),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildPlayerCard(BuildContext context, Player player, int index) {
    final isLeader = widget.game.isPlayerLeading(player.id);
    final isActiveTurn = index == widget.game.currentPlayerIndex;
    final playerNumber = index + 1;
    final totalPlayers = widget.game.players.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Player indicator
          Text(
            'Jugador $playerNumber de $totalPlayers',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          // Main card
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActiveTurn 
                      ? const Color(0xFF10B981) // Green border for active turn
                      : isLeader
                          ? const Color(0xFFF59E0B).withValues(alpha: 0.5)
                          : Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  width: isActiveTurn ? 2.0 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isActiveTurn
                        ? const Color(0xFF10B981).withValues(alpha: 0.15)
                        : isLeader
                            ? const Color(0xFFF59E0B).withValues(alpha: 0.1)
                            : Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Active Turn Indicator
                  if (isActiveTurn)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        '¡TU TURNO!',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF10B981),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),

                  // Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isLeader && !isActiveTurn)
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Text('👑', style: TextStyle(fontSize: 24)),
                        ),
                      Flexible(
                        child: Text(
                          player.name,
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: isActiveTurn 
                                ? const Color(0xFF10B981)
                                : isLeader
                                    ? const Color(0xFFFBBF24)
                                    : Theme.of(context).colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isLeader && isActiveTurn)
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text('👑', style: TextStyle(fontSize: 24)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Total points / Grande 2 win state
                  if (player.isWinnerByDormida) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBBF24).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        'GANÓ GRANDE 2 🏆',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFBBF24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${player.total}',
                          style: GoogleFonts.inter(
                            fontSize: 54,
                            fontWeight: FontWeight.w900,
                            color: isActiveTurn ? const Color(0xFF10B981) : Theme.of(context).colorScheme.primary,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'pts',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Cacho Grid (Large)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: CachoScoreGrid(
                          scoreCard: player.scoreCard,
                          compact: false,
                          onCellTap: (categoryKey, details) =>
                              widget.onCategoryTap(player.id, player.name, categoryKey, details),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
