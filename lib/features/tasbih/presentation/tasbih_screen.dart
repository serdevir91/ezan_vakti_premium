import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ezan_vakti_premium/l10n/app_localizations.dart';
import '../../../core/services/tasbih_service.dart';
import '../../../core/theme/app_colors.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  final TasbihService _service = TasbihService();

  late List<ZikrModel> _zikrs;
  late ZikrModel _activeZikr;

  // Individual counts per zikr id for today
  final Map<String, int> _zikrCounts = {};
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  void initState() {
    super.initState();
    _zikrs = _service.getPresets();
    _activeZikr = _zikrs.first;
    for (var z in _zikrs) {
      _zikrCounts[z.id] = 0;
    }
    _loadVibrationSetting();
    _loadTodayZikrCounts();
  }

  Future<void> _loadVibrationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _vibrationEnabled = prefs.getBool('pref_vibration_enabled') ?? true;
      });
    }
  }

  Future<void> _loadTodayZikrCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final dk = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final rawDetails = prefs.getString('zikr_detail_$dk');

    if (rawDetails != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(rawDetails);
        if (mounted) {
          setState(() {
            decoded.forEach((key, val) {
              _zikrCounts[key] = (val as num).toInt();
            });
          });
        }
      } catch (_) {}
    }
  }

  Future<void> _saveTodayZikrCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final dk = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    // Save JSON details breakdown
    await prefs.setString('zikr_detail_$dk', jsonEncode(_zikrCounts));

    // Calculate & save total zikr count
    int total = _zikrCounts.values.fold(0, (sum, val) => sum + val);
    await prefs.setInt('zikr_$dk', total);
  }

  void _increment() async {
    final current = _zikrCounts[_activeZikr.id] ?? 0;
    final newCount = current + 1;

    setState(() {
      _zikrCounts[_activeZikr.id] = newCount;
    });

    _saveTodayZikrCounts();

    if (_vibrationEnabled) {
      Vibration.hasVibrator().then((hasVib) {
        if (hasVib == true && mounted) {
          Vibration.vibrate(duration: 40);
        }
      });
    }

    // Milestone Check (33, 99, 1000)
    if (newCount == _activeZikr.target) {
      if (_vibrationEnabled) {
        Vibration.vibrate(duration: 250);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${_activeZikr.titleTr} - ${AppLocalizations.of(context)!.targetReached} ($newCount)"),
            backgroundColor: AppColors.emeraldPrimary,
          ),
        );
      }
    }
  }

  void _resetActiveZikr() {
    setState(() {
      _zikrCounts[_activeZikr.id] = 0;
    });
    _saveTodayZikrCounts();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeCount = _zikrCounts[_activeZikr.id] ?? 0;
    final totalTodayCount = _zikrCounts.values.fold(0, (sum, val) => sum + val);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tasbih),
        actions: [
          IconButton(
            icon: Icon(_soundEnabled ? Icons.volume_up : Icons.volume_off),
            onPressed: () {
              setState(() {
                _soundEnabled = !_soundEnabled;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.reset,
            onPressed: _resetActiveZikr,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Zikr Selector Carousel
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _zikrs.length,
                itemBuilder: (context, index) {
                  final z = _zikrs[index];
                  bool isSelected = z.id == _activeZikr.id;
                  int zCount = _zikrCounts[z.id] ?? 0;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeZikr = z;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.emeraldPrimary
                            : isDark
                                ? AppColors.darkSurface
                                : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.goldAccent : Colors.grey.withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            z.titleTr,
                            style: TextStyle(
                              color: isSelected ? Colors.white : null,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                          if (zCount > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.goldPrimary : AppColors.emeraldPrimary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "$zCount",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.black : AppColors.emeraldPrimary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Active Zikr Title & Arab text
            Text(
              _activeZikr.titleAr,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arabic',
                color: AppColors.goldPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _activeZikr.titleTr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),

            const Spacer(),

            // Huge Digital Zikirmatik Counter Button
            GestureDetector(
              onTap: _increment,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isDark
                        ? [AppColors.darkSurface, AppColors.amoledSurface]
                        : [AppColors.emeraldPrimary, AppColors.emeraldDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.emeraldPrimary.withValues(alpha: 0.4),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.goldPrimary,
                    width: 4,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$activeCount",
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldAccent,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      "${l10n.target}: ${_activeZikr.target}",
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Detailed Zikr Breakdown Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.todayZikrStats, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text(
                          "${l10n.total}: $totalTodayCount",
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.goldPrimary, fontSize: 13),
                        ),
                      ],
                    ),
                    const Divider(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _zikrs.map((z) {
                        final cnt = _zikrCounts[z.id] ?? 0;
                        if (cnt == 0) return const SizedBox();
                        return Chip(
                          visualDensity: VisualDensity.compact,
                          backgroundColor: AppColors.emeraldPrimary.withValues(alpha: 0.1),
                          avatar: const Icon(Icons.check_circle, size: 14, color: AppColors.emeraldAccent),
                          label: Text("${z.titleTr}: $cnt", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Bottom Target Bar
            LinearProgressIndicator(
              value: (activeCount / _activeZikr.target).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.emeraldPrimary.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.goldPrimary),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
