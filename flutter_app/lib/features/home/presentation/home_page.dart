import 'package:flutter/material.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/core/l10n/app_locale.dart';
import 'package:ledger/core/l10n/app_strings.dart';
import 'package:ledger/core/widgets/async_state_view.dart';
import 'package:ledger/core/widgets/page_header.dart';
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
  final AppLocaleController _locale = AppServices.instance.locale;

  MonthStats? _stats;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _locale.addListener(_onLocaleChanged);
    _loadStats();
  }

  @override
  void dispose() {
    _locale.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onLocaleChanged() {
    if (mounted) setState(() {});
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
        _error = result.message.isNotEmpty
            ? result.message
            : AppStrings.t(_locale.language, 'home.loadFailed');
      }
    });
  }

  bool _isAllZero(MonthStats stats) {
    return stats.income == '0.00' &&
        stats.expense == '0.00' &&
        stats.balance == '0.00';
  }

  @override
  Widget build(BuildContext context) {
    final lang = _locale.language;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: AppStrings.t(lang, 'home.overview'),
            actions: [
              if (_stats != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    _stats!.monthLabel,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                ),
              PopupMenuButton<AppLanguage>(
                tooltip: AppStrings.t(lang, 'home.language'),
                initialValue: lang,
                onSelected: _locale.setLanguage,
                itemBuilder: (context) => [
                  for (final value in AppLanguage.values)
                    PopupMenuItem(
                      value: value,
                      child: Text(AppStrings.t(lang, 'lang.${value.name}')),
                    ),
                ],
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.language),
                ),
              ),
              IconButton(
                tooltip: AppStrings.t(lang, 'home.refresh'),
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
          Expanded(
            child: AsyncStateView(
              loading: _loading && _stats == null,
              error: _error,
              onRetry: _loadStats,
              child: _stats == null
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isAllZero(_stats!))
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    color: Colors.amber.shade700,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      AppStrings.t(lang, 'home.emptyHint'),
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (_isAllZero(_stats!)) const SizedBox(height: 16),
                        _StatsCards(stats: _stats!, language: lang),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCards extends StatelessWidget {
  const _StatsCards({required this.stats, required this.language});

  final MonthStats stats;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final cards = [
      StatsCard(
        title: AppStrings.t(language, 'home.income'),
        amount: stats.income,
        icon: Icons.arrow_downward,
        color: Colors.green.shade600,
      ),
      StatsCard(
        title: AppStrings.t(language, 'home.expense'),
        amount: stats.expense,
        icon: Icons.arrow_upward,
        color: Colors.orange.shade700,
      ),
      StatsCard(
        title: AppStrings.t(language, 'home.balance'),
        amount: stats.balance,
        icon: Icons.account_balance_wallet_outlined,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
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
    );
  }
}
