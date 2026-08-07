import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:ezan_vakti_premium/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/goal_service.dart';
import '../../../core/theme/app_colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool _isHijri = false;
  late DateTime _selectedDate;
  late DateTime _displayMonth;
  late HijriCalendar _hijriDate;
  final GoalService _goalService = GoalService();
  MonthlyGoals _goals = MonthlyGoals(
    monthlyZikrTarget: 10000,
    monthlyQuranPagesTarget: 100,
    monthlyFastingDaysTarget: 4,
    enabledTasks: GoalService.defaultPrayers,
  );

  // Cached completion data for displayed month
  final Map<String, Map<String, bool>> _monthTaskData = {};
  int _monthlyZikrTotal = 0;
  int _monthlyQuranVersesTotal = 0;
  int _monthlyFastingTotal = 0;

  static const List<String> prayerKeys = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];

  List<Map<String, String>> _getHolyDays(AppLocalizations l10n) => [
    {"name": l10n.ramadanStart, "date": "1 Ramazan 1448", "gregorian": "8 Şubat 2027"},
    {"name": l10n.laylatAlQadr, "date": "27 Ramazan 1448", "gregorian": "6 Mart 2027"},
    {"name": l10n.eidAlFitr, "date": "1 Şevval 1448", "gregorian": "10 Mart 2027"},
    {"name": l10n.eidAlAdha, "date": "10 Zilhicce 1448", "gregorian": "17 Mayıs 2027"},
    {"name": l10n.hijriNewYear, "date": "1 Muharrem 1449", "gregorian": "6 Haziran 2027"},
    {"name": l10n.dayOfAshura, "date": "10 Muharrem 1449", "gregorian": "15 Haziran 2027"},
    {"name": l10n.mawlid, "date": "12 Rebiülevvel 1449", "gregorian": "16 Ağustos 2027"},
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _displayMonth = DateTime(_selectedDate.year, _selectedDate.month);
    _hijriDate = HijriCalendar.fromDate(_selectedDate);
    _loadGoals();
    _loadMonthData();
  }

  void _loadGoals() async {
    final g = await _goalService.loadGoals();
    setState(() {
      _goals = g;
    });
  }

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<Map<String, bool>> _loadDayTasks(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'tasks_${_dateKey(date)}';
    final raw = prefs.getString(key);
    if (raw != null) {
      final Map<String, dynamic> decoded = jsonDecode(raw);
      return decoded.map((k, v) => MapEntry(k, v as bool));
    }
    return {for (var p in prayerKeys) p: false};
  }

  Future<void> _saveDayTasks(DateTime date, Map<String, bool> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'tasks_${_dateKey(date)}';
    await prefs.setString(key, jsonEncode(tasks));
  }

  Future<int> _loadDayZikr(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('zikr_${_dateKey(date)}') ?? 0;
  }

  Future<void> _saveDayZikr(DateTime date, int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('zikr_${_dateKey(date)}', count);
  }

  Future<int> _loadDayQuranVerses(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('quran_${_dateKey(date)}') ?? 0;
  }

  Future<void> _saveDayQuranVerses(DateTime date, int verses) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('quran_${_dateKey(date)}', verses);
  }

  Future<bool> _loadDayFasting(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('fast_${_dateKey(date)}') ?? false;
  }

  Future<void> _saveDayFasting(DateTime date, bool fasted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('fast_${_dateKey(date)}', fasted);
  }

  Future<void> _loadMonthData() async {
    final year = _displayMonth.year;
    final month = _displayMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final prefs = await SharedPreferences.getInstance();

    final Map<String, Map<String, bool>> data = {};
    int zikrSum = 0;
    int quranSum = 0;
    int fastSum = 0;

    for (int d = 1; d <= daysInMonth; d++) {
      final date = DateTime(year, month, d);
      final dk = _dateKey(date);
      data[dk] = await _loadDayTasks(date);

      zikrSum += prefs.getInt('zikr_$dk') ?? 0;
      quranSum += prefs.getInt('quran_$dk') ?? 0;
      if (prefs.getBool('fast_$dk') == true) fastSum++;
    }

    if (mounted) {
      setState(() {
        _monthTaskData.clear();
        _monthTaskData.addAll(data);
        _monthlyZikrTotal = zikrSum;
        _monthlyQuranVersesTotal = quranSum;
        _monthlyFastingTotal = fastSum;
      });
    }
  }

  int _completedPrayersForDay(String dateKey) {
    final tasks = _monthTaskData[dateKey];
    if (tasks == null) return 0;
    return tasks.values.where((v) => v).length;
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + delta);
    });
    _loadMonthData();
  }

  String _prayerDisplayName(AppLocalizations l10n, String key) {
    switch (key) {
      case 'fajr': return l10n.fajr;
      case 'dhuhr': return l10n.dhuhr;
      case 'asr': return l10n.asr;
      case 'maghrib': return l10n.maghrib;
      case 'isha': return l10n.isha;
      default: return key;
    }
  }

  IconData _prayerIcon(String key) {
    switch (key) {
      case 'fajr': return Icons.wb_twilight;
      case 'dhuhr': return Icons.wb_sunny;
      case 'asr': return Icons.sunny_snowing;
      case 'maghrib': return Icons.nightlight_round;
      case 'isha': return Icons.nights_stay;
      default: return Icons.access_time;
    }
  }

  // Check if current month is a special holy month in Hijri calendar
  String? _getHolyMonthBadgeText(AppLocalizations l10n, HijriCalendar hijri) {
    final hMonth = hijri.hMonth;
    if (hMonth == 9) {
      return l10n.ramadanMonth;
    } else if (hMonth == 7 || hMonth == 8) {
      return l10n.threeMonths;
    } else if (hMonth == 1 || hMonth == 12) {
      return l10n.holyMonthBadge;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final todayFloor = DateTime(now.year, now.month, now.day);
    final year = _displayMonth.year;
    final month = _displayMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday; // 1=Monday

    final currentHijriMonth = HijriCalendar.fromDate(DateTime(year, month, 15));
    final holyMonthText = _getHolyMonthBadgeText(l10n, currentHijriMonth);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.calendar),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.emeraldPrimary,
        icon: const Icon(Icons.edit_calendar, color: Colors.white),
        label: Text(l10n.todayPrayers, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => _showDayDetailModal(context, todayFloor, l10n),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 90.0),
        child: Column(
          children: [
            // Calendar Mode Toggle
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isHijri ? l10n.hijriCalendar : l10n.gregorianCalendar,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Switch.adaptive(
                      value: _isHijri,
                      activeTrackColor: AppColors.goldPrimary,
                      onChanged: (val) {
                        setState(() {
                          _isHijri = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Holy Month Badge Banner if applicable
            if (holyMonthText != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.goldPrimary, AppColors.goldAccent],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldPrimary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      holyMonthText,
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Monthly Goals Progress Card
            Card(
              color: isDark ? AppColors.darkSurface : AppColors.emeraldPrimary.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.monthlyProgress,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () => _showMonthlyGoalsDialog(context, l10n),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.goldPrimary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.tune, size: 14, color: AppColors.goldPrimary),
                                const SizedBox(width: 4),
                                Text(
                                  l10n.editGoals,
                                  style: const TextStyle(color: AppColors.goldPrimary, fontWeight: FontWeight.bold, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildGoalProgressMetric(l10n.tasbih, _monthlyZikrTotal, _goals.monthlyZikrTarget, AppColors.goldPrimary),
                        _buildGoalProgressMetric(l10n.quran, _monthlyQuranVersesTotal, _goals.monthlyQuranPagesTarget, AppColors.info),
                        _buildGoalProgressMetric(l10n.fastingStatus, _monthlyFastingTotal, _goals.monthlyFastingDaysTarget, AppColors.warning),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Date Hero Display Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppColors.darkSurface, AppColors.amoledSurface]
                      : [AppColors.emeraldPrimary, AppColors.emeraldAccent],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    _isHijri
                        ? "${_hijriDate.hDay} ${_hijriDate.longMonthName} ${_hijriDate.hYear}"
                        : "${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}",
                    style: const TextStyle(
                      color: AppColors.goldAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isHijri
                        ? "Miladi: ${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}"
                        : "Hicri: ${_hijriDate.hDay} ${_hijriDate.longMonthName} ${_hijriDate.hYear}",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Month Navigation + Calendar Grid
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Month navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () => _changeMonth(-1),
                        ),
                        Text(
                          '${_getMonthName(month)} $year',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () => _changeMonth(1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text("Pzt", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("Sal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("Çar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("Per", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("Cum", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.emeraldAccent, fontSize: 12)),
                        Text("Cmt", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("Paz", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const Divider(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: daysInMonth + firstWeekday - 1,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                      ),
                      itemBuilder: (context, index) {
                        if (index < firstWeekday - 1) {
                          return const SizedBox(); // Empty cell for offset
                        }
                        int day = index - firstWeekday + 2;
                        final date = DateTime(year, month, day);
                        final dateFloor = DateTime(date.year, date.month, date.day);
                        final dateKey = _dateKey(date);
                        bool isToday = day == now.day && month == now.month && year == now.year;
                        bool isFuture = dateFloor.isAfter(todayFloor);
                        bool isSelected = day == _selectedDate.day && month == _selectedDate.month && year == _selectedDate.year;

                        int completed = _completedPrayersForDay(dateKey);
                        bool allDone = completed == 5 && !isFuture;
                        bool partial = completed > 0 && completed < 5 && !isFuture;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDate = date;
                              _hijriDate = HijriCalendar.fromDate(date);
                            });
                            _showDayDetailModal(context, date, l10n);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isToday
                                  ? AppColors.emeraldPrimary
                                  : isSelected
                                      ? AppColors.goldPrimary.withValues(alpha: 0.3)
                                      : isFuture
                                          ? Colors.grey.withValues(alpha: 0.08)
                                          : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isToday
                                    ? AppColors.goldAccent
                                    : allDone
                                        ? AppColors.emeraldAccent
                                        : Colors.transparent,
                                width: isToday ? 2 : 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "$day",
                                  style: TextStyle(
                                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                    color: isToday
                                        ? Colors.white
                                        : isFuture
                                            ? Colors.grey
                                            : null,
                                    fontSize: 13,
                                  ),
                                ),
                                if (allDone)
                                  const Icon(Icons.check_circle, color: AppColors.emeraldAccent, size: 12)
                                else if (partial)
                                  Icon(Icons.radio_button_checked, color: Colors.orange.shade400, size: 10),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Holy Days List
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.holyDays,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _getHolyDays(l10n).length,
              itemBuilder: (context, index) {
                final holy = _getHolyDays(l10n)[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.stars, color: AppColors.goldPrimary),
                    title: Text(holy["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${holy["date"]} (${holy["gregorian"]})"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalProgressMetric(String title, int current, int target, Color color) {
    double progress = (target > 0) ? (current / target).clamp(0.0, 1.0) : 0.0;
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          "$current / $target",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 75,
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

  void _showMonthlyGoalsDialog(BuildContext context, AppLocalizations l10n) {
    final zikrCtrl = TextEditingController(text: "${_goals.monthlyZikrTarget}");
    final quranCtrl = TextEditingController(text: "${_goals.monthlyQuranPagesTarget}");
    final fastCtrl = TextEditingController(text: "${_goals.monthlyFastingDaysTarget}");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.tune, color: AppColors.goldPrimary),
            const SizedBox(width: 10),
            Text(l10n.monthlyGoals, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: zikrCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.monthlyZikrGoal,
                prefixIcon: const Icon(Icons.fingerprint, color: AppColors.goldPrimary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: quranCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.monthlyQuranGoal,
                prefixIcon: const Icon(Icons.menu_book, color: AppColors.info),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: fastCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.monthlyFastingGoal,
                prefixIcon: const Icon(Icons.wb_sunny_outlined, color: AppColors.warning),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emeraldPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              int z = int.tryParse(zikrCtrl.text) ?? 10000;
              int q = int.tryParse(quranCtrl.text) ?? 100;
              int f = int.tryParse(fastCtrl.text) ?? 4;

              final updated = _goals.copyWith(
                monthlyZikrTarget: z,
                monthlyQuranPagesTarget: q,
                monthlyFastingDaysTarget: f,
              );
              _goalService.saveGoals(updated);
              setState(() {
                _goals = updated;
              });
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showDayDetailModal(BuildContext context, DateTime date, AppLocalizations l10n) async {
    final now = DateTime.now();
    final todayFloor = DateTime(now.year, now.month, now.day);
    final dateFloor = DateTime(date.year, date.month, date.day);
    final bool isFuture = dateFloor.isAfter(todayFloor);

    final tasks = await _loadDayTasks(date);
    int zikr = await _loadDayZikr(date);
    int quranVerses = await _loadDayQuranVerses(date);
    bool fasted = await _loadDayFasting(date);
    final hijri = HijriCalendar.fromDate(date);

    final prefs = await SharedPreferences.getInstance();
    final rawZikrDetail = prefs.getString('zikr_detail_${_dateKey(date)}');
    Map<String, int> zikrBreakdown = {};
    if (rawZikrDetail != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(rawZikrDetail);
        decoded.forEach((k, v) => zikrBreakdown[k] = (v as num).toInt());
      } catch (_) {}
    }

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            int completed = tasks.values.where((v) => v).length;

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${date.day} ${_getMonthName(date.month)} ${date.year}",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: completed == 5
                                ? AppColors.emeraldAccent.withValues(alpha: 0.2)
                                : AppColors.goldPrimary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "$completed/5",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: completed == 5 ? AppColors.emeraldAccent : AppColors.goldPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Hicri: ${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear}",
                      style: const TextStyle(color: AppColors.goldPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                    ),

                    if (isFuture) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade900.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber.shade700),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.amber),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                l10n.futureDaysWarning,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Prayer checkboxes
                    Text(l10n.fivePrayerTracker, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 8),
                    ...prayerKeys.map((key) {
                      return CheckboxListTile(
                        value: tasks[key] ?? false,
                        enabled: !isFuture,
                        activeColor: AppColors.emeraldAccent,
                        secondary: Icon(_prayerIcon(key), color: AppColors.goldPrimary),
                        title: Text(_prayerDisplayName(l10n, key)),
                        dense: true,
                        onChanged: isFuture
                            ? null
                            : (val) {
                                setModalState(() {
                                  tasks[key] = val ?? false;
                                });
                                _saveDayTasks(date, tasks);
                                _monthTaskData[_dateKey(date)] = Map.from(tasks);
                                _loadMonthData();
                              },
                      );
                    }),

                    const Divider(height: 24),

                    // Zikr counter & breakdown
                    ListTile(
                      leading: const Icon(Icons.fingerprint, color: AppColors.goldPrimary),
                      title: Text(l10n.zikrCountLabel),
                      contentPadding: EdgeInsets.zero,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: isFuture
                                ? null
                                : () {
                                    if (zikr > 0) {
                                      setModalState(() => zikr -= 33);
                                      if (zikr < 0) zikr = 0;
                                      _saveDayZikr(date, zikr);
                                      _loadMonthData();
                                    }
                                  },
                          ),
                          Text("$zikr", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: AppColors.emeraldPrimary),
                            onPressed: isFuture
                                ? null
                                : () {
                                    setModalState(() => zikr += 33);
                                    _saveDayZikr(date, zikr);
                                    _loadMonthData();
                                  },
                          ),
                        ],
                      ),
                    ),

                    if (zikrBreakdown.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: zikrBreakdown.entries.map((e) {
                          if (e.value <= 0) return const SizedBox();
                          return Chip(
                            visualDensity: VisualDensity.compact,
                            backgroundColor: AppColors.goldPrimary.withValues(alpha: 0.15),
                            label: Text("${_getZikrTitle(e.key)}: ${e.value}", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          );
                        }).toList(),
                      ),
                    ],

                    // Quran verses
                    ListTile(
                      leading: const Icon(Icons.menu_book, color: AppColors.info),
                      title: Text(l10n.quranVersesLabel),
                      contentPadding: EdgeInsets.zero,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: isFuture
                                ? null
                                : () {
                                    if (quranVerses > 0) {
                                      setModalState(() => quranVerses--);
                                      _saveDayQuranVerses(date, quranVerses);
                                      _loadMonthData();
                                    }
                                  },
                          ),
                          Text("$quranVerses", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: AppColors.info),
                            onPressed: isFuture
                                ? null
                                : () {
                                    setModalState(() => quranVerses++);
                                    _saveDayQuranVerses(date, quranVerses);
                                    _loadMonthData();
                                  },
                          ),
                        ],
                      ),
                    ),

                    // Fasting toggle
                    SwitchListTile(
                      secondary: const Icon(Icons.wb_sunny_outlined, color: AppColors.warning),
                      title: Text(l10n.fastedLabel),
                      value: fasted,
                      activeTrackColor: AppColors.emeraldAccent,
                      contentPadding: EdgeInsets.zero,
                      onChanged: isFuture
                          ? null
                          : (val) {
                              setModalState(() => fasted = val);
                              _saveDayFasting(date, fasted);
                              _loadMonthData();
                            },
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getZikrTitle(String id) {
    switch (id) {
      case 'subhanallah': return 'Subhanallah';
      case 'alhamdulillah': return 'Elhamdulillah';
      case 'allahuakbar': return 'Allahu Akbar';
      case 'lailahaillallah': return 'La ilaha illallah';
      case 'astaghfirullah': return 'Estağfirullah';
      case 'salawat': return 'Salavat';
      default: return id;
    }
  }

  String _getMonthName(int month) {
    const months = ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'];
    return months[(month - 1) % 12];
  }
}
