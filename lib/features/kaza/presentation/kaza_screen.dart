import 'package:flutter/material.dart';
import 'package:ezan_vakti_premium/l10n/app_localizations.dart';
import '../../../core/services/kaza_service.dart';
import '../../../core/theme/app_colors.dart';

class KazaScreen extends StatefulWidget {
  const KazaScreen({super.key});

  @override
  State<KazaScreen> createState() => _KazaScreenState();
}

class _KazaScreenState extends State<KazaScreen> {
  final KazaService _service = KazaService();
  KazaCounts _counts = KazaCounts(fajr: 12, dhuhr: 25, asr: 18, maghrib: 8, isha: 30, witr: 14, fasts: 5);

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final c = await _service.loadKazaCounts();
    setState(() {
      _counts = c;
    });
  }

  void _update(KazaCounts updated) {
    setState(() {
      _counts = updated;
    });
    _service.saveKazaCounts(updated);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.kaza),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Stats Card
            Card(
              color: AppColors.emeraldPrimary,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text("Toplam Kaza Namazı", style: TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 6),
                        Text(
                          "${_counts.fajr + _counts.dhuhr + _counts.asr + _counts.maghrib + _counts.isha + _counts.witr}",
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.goldAccent),
                        ),
                      ],
                    ),
                    Container(height: 40, width: 1, color: Colors.white24),
                    Column(
                      children: [
                        const Text("Toplam Kaza Orucu", style: TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 6),
                        Text(
                          "${_counts.fasts}",
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.goldAccent),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              l10n.missedPrayers,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildKazaCounterTile("İmsak (Sabah)", _counts.fajr, (val) => _update(_counts.copyWith(fajr: val))),
            _buildKazaCounterTile("Öğle", _counts.dhuhr, (val) => _update(_counts.copyWith(dhuhr: val))),
            _buildKazaCounterTile("İkindi", _counts.asr, (val) => _update(_counts.copyWith(asr: val))),
            _buildKazaCounterTile("Akşam", _counts.maghrib, (val) => _update(_counts.copyWith(maghrib: val))),
            _buildKazaCounterTile("Yatsı", _counts.isha, (val) => _update(_counts.copyWith(isha: val))),
            _buildKazaCounterTile("Vitir", _counts.witr, (val) => _update(_counts.copyWith(witr: val))),

            const SizedBox(height: 20),

            Text(
              l10n.missedFasts,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildKazaCounterTile("Ramadan Orucu", _counts.fasts, (val) => _update(_counts.copyWith(fasts: val))),
          ],
        ),
      ),
    );
  }

  Widget _buildKazaCounterTile(String title, int count, ValueChanged<int> onChanged) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                  onPressed: () {
                    if (count > 0) onChanged(count - 1);
                  },
                ),
                Text(
                  "$count",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: AppColors.emeraldAccent),
                  onPressed: () {
                    onChanged(count + 1);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
