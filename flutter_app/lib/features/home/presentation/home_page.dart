import 'package:flutter/material.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/features/home/presentation/widgets/stats_card.dart';
import 'package:ledger/features/stats/data/models/month_stats.dart';
import 'package:ledger/features/stats/data/stats_api.dart';

/// 首页：展示当月收入/支出/结余统计卡片。
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StatsApi _statsApi = AppServices.instance.statsApi;

  MonthStats? _stats;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await _statsApi.getMonthStats();
    if (!mounted) return;

    setState(() {
      _loading = false;
      if (result.isSuccess && result.data != null) {
        _stats = result.data;
      } else {
        _error = result.message.isNotEmpty ? result.message : '加载统计失败';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('本月概览', style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              if (_stats != null)
                Text(
                  _stats!.monthLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              const SizedBox(width: 12),
              IconButton(
                tooltip: '刷新',
                onPressed: _loading ? null : _loadStats,
                icon: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_loading && _stats == null)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(48),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_error != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade400),
                    const SizedBox(width: 12),
                    Expanded(child: Text(_error!)),
                    TextButton(onPressed: _loadStats, child: const Text('重试')),
                  ],
                ),
              ),
            )
          else if (_stats != null)
            LayoutBuilder(
              builder: (context, constraints) {
                final cards = [
                  StatsCard(
                    title: '收入',
                    amount: _stats!.income,
                    icon: Icons.arrow_downward,
                    color: Colors.green.shade600,
                  ),
                  StatsCard(
                    title: '支出',
                    amount: _stats!.expense,
                    icon: Icons.arrow_upward,
                    color: Colors.orange.shade700,
                  ),
                  StatsCard(
                    title: '结余',
                    amount: _stats!.balance,
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                ];

                if (constraints.maxWidth >= 720) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < cards.length; i++) ...[
                        if (i > 0) const SizedBox(width: 16),
                        cards[i],
                      ],
                    ],
                  );
                }

                return Column(
                  children: [
                    for (var i = 0; i < cards.length; i++) ...[
                      if (i > 0) const SizedBox(height: 12),
                      cards[i],
                    ],
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
