import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/core/feedback/app_messenger.dart';
import 'package:ledger/core/l10n/app_strings.dart';
import 'package:ledger/core/widgets/async_state_view.dart';
import 'package:ledger/core/widgets/page_header.dart';
import 'package:ledger/features/member/data/member_api.dart';
import 'package:ledger/features/member/data/models/member_item.dart';
import 'package:ledger/features/stats/data/models/chart_stats.dart';
import 'package:ledger/features/stats/data/stats_api.dart';

/// 统计页：分类饼图、收支折线、成员柱状 + 家庭成员管理。
class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final StatsApi _statsApi = AppServices.instance.statsApi;
  final MemberApi _memberApi = AppServices.instance.memberApi;

  bool _loading = true;
  String? _error;
  List<CategoryShareItem> _share = [];
  List<TrendPoint> _trend = [];
  List<MemberStatItem> _byMember = [];
  List<MemberItem> _members = [];

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final share = await _statsApi.getCategoryShare();
    final trend = await _statsApi.getTrend(months: 6);
    final byMember = await _statsApi.getByMember();
    final members = await _memberApi.list();

    if (!mounted) return;

    if (!share.isSuccess ||
        !trend.isSuccess ||
        !byMember.isSuccess ||
        !members.isSuccess) {
      setState(() {
        _loading = false;
        _error = share.message.isNotEmpty
            ? share.message
            : (trend.message.isNotEmpty
                ? trend.message
                : (byMember.message.isNotEmpty
                    ? byMember.message
                    : members.message));
      });
      return;
    }

    setState(() {
      _loading = false;
      _share = share.data ?? [];
      _trend = trend.data ?? [];
      _byMember = byMember.data ?? [];
      _members = members.data ?? [];
    });
  }

  Future<void> _addMember() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.t(AppServices.instance.locale.language, 'stats.addMember')),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppStrings.t(AppServices.instance.locale.language, 'stats.memberName'),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.t(AppServices.instance.locale.language, 'common.cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(AppStrings.t(AppServices.instance.locale.language, 'common.ok')),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;

    final result = await _memberApi.create(name: name);
    if (!mounted) return;
    if (result.isSuccess) {
      AppMessenger.showSuccess(
        AppStrings.t(AppServices.instance.locale.language, 'stats.memberAdded'),
      );
      await _reload();
    } else {
      AppMessenger.showError(result.message);
    }
  }

  Future<void> _deleteMember(MemberItem member) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.t(AppServices.instance.locale.language, 'stats.deleteMember')),
        content: Text(member.name),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppStrings.t(AppServices.instance.locale.language, 'common.cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppStrings.t(AppServices.instance.locale.language, 'common.delete')),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final result = await _memberApi.delete(id: member.id);
    if (!mounted) return;
    if (result.isSuccess) {
      await _reload();
    } else {
      AppMessenger.showError(result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppServices.instance.locale.language;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: AppStrings.t(lang, 'stats.title'),
            actions: [
              FilledButton.icon(
                onPressed: _addMember,
                icon: const Icon(Icons.person_add_alt_1),
                label: Text(AppStrings.t(lang, 'stats.addMember')),
              ),
              IconButton(
                tooltip: AppStrings.t(lang, 'home.refresh'),
                onPressed: _loading ? null : _reload,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: AsyncStateView(
              loading: _loading,
              error: _error,
              onRetry: _reload,
              child: ListView(
                children: [
                  _SectionTitle(AppStrings.t(lang, 'stats.members')),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final m in _members)
                        InputChip(
                          label: Text(m.name),
                          onDeleted: () => _deleteMember(m),
                        ),
                      if (_members.isEmpty)
                        Text(
                          AppStrings.t(lang, 'stats.noMembers'),
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(AppStrings.t(lang, 'stats.pie')),
                  SizedBox(
                    height: 240,
                    child: _share.isEmpty
                        ? Center(child: Text(AppStrings.t(lang, 'stats.empty')))
                        : PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 36,
                              sections: [
                                for (var i = 0; i < _share.length; i++)
                                  PieChartSectionData(
                                    value: _share[i].ratio <= 0 ? 0.01 : _share[i].ratio,
                                    title:
                                        '${_share[i].categoryName}\n${(_share[i].ratio * 100).toStringAsFixed(0)}%',
                                    radius: 70,
                                    titleStyle: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    color: Colors.primaries[i % Colors.primaries.length],
                                  ),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(AppStrings.t(lang, 'stats.line')),
                  SizedBox(
                    height: 220,
                    child: _trend.isEmpty
                        ? Center(child: Text(AppStrings.t(lang, 'stats.empty')))
                        : LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: true),
                              titlesData: FlTitlesData(
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final i = value.toInt();
                                      if (i < 0 || i >= _trend.length) {
                                        return const SizedBox.shrink();
                                      }
                                      return Text(
                                        _trend[i].label,
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: [
                                    for (var i = 0; i < _trend.length; i++)
                                      FlSpot(
                                        i.toDouble(),
                                        double.tryParse(_trend[i].income) ?? 0,
                                      ),
                                  ],
                                  color: Colors.green,
                                  barWidth: 3,
                                  dotData: const FlDotData(show: true),
                                ),
                                LineChartBarData(
                                  spots: [
                                    for (var i = 0; i < _trend.length; i++)
                                      FlSpot(
                                        i.toDouble(),
                                        double.tryParse(_trend[i].expense) ?? 0,
                                      ),
                                  ],
                                  color: Colors.orange,
                                  barWidth: 3,
                                  dotData: const FlDotData(show: true),
                                ),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${AppStrings.t(lang, 'home.income')}=绿 / ${AppStrings.t(lang, 'home.expense')}=橙',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(AppStrings.t(lang, 'stats.bar')),
                  SizedBox(
                    height: 220,
                    child: _byMember.isEmpty
                        ? Center(child: Text(AppStrings.t(lang, 'stats.empty')))
                        : BarChart(
                            BarChartData(
                              barGroups: [
                                for (var i = 0; i < _byMember.length; i++)
                                  BarChartGroupData(
                                    x: i,
                                    barRods: [
                                      BarChartRodData(
                                        toY: double.tryParse(_byMember[i].expense) ?? 0,
                                        color: Colors.orange.shade700,
                                        width: 16,
                                      ),
                                    ],
                                  ),
                              ],
                              titlesData: FlTitlesData(
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final i = value.toInt();
                                      if (i < 0 || i >= _byMember.length) {
                                        return const SizedBox.shrink();
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          _byMember[i].memberName,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      );
                                    },
                                  ),
                                ),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
