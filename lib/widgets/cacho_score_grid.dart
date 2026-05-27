import 'package:flutter/material.dart';
import '../models/score_card.dart';

class CachoScoreGrid extends StatelessWidget {
  final ScoreCard scoreCard;
  final bool compact;
  final void Function(String categoryKey)? onCellTap;

  const CachoScoreGrid({
    super.key,
    required this.scoreCard,
    this.compact = false,
    this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final double spacing = compact ? 4.0 : 8.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row 1: Balas, Escalera, Cuadras
        Row(
          children: [
            Expanded(
              child: _buildCell('balas', compact ? 'B' : 'BALAS'),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildCell('escalera', compact ? 'E' : 'ESCALERA'),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildCell('cuadras', compact ? 'C' : 'CUADRAS'),
            ),
          ],
        ),
        SizedBox(height: spacing),

        // Row 2: Duques, Full, Quinas
        Row(
          children: [
            Expanded(
              child: _buildCell('duques', compact ? 'D' : 'DUQUES'),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildCell('full', compact ? 'F' : 'FULL'),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildCell('quinas', compact ? 'Q' : 'QUINAS'),
            ),
          ],
        ),
        SizedBox(height: spacing),

        // Row 3: Trenes, Poker, Senas
        Row(
          children: [
            Expanded(
              child: _buildCell('trenes', compact ? 'T' : 'TRENES'),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildCell('poker', compact ? 'P' : 'PÓKER'),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildCell('senas', compact ? 'S' : 'SENAS'),
            ),
          ],
        ),
        SizedBox(height: spacing),

        // Row 4: Grande, Dormida
        Row(
          children: [
            Expanded(
              child: _buildCell('grande', compact ? 'G' : 'GRANDE'),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildCell('dormida', compact ? 'DO' : 'DORMIDA'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCell(String categoryKey, String label) {
    final entry = scoreCard.getEntry(categoryKey);
    final hasValue = entry.marked;
    final isTachado = entry.isTachado;

    Color? backgroundColor;
    Color borderColor = const Color(0xFF2A3F4D);
    Color textColor = Colors.white;
    Color labelColor = const Color(0xFF94A3B8);

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

    return Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onCellTap != null ? () => onCellTap!(categoryKey) : null,
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
