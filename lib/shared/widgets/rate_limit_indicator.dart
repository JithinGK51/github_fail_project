import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/github_api_service.dart';

class RateLimitIndicator extends ConsumerWidget {
  const RateLimitIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiService = ref.watch(githubApiServiceProvider);
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.speed_rounded, color: theme.primaryColor, size: 16),
          const SizedBox(width: 8),
          Text(
            'Rate Limit: ${apiService.remainingRequests} remaining',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const Spacer(),
          if (apiService.isRateLimited) ...[
            Icon(
              Icons.warning_rounded,
              color: theme.colorScheme.error,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              'Rate Limited',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else ...[
            Icon(
              Icons.check_circle_rounded,
              color: theme.colorScheme.primary,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              'OK',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
