import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class TimerIndicator extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;

  const TimerIndicator({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final double fraction = totalSeconds > 0
        ? (remainingSeconds / totalSeconds).clamp(0.0, 1.0)
        : 0.0;

    Color timerColor;
    if (fraction > 0.5) {
      timerColor = AppTheme.primary;
    } else if (fraction > 0.25) {
      timerColor = AppTheme.warning;
    } else {
      timerColor = AppTheme.incorrect;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: timerColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: timerColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              value: fraction,
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(timerColor),
              backgroundColor: timerColor.withOpacity(0.2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${remainingSeconds}s',
            style: TextStyle(
              color: timerColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
