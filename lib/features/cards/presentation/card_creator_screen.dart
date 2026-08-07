import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/services/quran_repository.dart';
import '../../../core/theme/app_colors.dart';

class CardCreatorScreen extends StatefulWidget {
  final String? initialArabic;
  final String? initialTurkish;

  const CardCreatorScreen({
    super.key,
    this.initialArabic,
    this.initialTurkish,
  });

  @override
  State<CardCreatorScreen> createState() => _CardCreatorScreenState();
}

class _CardCreatorScreenState extends State<CardCreatorScreen> {
  int _selectedBgIndex = 0;
  final List<Color> _bgGradients = [
    AppColors.emeraldPrimary,
    AppColors.darkSurface,
    AppColors.goldPrimary,
    const Color(0xFF1E3A8A),
    const Color(0xFF581C87),
    const Color(0xFF991B1B),
  ];

  late TextEditingController _arabicController;
  late TextEditingController _turkishController;
  final QuranRepository _repository = QuranRepository();

  @override
  void initState() {
    super.initState();
    _arabicController = TextEditingController(
      text: widget.initialArabic ?? "إِنَّ اللَّهَ وَمَلَائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ ۚ يَا أَيُّهَا الَّذِينَ آمَنُوا صَلُّوا عَلَيْهِ وَسَلِّمُوا تَسْلِيمًا",
    );
    _turkishController = TextEditingController(
      text: widget.initialTurkish ?? "“Şüphesiz Allah ve melekleri Peygamber'e salât ederler. Ey iman edenler! Siz de ona salât edin ve içtenlikle selam verin.” (Ahzâb, 56)\n\nHayırlı Cumalar.",
    );
  }

  @override
  void dispose() {
    _arabicController.dispose();
    _turkishController.dispose();
    super.dispose();
  }

  void _showVerseSelectorDialog() async {
    final surahs = _repository.getSurahs();
    final locale = Localizations.localeOf(context).languageCode;

    SurahModel selectedSurah = surahs.first;
    VerseModel selectedVerse = selectedSurah.verses.first;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Ayet Seç"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<SurahModel>(
                    isExpanded: true,
                    value: selectedSurah,
                    items: surahs.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text("${s.number}. ${s.getLocalizedName(locale)}"),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() {
                          selectedSurah = val;
                          selectedVerse = val.verses.isNotEmpty ? val.verses.first : selectedVerse;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButton<VerseModel>(
                    isExpanded: true,
                    value: selectedSurah.verses.contains(selectedVerse) ? selectedVerse : selectedSurah.verses.first,
                    items: selectedSurah.verses.map((v) {
                      return DropdownMenuItem(
                        value: v,
                        child: Text("${v.number}. Ayet: ${v.getTranslation(locale)}", maxLines: 1, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() {
                          selectedVerse = val;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("İptal"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.emeraldPrimary, foregroundColor: Colors.white),
                  onPressed: () {
                    setState(() {
                      _arabicController.text = selectedVerse.arabicText;
                      _turkishController.text = "${selectedVerse.getTranslation(locale)}\n\n(${selectedSurah.getLocalizedName(locale)}, ${selectedVerse.number}. Ayet)";
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Karta Ekle"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cuma ve Ayet Kartı Oluşturucu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book, color: AppColors.goldPrimary),
            tooltip: "Ayet Kütüphanesinden Seç",
            onPressed: _showVerseSelectorDialog,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share("${_arabicController.text}\n\n${_turkishController.text}\n\n- Ezan Vakti Premium ile paylaşıldı.");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Select Verse Button Banner
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldPrimary.withValues(alpha: 0.15),
                foregroundColor: AppColors.goldPrimary,
                elevation: 0,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.goldPrimary)),
              ),
              icon: const Icon(Icons.auto_awesome),
              label: const Text("Kur'an-ı Kerim'den Ayet Seç", style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: _showVerseSelectorDialog,
            ),

            const SizedBox(height: 16),

            // Preview Card Canvas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _bgGradients[_selectedBgIndex],
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mosque, color: AppColors.goldAccent, size: 44),
                  const SizedBox(height: 16),
                  Text(
                    _arabicController.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arabic',
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _turkishController.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Color palette picker
            const Text("Arka Plan Teması Seçin", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_bgGradients.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedBgIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _bgGradients[index],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedBgIndex == index ? AppColors.goldAccent : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emeraldPrimary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.share_outlined),
              label: const Text("Görsel Kartı Paylaş"),
              onPressed: () {
                Share.share("${_arabicController.text}\n\n${_turkishController.text}\n\n- Ezan Vakti Premium ile paylaşıldı.");
              },
            ),
          ],
        ),
      ),
    );
  }
}


