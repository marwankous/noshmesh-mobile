import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noshmesh/core/theme/app_theme_extension.dart';
import 'package:noshmesh/features/auth/domain/entities/user_entity.dart';

class TokenUsageWidget extends StatelessWidget {
  final UserEntity user;

  const TokenUsageWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final used = user.monthlyTokensUsed;
    final max = user.plan.maxMonthlyTokens;
    final planName = user.plan.name.isNotEmpty ? user.plan.name : 'Free';
    final progress = max > 0 ? (used / max).clamp(0.0, 1.0) : 0.0;
    final cs = Theme.of(context).colorScheme;
    final color = progress > 0.9 ? cs.statusCritical : (progress > 0.7 ? cs.statusWarning : cs.primary);
    
    final dateFormat = DateFormat('MM/dd/yyyy');
    final resetDateStr = dateFormat.format(user.tokenResetDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Tokens Used',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    planName,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Text(
              '$used / $max',
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withAlpha((255 * 0.2).round()),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Resets on: $resetDateStr',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: cs.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
