import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ezan_vakti_premium/l10n/app_localizations.dart';
import '../../../core/services/quran_repository.dart';
import '../../../core/theme/app_colors.dart';
import '../../cards/presentation/card_creator_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final QuranRepository _repository = QuranRepository();
  final TextEditingController _searchController = TextEditingController();

  List<SurahModel> _allSurahs = [];
  List<SurahModel> _filteredSurahs = [];
  SurahModel? _activeSurah;
  bool _isLoading = true;
  QuranProvider _activeProvider = QuranProvider.local;

  // Track today's read verses & favorite verses
  final Set<String> _todayReadVerseIds = {};
  final Set<String> _favoriteVerseIds = {};
  Map<String, int> _lastReadData = {'surah': 1, 'verse': 1};

  String _currentLocaleCode = '';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context).languageCode;
    if (_currentLocaleCode.isNotEmpty && _currentLocaleCode != locale) {
      _loadInitialData();
    }
    _currentLocaleCode = locale;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final locale = Localizations.localeOf(context).languageCode;
    final provider = await _repository.getSelectedProvider();
    final surahs = await _repository.getSurahsWithProvider(locale);
    final lastRead = await _repository.getLastRead();
    final favs = await _repository.getFavoriteVerses();

    if (mounted) {
      setState(() {
        _allSurahs = surahs;
        _filteredSurahs = List.from(surahs);
        _activeProvider = provider;
        _lastReadData = lastRead;
        _favoriteVerseIds.clear();
        for (var f in favs) {
          _favoriteVerseIds.add('${f.surahNumber}:${f.number}');
        }
        _isLoading = false;
      });
      _loadTodayReadState();
    }
  }

  Future<void> _loadTodayReadState() async {
    if (_activeSurah == null) return;
    for (var v in _activeSurah!.verses) {
      bool isRead = await _repository.isVerseReadToday(_activeSurah!.number, v.number);
      final id = '${_activeSurah!.number}:${v.number}';
      if (mounted) {
        setState(() {
          if (isRead) {
            _todayReadVerseIds.add(id);
          } else {
            _todayReadVerseIds.remove(id);
          }
        });
      }
    }
  }

  void _filterSurahs(String query, String localeCode) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filteredSurahs = List.from(_allSurahs);
      } else {
        _filteredSurahs = _allSurahs.where((s) {
          bool matchesName = s.getLocalizedName(localeCode).toLowerCase().contains(q) ||
              s.nameTransliterated.toLowerCase().contains(q) ||
              s.nameArabic.contains(q) ||
              s.number.toString() == q;
          return matchesName;
        }).toList();
      }
    });
  }

  void _clearSearch(String localeCode) {
    _searchController.clear();
    _filterSurahs('', localeCode);
  }

  void _showSavedVersesModal() async {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final favs = await _repository.getFavoriteVerses();

    if (!mounted || !context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.goldPrimary),
                          const SizedBox(width: 8),
                          Text(
                            l10n.savedVerses,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  if (favs.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Henüz kaydedilmiş ayet bulunmuyor.\nAyet kartlarındaki yıldız ikonuna basarak kaydedebilirsiniz.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: favs.length,
                        itemBuilder: (context, index) {
                          final verse = favs[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.goldPrimary.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          "Sure ${verse.surahNumber} : Ayet ${verse.number}",
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.share_outlined, size: 18),
                                            onPressed: () {
                                              Share.share("${verse.arabicText}\n\n${verse.getTranslation(locale)}\n\n(Sure ${verse.surahNumber}:${verse.number})");
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                                            onPressed: () async {
                                              await _repository.toggleFavoriteVerse(verse);
                                              final updated = await _repository.getFavoriteVerses();
                                              setModalState(() {
                                                favs.clear();
                                                favs.addAll(updated);
                                              });
                                              setState(() {
                                                _favoriteVerseIds.remove('${verse.surahNumber}:${verse.number}');
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    verse.arabicText,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Arabic'),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    verse.getTranslation(locale),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return PopScope(
      canPop: _activeSurah == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _activeSurah != null) {
          setState(() {
            _activeSurah = null;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_activeSurah != null ? "${_activeSurah!.number}. ${_activeSurah!.getLocalizedName(locale)}" : l10n.quran),
          leading: _activeSurah != null
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _activeSurah = null;
                    });
                  },
                )
              : null,
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmarks, color: AppColors.goldPrimary),
              tooltip: "Kaydedilen Ayetler",
              onPressed: _showSavedVersesModal,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.emeraldPrimary))
            : _activeSurah != null
                ? _buildSurahDetailView(context, _activeSurah!, l10n, locale)
                : _buildSurahListView(context, l10n, locale),
      ),
    );
  }

  Widget _buildSurahListView(BuildContext context, AppLocalizations l10n, String localeCode) {
    return Column(
      children: [
        // Active Provider Badge
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          color: AppColors.goldPrimary.withValues(alpha: 0.15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_done, size: 16, color: AppColors.goldPrimary),
              const SizedBox(width: 6),
              Text(
                "${l10n.activeSource}: ${_getProviderName(_activeProvider)}",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.goldPrimary),
              ),
            ],
          ),
        ),

        // Search & Filter Header
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (val) => _filterSurahs(val, localeCode),
                decoration: InputDecoration(
                  hintText: l10n.searchSurah,
                  prefixIcon: const Icon(Icons.search, color: AppColors.emeraldPrimary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => _clearSearch(localeCode),
                        )
                      : null,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Resume Bookmark Button
              if (_allSurahs.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    final targetSurahNum = _lastReadData['surah'] ?? 1;
                    final surah = _allSurahs.firstWhere(
                      (s) => s.number == targetSurahNum,
                      orElse: () => _allSurahs.first,
                    );
                    setState(() {
                      _activeSurah = surah;
                    });
                    _loadTodayReadState();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.goldPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.goldPrimary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bookmark, color: AppColors.goldPrimary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "${l10n.lastRead}: ${_allSurahs.firstWhere((s) => s.number == (_lastReadData['surah'] ?? 1), orElse: () => _allSurahs.first).getLocalizedName(localeCode)}, ${_lastReadData['verse'] ?? 1}. ${l10n.verse}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.goldPrimary),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Surah List
        Expanded(
          child: ListView.builder(
            itemCount: _filteredSurahs.length,
            itemBuilder: (context, index) {
              final surah = _filteredSurahs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.emeraldPrimary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "${surah.number}",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    surah.getLocalizedName(localeCode),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${surah.nameTransliterated} • ${surah.verseCount} ${l10n.verse}"),
                  trailing: Text(
                    surah.nameArabic,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arabic',
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _activeSurah = surah;
                    });
                    _loadTodayReadState();
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getProviderName(QuranProvider provider) {
    switch (provider) {
      case QuranProvider.alQuranCloud:
        return "AlQuran Cloud REST API";
      case QuranProvider.fawazAhmed:
        return "Fawaz Ahmed Quran CDN";
      case QuranProvider.local:
        return "Dahili Çevrimdışı (Offline)";
    }
  }

  Widget _buildSurahDetailView(
    BuildContext context,
    SurahModel surah,
    AppLocalizations l10n,
    String localeCode,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: surah.verses.length,
      itemBuilder: (context, index) {
        final verse = surah.verses[index];
        String translationText = verse.getTranslation(localeCode);
        final verseId = '${surah.number}:${verse.number}';
        bool isRead = _todayReadVerseIds.contains(verseId);
        bool isFav = _favoriteVerseIds.contains(verseId);

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.goldPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${surah.number}:${verse.number}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    Row(
                      children: [
                        // Tik read icon
                        IconButton(
                          icon: Icon(
                            isRead ? Icons.check_circle : Icons.check_circle_outline,
                            color: isRead ? AppColors.emeraldAccent : Colors.grey,
                            size: 22,
                          ),
                          tooltip: isRead ? "Okundu olarak işaretlendi" : "Okundu olarak işaretle",
                          onPressed: () async {
                            bool updatedRead = await _repository.toggleVerseReadToday(surah.number, verse.number);
                            setState(() {
                              if (updatedRead) {
                                _todayReadVerseIds.add(verseId);
                              } else {
                                _todayReadVerseIds.remove(verseId);
                              }
                            });
                          },
                        ),
                        // Star favorite icon
                        IconButton(
                          icon: Icon(
                            isFav ? Icons.star : Icons.star_border,
                            color: isFav ? AppColors.goldPrimary : Colors.grey,
                            size: 22,
                          ),
                          tooltip: "Aayeti kaydet",
                          onPressed: () async {
                            bool updatedFav = await _repository.toggleFavoriteVerse(verse);
                            setState(() {
                              if (updatedFav) {
                                _favoriteVerseIds.add(verseId);
                              } else {
                                _favoriteVerseIds.remove(verseId);
                              }
                            });
                          },
                        ),
                        // Share icon
                        IconButton(
                          icon: const Icon(Icons.share_outlined, size: 20, color: Colors.grey),
                          tooltip: "Aayeti paylaş",
                          onPressed: () {
                            Share.share("${verse.arabicText}\n\n$translationText\n\n(${surah.getLocalizedName(localeCode)} ${surah.number}:${verse.number}) - Ezan Vakti Premium");
                          },
                        ),
                        // Create Card shortcut
                        IconButton(
                          icon: const Icon(Icons.style_outlined, size: 20, color: AppColors.goldPrimary),
                          tooltip: "Ayetten Kart Oluştur",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CardCreatorScreen(
                                  initialArabic: verse.arabicText,
                                  initialTurkish: "$translationText\n\n(${surah.getLocalizedName(localeCode)}, ${verse.number}. Ayet)",
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  verse.arabicText,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.8,
                    fontFamily: 'Arabic',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  translationText,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
