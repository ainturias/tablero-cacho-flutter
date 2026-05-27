import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/score_card.dart';
import '../controllers/settings_controller.dart';

class CachoScoreGrid extends StatelessWidget {
  final ScoreCard scoreCard;
  final bool compact;
  final void Function(String categoryKey, TapDownDetails? details)? onCellTap;

  const CachoScoreGrid({
    super.key,
    required this.scoreCard,
    this.compact = false,
    this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final double spacing = compact ? 4.0 : 8.0;
    final grandesCount = context.watch<SettingsController>().grandesCount;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row 1: Balas, Escalera, Cuadras
        Row(
          children: [
            Expanded(
              child: _buildCell(context, 'balas', compact ? 'B' : 'BALAS'),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildCell(context, 'escalera', compact ? 'E' : 'ESCALERA'),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildCell(context, 'cuadras', compact ? 'C' : 'CUADRAS'),
            ),
          ],
        ),
        SizedBox(height: spacing),

        // Row 2: Duques, Full, Quinas
        Row(
          children: [
            Expanded(
              child: _buildCell(context, 'duques', compact ? 'D' : 'DUQUES'),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildCell(context, 'full', compact ? 'F' : 'FULL'),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildCell(context, 'quinas', compact ? 'Q' : 'QUINAS'),
            ),
          ],
        ),
        SizedBox(height: spacing),

        // Row 3: Trenes, Poker, Senas
        Row(
          children: [
            Expanded(
              child: _buildCell(context, 'trenes', compact ? 'T' : 'TRENES'),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildCell(context, 'poker', compact ? 'P' : 'PÓKER'),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildCell(context, 'senas', compact ? 'S' : 'SENAS'),
            ),
          ],
        ),
        SizedBox(height: spacing),

        // Row 4: Grande, Grande 2 (optional)
        Row(
          children: [
            Expanded(
              child: _buildCell(context, 'grande', compact ? 'G' : 'GRANDE'),
            ),
            if (grandesCount == 2) ...[
              SizedBox(width: spacing),
              Expanded(
                child: _buildCell(context, 'grande2', compact ? 'G2' : 'GRANDE 2'),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildCell(BuildContext context, String categoryKey, String label) {
    final entry = scoreCard.getEntry(categoryKey);
    final hasValue = entry.marked;
    final isTachado = entry.isTachado;

    Color? backgroundColor;
    Color borderColor = Theme.of(context).colorScheme.outline;
    Color textColor = Theme.of(context).colorScheme.onSurface;
    Color labelColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);

    if (hasValue) {
      if (isTachado) {
        borderColor = const Color(0xFFEF4444);
        backgroundColor = const Color(0xFFEF4444).withValues(alpha: 0.08);
        textColor = const Color(0xFFEF4444);
      } else {
        borderColor = const Color(0xFF10B981);
        backgroundColor = const Color(0xFF10B981).withValues(alpha: 0.08);
        textColor = const Color(0xFF10B981);
      }
    }

    final double verticalPadding = compact ? 8.0 : 16.0;
    final double titleFontSize = compact ? 10.0 : 12.0;
    final double valueFontSize = compact ? 15.0 : 22.0;

    TapDownDetails? tapDetails;

    return Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTapDown: (details) => tapDetails = details,
        onTap: onCellTap != null ? () => onCellTap!(categoryKey, tapDetails) : null,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 4),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: hasValue ? 1.5 : 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: hasValue ? textColor.withValues(alpha: 0.9) : labelColor,
                  letterSpacing: compact ? -0.5 : 0.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: compact ? 2.0 : 6.0),
              if (hasValue) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      isTachado ? 'X' : '${entry.value}',
                      style: TextStyle(
                        fontSize: valueFontSize,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    if (entry.mode != null && entry.mode != 'normal' && !isTachado) ...[
                      const SizedBox(width: 2),
                      Text(
                        entry.mode == 'mano' ? 'M' : '3T',
                        style: TextStyle(
                          fontSize: compact ? 8.0 : 11.0,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF34D399),
                        ),
                      ),
                    ],
                  ],
                ),
              ] else ...[
                Text(
                  '+',
                  style: TextStyle(
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF475569),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
