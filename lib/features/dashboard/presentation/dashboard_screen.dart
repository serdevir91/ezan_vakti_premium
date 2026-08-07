import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ezan_vakti_premium/l10n/app_localizations.dart';
import '../../../core/cubits/prayer_cubit.dart';
import '../../../core/services/goal_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../settings/presentation/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int tabIndex) onNavigateTab;

  const DashboardScreen({
    super.key,
    required this.onNavigateTab,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GoalService _goalService = GoalService();
  MonthlyGoals _goals = MonthlyGoals(
    monthlyZikrTarget: 10000,
    monthlyQuranPagesTarget: 100,
    monthlyFastingDaysTarget: 4,
    enabledTasks: GoalService.defaultPrayers,
  );

  int _todayZikrCount = 0;
  int _todayQuranVerseCount = 0;
  int _todayPrayersCompleted = 0;

  int _monthlyZikrTotal = 0;
  int _monthlyQuranVersesTotal = 0;
  int _monthlyFastingTotal = 0;

  Map<String, bool> _todayPrayerTasks = {
    'fajr': false,
    'dhuhr': false,
    'asr': false,
    'maghrib': false,
    'isha': false,
  };

  @override
  void initState() {
    super.initState();
    _loadDailyStats();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadDailyStats();
  }

  Future<void> _loadDailyStats() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final dk = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final zikr = prefs.getInt('zikr_$dk') ?? 0;
    final quran = prefs.getInt('quran_$dk') ?? 0;

    final rawTasks = prefs.getString('tasks_$dk');
    Map<String, bool> pTasks = {
      'fajr': false,
      'dhuhr': false,
      'asr': false,
      'maghrib': false,
      'isha': false,
    };
    if (rawTasks != null) {
      final Map<String, dynamic> decoded = jsonDecode(rawTasks);
      pTasks = decoded.map((k, v) => MapEntry(k, v as bool));
    }

    final pCompleted = pTasks.values.where((v) => v).length;

    // Load monthly goal settings & monthly totals
    final g = await _goalService.loadGoals();
    final daysInMonth = DateTime(today.year, today.month + 1, 0).day;
    int zikrSum = 0;
    int quranSum = 0;
    int fastSum = 0;

    for (int d = 1; d <= daysInMonth; d++) {
      final dayKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';
      zikrSum += prefs.getInt('zikr_$dayKey') ?? 0;
      quranSum += prefs.getInt('quran_$dayKey') ?? 0;
      if (prefs.getBool('fast_$dayKey') == true) fastSum++;
    }

    if (mounted) {
      setState(() {
        _todayZikrCount = zikr;
        _todayQuranVerseCount = quran;
        _todayPrayerTasks = pTasks;
        _todayPrayersCompleted = pCompleted;
        _goals = g;
        _monthlyZikrTotal = zikrSum;
        _monthlyQuranVersesTotal = quranSum;
        _monthlyFastingTotal = fastSum;
      });
    }
  }

  Future<void> _togglePrayerTask(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final dk = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    setState(() {
      _todayPrayerTasks[key] = !(_todayPrayerTasks[key] ?? false);
      _todayPrayersCompleted = _todayPrayerTasks.values.where((v) => v).length;
    });

    await prefs.setString('tasks_$dk', jsonEncode(_todayPrayerTasks));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadDailyStats,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Header with Settings Button at top right
            SliverAppBar(
              expandedHeight: 70,
              floating: true,
              pinned: true,
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.goldPrimary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mosque_rounded, color: AppColors.goldPrimary, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l10n.appTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: AppColors.goldPrimary),
                  tooltip: l10n.settings,
                  onPressed: () {
                    _showSettingsModalPanel(context);
                  },
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Next Prayer Countdown Hero Card
                    _buildCountdownCard(context, l10n),

                    const SizedBox(height: 20),

                    // 2. Daily Prayers Ring & Quick Checklist
                    Text(
                      l10n.dailyPrayerRing,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.goldAccent : AppColors.emeraldPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildPrayerTrackerRingCard(context, l10n),

                    const SizedBox(height: 20),

                    // 3. Monthly Worship Progress Card (ADDED TO HOME AS REQUESTED)
                    Text(
                      l10n.monthlyProgress,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.goldAccent : AppColors.emeraldPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildMonthlyProgressCard(context, l10n),

                    const SizedBox(height: 20),

                    // 4. Daily Zikr & Quran Progress Cards
                    Text(
                      l10n.todaySummary,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.goldAccent : AppColors.emeraldPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await widget.onNavigateTab(2); // Tasbih
                              _loadDailyStats();
                            },
                            child: Card(
                              color: isDark ? AppColors.darkSurface : Colors.amber.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  children: [
                                    const Icon(Icons.fingerprint, color: AppColors.goldPrimary, size: 28),
                                    const SizedBox(height: 6),
                                    Text(l10n.todayZikr, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                    const SizedBox(height: 4),
                                    Text(
                                      "$_todayZikrCount",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.goldPrimary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await widget.onNavigateTab(1); // Quran
                              _loadDailyStats();
                            },
                            child: Card(
                              color: isDark ? AppColors.darkSurface : Colors.blue.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  children: [
                                    const Icon(Icons.menu_book, color: AppColors.info, size: 28),
                                    const SizedBox(height: 6),
                                    Text(l10n.todayQuran, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                    const SizedBox(height: 4),
                                    Text(
                                      "$_todayQuranVerseCount",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.info),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 5. Main Dashboard Feature Grid Widgets (Qibla, Calendar, Cards, Tasbih)
                    Text(
                      l10n.quickAccess,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.goldAccent : AppColors.emeraldPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.4,
                      children: [
                        _buildFeatureTile(
                          context,
                          title: l10n.qibla,
                          subtitle: l10n.liveCompass,
                          icon: Icons.explore,
                          color: AppColors.goldPrimary,
                          onTap: () => widget.onNavigateTab(4), // Qibla Screen
                        ),
                        _buildFeatureTile(
                          context,
                          title: l10n.calendar,
                          subtitle: l10n.gregorianHijri,
                          icon: Icons.calendar_month,
                          color: AppColors.emeraldAccent,
                          onTap: () async {
                            await widget.onNavigateTab(3); // Calendar Screen
                            _loadDailyStats();
                          },
                        ),
                        _buildFeatureTile(
                          context,
                          title: l10n.tasbih,
                          subtitle: l10n.digitalTasbih,
                          icon: Icons.fingerprint,
                          color: AppColors.info,
                          onTap: () async {
                            await widget.onNavigateTab(2); // Tasbih Screen
                            _loadDailyStats();
                          },
                        ),
                        _buildFeatureTile(
                          context,
                          title: l10n.cards,
                          subtitle: l10n.fridayCard,
                          icon: Icons.style,
                          color: AppColors.warning,
                          onTap: () => widget.onNavigateTab(5), // Card Creator Screen
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 6. Weekly Quran Reading Chart
                    Text(
                      l10n.quranReadingGoal,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.goldAccent : AppColors.emeraldPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildQuranProgressChart(context, l10n),

                    const SizedBox(height: 20),

                    // 7. Daily Content Card
                    _buildDailyVerseCard(context, l10n),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyProgressCard(BuildContext context, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark ? AppColors.darkSurface : AppColors.emeraldPrimary.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildGoalMetric(l10n.tasbih, _monthlyZikrTotal, _goals.monthlyZikrTarget, AppColors.goldPrimary),
                _buildGoalMetric(l10n.quran, _monthlyQuranVersesTotal, _goals.monthlyQuranPagesTarget, AppColors.info),
                _buildGoalMetric(l10n.fastingStatus, _monthlyFastingTotal, _goals.monthlyFastingDaysTarget, AppColors.warning),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalMetric(String title, int current, int target, Color color) {
    double progress = (target > 0) ? (current / target).clamp(0.0, 1.0) : 0.0;
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          "$current / $target",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 80,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 5,
          ),
        ),
      ],
    );
  }

  void _showSettingsModalPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Expanded(child: SettingsScreen()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCountdownCard(BuildContext context, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<PrayerCubit, PrayerState>(
      builder: (context, state) {
        if (state is PrayerLoaded) {
          final next = state.schedule.nextPrayer;
          final duration = state.timeRemaining;

          String hours = duration.inHours.toString().padLeft(2, '0');
          String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
          String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

          String prayerTitle = _getPrayerName(l10n, next.nameKey);

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.emeraldDark, AppColors.darkSurface]
                    : [AppColors.emeraldPrimary, AppColors.emeraldAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.emeraldPrimary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColors.goldAccent, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          state.schedule.locationName,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.goldPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        l10n.streakDays(7),
                        style: const TextStyle(
                          color: AppColors.goldAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  "${l10n.nextPrayer}: $prayerTitle",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "$hours:$minutes:$seconds",
                  style: const TextStyle(
                    color: AppColors.goldAccent,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: state.schedule.allPrayers.map((p) {
                    final pName = _getPrayerName(l10n, p.nameKey);
                    final isNext = p.isNext;

                    return Column(
                      children: [
                        Text(
                          pName,
                          style: TextStyle(
                            color: isNext ? AppColors.goldAccent : Colors.white60,
                            fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${p.time.hour.toString().padLeft(2, '0')}:${p.time.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            color: isNext ? Colors.white : Colors.white70,
                            fontSize: 11,
                            fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0);
        }

        return const SizedBox(
          height: 180,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildPrayerTrackerRingCard(BuildContext context, AppLocalizations l10n) {
    double progress = _todayPrayersCompleted / 5.0;

    final prayerNamesMap = {
      'fajr': l10n.fajr,
      'dhuhr': l10n.dhuhr,
      'asr': l10n.asr,
      'maghrib': l10n.maghrib,
      'isha': l10n.isha,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 76,
                  height: 76,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 9,
                        backgroundColor: AppColors.emeraldPrimary.withValues(alpha: 0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.emeraldAccent),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$_todayPrayersCompleted/5",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(Icons.check_circle_outline, color: AppColors.emeraldAccent, size: 14),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.prayersCompleted(_todayPrayersCompleted),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _todayPrayersCompleted == 5
                            ? l10n.congratsAllPrayers
                            : l10n.markPrayersHint,
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            // Scrollable Prayer Toggle Chips - NO OVERFLOW
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: prayerNamesMap.entries.map((e) {
                  final isDone = _todayPrayerTasks[e.key] ?? false;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: FilterChip(
                      label: Text(e.value, style: TextStyle(fontSize: 11, color: isDone ? Colors.white : null)),
                      selected: isDone,
                      selectedColor: AppColors.emeraldAccent,
                      checkmarkColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                      onSelected: (selected) {
                        _togglePrayerTask(e.key);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuranProgressChart(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.weeklyQuran,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const Icon(Icons.menu_book, color: AppColors.goldPrimary, size: 18),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 110,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 30,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
                          if (value.toInt() >= 0 && value.toInt() < days.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                days[value.toInt()],
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 7, color: AppColors.emeraldAccent, width: 10, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 15, color: AppColors.emeraldAccent, width: 10, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 10, color: AppColors.emeraldAccent, width: 10, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 20, color: AppColors.emeraldAccent, width: 10, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 25, color: AppColors.goldPrimary, width: 10, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 12, color: AppColors.emeraldAccent, width: 10, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: _todayQuranVerseCount > 0 ? _todayQuranVerseCount.toDouble() : 14, color: AppColors.emeraldAccent, width: 10, borderRadius: BorderRadius.circular(4))]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyVerseCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.format_quote, color: AppColors.goldPrimary),
                const SizedBox(width: 8),
                Text(
                  l10n.dailyVerse,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "الَّذِينَ آمَنُوا وَتَطْمَئِنُّ قُلُوبُهُم بِذِكْرِ اللَّهِ ۗ أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.6,
                fontFamily: 'Arabic',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "“Onlar, iman edenler ve kalpleri Allah'ı anmakla huzura kavuşanlardır. Biliniz ki kalpler ancak Allah'ı anmakla huzur bulur.” (Râd Suresi, 28. Ayet)",
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  String _getPrayerName(AppLocalizations l10n, String key) {
    switch (key) {
      case 'fajr':
        return l10n.fajr;
      case 'sunrise':
        return l10n.sunrise;
      case 'dhuhr':
        return l10n.dhuhr;
      case 'asr':
        return l10n.asr;
      case 'maghrib':
        return l10n.maghrib;
      case 'isha':
        return l10n.isha;
      default:
        return key;
    }
  }
}
