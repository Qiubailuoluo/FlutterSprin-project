import 'package:flutter/material.dart';

/// 首页统计卡片：标题 + 金额 + 可选图标色。
class StatsCard extends StatelessWidget {
  const StatsCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    this.color,
  });

  final String title;
  final String amount;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? Theme.of(context).colorScheme.primary;

    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: accent),
                  const SizedBox(width: 8),
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '¥$amount',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: accent,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
