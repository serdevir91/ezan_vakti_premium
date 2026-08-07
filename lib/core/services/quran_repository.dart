import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum QuranProvider {
  local,        // Dahili Çevrimdışı (Offline)
  alQuranCloud, // AlQuran Cloud API (https://api.alquran.cloud/v1)
  fawazAhmed,   // Fawaz Ahmed Quran API (GitHub CDN)
}

class SurahModel {
  final int number;
  final String nameArabic;
  final String nameTurkish;
  final String nameEnglish;
  final String namePersian;
  final String nameTransliterated;
  final int verseCount;
  final List<VerseModel> verses;

  SurahModel({
    required this.number,
    required this.nameArabic,
    required this.nameTurkish,
    required this.nameEnglish,
    required this.namePersian,
    required this.nameTransliterated,
    required this.verseCount,
    required this.verses,
  });

  String getLocalizedName(String localeCode) {
    switch (localeCode) {
      case 'tr':
        return nameTurkish;
      case 'en':
        return nameEnglish;
      case 'fa':
        return namePersian;
      case 'ar':
      default:
        return nameArabic;
    }
  }
}

class VerseModel {
  final int number;
  final int surahNumber;
  final String arabicText;
  final String translationTurkish;
  final String translationEnglish;
  final String translationPersian;
  final String translationArabic;

  VerseModel({
    required this.number,
    required this.surahNumber,
    required this.arabicText,
    required this.translationTurkish,
    required this.translationEnglish,
    required this.translationPersian,
    required this.translationArabic,
  });

  String getTranslation(String localeCode) {
    switch (localeCode) {
      case 'en':
        if (translationEnglish.isNotEmpty) return translationEnglish;
        if (translationTurkish.isNotEmpty) return translationTurkish;
        return arabicText;
      case 'fa':
        if (translationPersian.isNotEmpty) return translationPersian;
        if (translationEnglish.isNotEmpty) return translationEnglish;
        return translationTurkish;
      case 'ar':
        if (translationArabic.isNotEmpty) return translationArabic;
        return arabicText;
      case 'tr':
      default:
        if (translationTurkish.isNotEmpty) return translationTurkish;
        if (translationEnglish.isNotEmpty) return translationEnglish;
        return arabicText;
    }
  }

  Map<String, dynamic> toJson() => {
    'number': number,
    'surahNumber': surahNumber,
    'arabicText': arabicText,
    'translationTurkish': translationTurkish,
    'translationEnglish': translationEnglish,
    'translationPersian': translationPersian,
    'translationArabic': translationArabic,
  };

  factory VerseModel.fromJson(Map<String, dynamic> json) => VerseModel(
    number: json['number'] ?? 1,
    surahNumber: json['surahNumber'] ?? 1,
    arabicText: json['arabicText'] ?? '',
    translationTurkish: json['translationTurkish'] ?? '',
    translationEnglish: json['translationEnglish'] ?? '',
    translationPersian: json['translationPersian'] ?? '',
    translationArabic: json['translationArabic'] ?? '',
  );
}

class QuranRepository {
  static const String _lastReadSurahKey = 'quran_last_read_surah';
  static const String _lastReadVerseKey = 'quran_last_read_verse';
  static const String _providerKey = 'pref_quran_provider';
  static const String _favoritesKey = 'quran_favorite_verses';

  Future<QuranProvider> getSelectedProvider() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_providerKey) ?? 2;
    return QuranProvider.values[index % QuranProvider.values.length];
  }

  Future<void> setSelectedProvider(QuranProvider provider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_providerKey, provider.index);
  }

  Future<void> saveLastRead(int surahNumber, int verseNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastReadSurahKey, surahNumber);
    await prefs.setInt(_lastReadVerseKey, verseNumber);
  }

  Future<Map<String, int>> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'surah': prefs.getInt(_lastReadSurahKey) ?? 1,
      'verse': prefs.getInt(_lastReadVerseKey) ?? 1,
    };
  }

  // --- Favorite Verses Persistence ---
  Future<List<VerseModel>> getFavoriteVerses() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_favoritesKey) ?? [];
    return raw.map((item) => VerseModel.fromJson(jsonDecode(item))).toList();
  }

  Future<bool> toggleFavoriteVerse(VerseModel verse) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getFavoriteVerses();
    final index = list.indexWhere((v) => v.surahNumber == verse.surahNumber && v.number == verse.number);
    bool isFav = false;
    if (index >= 0) {
      list.removeAt(index);
      isFav = false;
    } else {
      list.add(verse);
      isFav = true;
    }
    final raw = list.map((v) => jsonEncode(v.toJson())).toList();
    await prefs.setStringList(_favoritesKey, raw);
    return isFav;
  }

  Future<bool> isVerseFavorite(int surahNumber, int verseNumber) async {
    final list = await getFavoriteVerses();
    return list.any((v) => v.surahNumber == surahNumber && v.number == verseNumber);
  }

  // --- Daily Read Verses Tracker ---
  Future<int> getTodayReadVerseCount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final key = 'read_verses_${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final list = prefs.getStringList(key) ?? [];
    return list.length;
  }

  Future<bool> toggleVerseReadToday(int surahNumber, int verseNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final key = 'read_verses_${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final verseId = '$surahNumber:$verseNumber';
    List<String> list = prefs.getStringList(key) ?? [];
    bool isRead = false;
    if (list.contains(verseId)) {
      list.remove(verseId);
      isRead = false;
    } else {
      list.add(verseId);
      isRead = true;
    }
    await prefs.setStringList(key, list);
    // Also save numerical count for calendar sync
    final calKey = 'quran_${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await prefs.setInt(calKey, list.length);
    return isRead;
  }

  Future<bool> isVerseReadToday(int surahNumber, int verseNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final key = 'read_verses_${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final list = prefs.getStringList(key) ?? [];
    return list.contains('$surahNumber:$verseNumber');
  }

  /// Fetches Surahs with live translations for TR, EN, AR, FA
  Future<List<SurahModel>> getSurahsWithProvider(String localeCode) async {
    // 1. Try AlQuran Cloud API first (complete live translations for TR, EN, AR, FA)
    try {
      final cloudSurahs = await _fetchAlQuranCloudSurahs(localeCode);
      if (cloudSurahs.isNotEmpty) return cloudSurahs;
    } catch (_) {}

    // 2. Try Fawaz Ahmed API
    try {
      final fawazSurahs = await _fetchFawazAhmedSurahs(localeCode);
      if (fawazSurahs.isNotEmpty) return fawazSurahs;
    } catch (_) {}

    // 3. Fallback to local dataset
    return getSurahs();
  }

  List<SurahModel> getSurahs() {
    return _allSurahMetadata.map((meta) {
      final surahNum = meta['number'] as int;
      final verses = _getVersesForSurah(surahNum);
      return SurahModel(
        number: surahNum,
        nameArabic: meta['ar'] as String,
        nameTurkish: meta['tr'] as String,
        nameEnglish: meta['en'] as String,
        namePersian: meta['fa'] as String,
        nameTransliterated: meta['translit'] as String,
        verseCount: meta['verses'] as int,
        verses: verses,
      );
    }).toList();
  }

  List<VerseModel> _getVersesForSurah(int surahNumber) {
    if (_offlineVersesMap.containsKey(surahNumber)) {
      return _offlineVersesMap[surahNumber]!;
    }
    // Generic fallback verse generator for surahs without embedded full text
    final meta = _allSurahMetadata.firstWhere((element) => element['number'] == surahNumber);
    final total = meta['verses'] as int;
    return List.generate(total, (index) {
      final vNum = index + 1;
      return VerseModel(
        number: vNum,
        surahNumber: surahNumber,
        arabicText: "بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ ($vNum)",
        translationTurkish: "Rahmân ve Rahîm olan Allah'ın adıyla ($surahNumber:$vNum)",
        translationEnglish: "In the name of Allah, the Entirely Merciful, the Especially Merciful ($surahNumber:$vNum)",
        translationPersian: "به نام خداوند بخشنده مهربان ($surahNumber:$vNum)",
        translationArabic: "بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ ($vNum)",
      );
    });
  }

  /// Live Fetch from AlQuran Cloud API (https://api.alquran.cloud/v1)
  Future<List<SurahModel>> _fetchAlQuranCloudSurahs(String localeCode) async {
    String edition = "tr.diyanet";
    if (localeCode == 'en') edition = "en.sahih";
    if (localeCode == 'fa') edition = "fa.makarem";
    if (localeCode == 'ar') edition = "quran-uthmani";

    final url = Uri.parse("https://api.alquran.cloud/v1/quran/$edition");
    final res = await http.get(url).timeout(const Duration(seconds: 12));
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final List list = json['data']['surahs'] ?? [];
      List<SurahModel> result = [];
      for (var item in list) {
        final chNum = item['number'] as int;
        final List ayahsList = item['ayahs'] ?? [];
        final localVerses = _getVersesForSurah(chNum);

        final verseModels = ayahsList.map((a) {
          final vNum = a['numberInSurah'] as int;
          final text = (a['text'] as String? ?? '').trim();
          final fallbackV = localVerses.where((lv) => lv.number == vNum).firstOrNull;

          return VerseModel(
            number: vNum,
            surahNumber: chNum,
            arabicText: localeCode == 'ar'
                ? text
                : (fallbackV?.arabicText.isNotEmpty == true ? fallbackV!.arabicText : "بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ"),
            translationTurkish: localeCode == 'tr' ? text : (fallbackV?.translationTurkish ?? ""),
            translationEnglish: localeCode == 'en' ? text : (fallbackV?.translationEnglish ?? ""),
            translationPersian: localeCode == 'fa' ? text : (fallbackV?.translationPersian ?? ""),
            translationArabic: localeCode == 'ar' ? text : (fallbackV?.translationArabic ?? ""),
          );
        }).toList();

        final meta = _allSurahMetadata.firstWhere(
          (m) => m['number'] == chNum,
          orElse: () => {
            'ar': item['name'] ?? '',
            'tr': item['englishName'] ?? '',
            'en': item['englishName'] ?? '',
            'fa': item['name'] ?? '',
            'translit': item['englishName'] ?? '',
            'verses': verseModels.length,
          },
        );

        result.add(SurahModel(
          number: chNum,
          nameArabic: meta['ar'] as String,
          nameTurkish: meta['tr'] as String,
          nameEnglish: meta['en'] as String,
          namePersian: meta['fa'] as String,
          nameTransliterated: meta['translit'] as String,
          verseCount: verseModels.length,
          verses: verseModels,
        ));
      }
      return result;
    }
    return [];
  }

  /// Live Fetch from Fawaz Ahmed Quran API (GitHub CDN)
  Future<List<SurahModel>> _fetchFawazAhmedSurahs(String localeCode) async {
    String edition = "tur-diyanetisleri";
    if (localeCode == 'en') edition = "eng-sahih";
    if (localeCode == 'fa') edition = "fas-hussainansarian";
    if (localeCode == 'ar') edition = "ara-quranacademy";

    final url = Uri.parse("https://cdn.jsdelivr.net/gh/fawazahmed0/quran-api@1/editions/$edition.json");
    final res = await http.get(url).timeout(const Duration(seconds: 10));
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final List quranData = (json['quran'] ?? json['chapter'] ?? json['verses'] ?? (json.values.firstWhere((v) => v is List, orElse: () => []) as List)) as List;
      if (quranData.isEmpty) return getSurahs();

      // Group verses by chapter
      final Map<int, List<Map<String, dynamic>>> chapters = {};
      for (var item in quranData) {
        final ch = item['chapter'] as int;
        chapters.putIfAbsent(ch, () => []);
        chapters[ch]!.add({
          'verse': item['verse'],
          'text': item['text'] ?? '',
        });
      }

      List<SurahModel> result = [];
      for (var meta in _allSurahMetadata) {
        final chNum = meta['number'] as int;
        final verses = chapters[chNum] ?? [];
        final localVerses = _getVersesForSurah(chNum);

        List<VerseModel> verseModels;
        if (verses.isNotEmpty) {
          verseModels = verses.map((v) {
            final vNum = v['verse'] as int;
            final text = v['text'] as String;
            final fallbackV = localVerses.where((lv) => lv.number == vNum).firstOrNull;

            return VerseModel(
              number: vNum,
              surahNumber: chNum,
              arabicText: localeCode == 'ar'
                  ? text
                  : (fallbackV?.arabicText.isNotEmpty == true ? fallbackV!.arabicText : "بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ"),
              translationTurkish: localeCode == 'tr' ? text : (fallbackV?.translationTurkish ?? ""),
              translationEnglish: localeCode == 'en' ? text : (fallbackV?.translationEnglish ?? ""),
              translationPersian: localeCode == 'fa' ? text : (fallbackV?.translationPersian ?? ""),
              translationArabic: localeCode == 'ar' ? text : (fallbackV?.translationArabic ?? ""),
            );
          }).toList();
        } else {
          verseModels = localVerses;
        }

        result.add(SurahModel(
          number: chNum,
          nameArabic: meta['ar'] as String,
          nameTurkish: meta['tr'] as String,
          nameEnglish: meta['en'] as String,
          namePersian: meta['fa'] as String,
          nameTransliterated: meta['translit'] as String,
          verseCount: verseModels.length,
          verses: verseModels,
        ));
      }
      return result;
    }
    return [];
  }

  // --- Embedded Offline Data Store ---
  static final Map<int, List<VerseModel>> _offlineVersesMap = {
    1: [
      VerseModel(
        number: 1,
        surahNumber: 1,
        arabicText: "بِسۡمِ ٱللَّهِ ٱلرَّحۡمَـٰنِ ٱلرَّحِیمِ",
        translationTurkish: "Rahmân ve Rahîm olan Allah'ın adıyla.",
        translationEnglish: "In the name of Allah, the Entirely Merciful, the Especially Merciful.",
        translationPersian: "به نام خداوند بخشنده مهربان.",
        translationArabic: "بِسۡمِ ٱللَّهِ ٱلرَّحۡمَـٰنِ ٱلرَّحِیمِ",
      ),
      VerseModel(
        number: 2,
        surahNumber: 1,
        arabicText: "ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَـٰلَمِینَ",
        translationTurkish: "Hamd, âlemlerin Rabbi olan Allah'a mahsustur.",
        translationEnglish: "[All] praise is [due] to Allah, Lord of the worlds -",
        translationPersian: "ستایش مخصوص خداوندی است که پروردگار جهانیان است.",
        translationArabic: "ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَـٰلَمِینَ",
      ),
      VerseModel(
        number: 3,
        surahNumber: 1,
        arabicText: "ٱلرَّحۡمَـٰنِ ٱلرَّحِیمِ",
        translationTurkish: "O, Rahmân'dır, Rahîm'dir.",
        translationEnglish: "The Entirely Merciful, the Especially Merciful,",
        translationPersian: "بخشنده و مهربان است.",
        translationArabic: "ٱلرَّحۡمَـٰنِ ٱلرَّحِیمِ",
      ),
      VerseModel(
        number: 4,
        surahNumber: 1,
        arabicText: "مَـٰلِكِ یَوۡمِ ٱلدِّینِ",
        translationTurkish: "Din gününün (hesap gününün) tek sahibidir.",
        translationEnglish: "Sovereign of the Day of Recompense.",
        translationPersian: "مالک روز جزا است.",
        translationArabic: "مَـٰلِكِ یَوۡمِ ٱلدِّینِ",
      ),
      VerseModel(
        number: 5,
        surahNumber: 1,
        arabicText: "إِیَّاكَ نَعۡبُدُ وَإِیَّاكَ نَسۡتَعِینُ",
        translationTurkish: "Yalnız sana kulluk eder ve yalnız senden yardım dileriz.",
        translationEnglish: "It is You we worship and You we ask for help.",
        translationPersian: "تنها تو را می‌پرستیم و تنها از تو یاری می‌جوییم.",
        translationArabic: "إِیَّاكَ نَعۡبُدُ وَإِیَّاكَ نَسۡتَعِینُ",
      ),
      VerseModel(
        number: 6,
        surahNumber: 1,
        arabicText: "ٱهۡدِنَا ٱلصِّرَ ٰطَ ٱلۡمُسۡتَقِیمَ",
        translationTurkish: "Bizi doğru yola ilet,",
        translationEnglish: "Guide us to the straight path -",
        translationPersian: "ما را به راه راست هدایت فرما.",
        translationArabic: "ٱهۡدِنَا ٱلصِّرَ ٰطَ ٱلۡمُسۡتَقِیمَ",
      ),
      VerseModel(
        number: 7,
        surahNumber: 1,
        arabicText: "صِرَ ٰطَ ٱلَّذِینَ أَنۡعَمۡتَ عَلَیۡهِمۡ غَیۡرِ ٱلۡمَغۡضُوبِ عَلَیۡهِمۡ وَلَا ٱلضَّآلِّینَ",
        translationTurkish: "Nimet verdiğin kimselerin yoluna; gazaba uğramışların ve sapmışların yoluna değil.",
        translationEnglish: "The path of those upon whom You have bestowed favor, not of those who have earned [Your] anger or of those who are astray.",
        translationPersian: "راه کسانی که آنان را مشمول نعمت خود ساختی، نه غضب‌شدگان و نه گمراهان.",
        translationArabic: "صِرَ ٰطَ ٱلَّذِینَ أَنۡعَمۡتَ عَلَیۡهِمۡ غَیۡرِ ٱلۡمَغۡضُوبِ عَلَیۡهِمۡ وَلَا ٱلضَّآلِّینَ",
      ),
    ],
    2: [
      VerseModel(
        number: 1,
        surahNumber: 2,
        arabicText: "الم",
        translationTurkish: "Elif. Lâm. Mîm.",
        translationEnglish: "Alif, Lam, Meem.",
        translationPersian: "الف، لام، میم.",
        translationArabic: "الم",
      ),
      VerseModel(
        number: 2,
        surahNumber: 2,
        arabicText: "ذَ ٰلِكَ ٱلۡكِتَـٰبُ لَا رَیۡبَ فِیهِ هُدًى لِّلۡمُتَّقِینَ",
        translationTurkish: "Bu, kendisinde şüphe olmayan, müttakiler için yol gösterici bir kitaptır.",
        translationEnglish: "This is the Book about which there is no doubt, a guidance for those conscious of Allah -",
        translationPersian: "این کتابی است که هیچ شکی در آن نیست و مایه هدایت پرهیزکاران است.",
        translationArabic: "ذَ ٰلِكَ ٱلۡكِتَـٰبُ لَا رَیۡبَ فِیهِ هُدًى لِّلۡمُتَّقِینَ",
      ),
      VerseModel(
        number: 255,
        surahNumber: 2,
        arabicText: "ٱللَّهُ لَاۤ إِلَـٰهَ إِلَّا هُوَ ٱلۡحَیُّ ٱلۡقَیُّومُ لَا تَأۡخُذُهُۥ سِنَةٌ وَلَا نَوۡمٌ ۚ لَّهُۥ مَا فِی ٱلسَّمَـٰوَ ٰتِ وَمَا فِی ٱلۡأَرۡضِ",
        translationTurkish: "Âyet-el Kürsî: Allah ki O'ndan başka ilah yoktur. O Hayy'dır, Kayyûm'dur. Kendisini ne bir uyuklama tutar ne de bir uyku. Göklerde ve yerde ne varsa hepsi O'nundur.",
        translationEnglish: "Ayat al-Kursi: Allah - there is no deity except Him, the Ever-Living, the Sustainer of [all] existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth.",
        translationPersian: "آیة الکرسی: خداوند هیچ معبودی جز او نیست؛ زنده ve برپا دارنده است. نه خوابی او را فرا می‌گیرد ve نه چرت...",
        translationArabic: "ٱللَّهُ لَاۤ إِلَـٰهَ إِلَّا هُوَ ٱلۡحَیُّ ٱلۡقَیُّومُ...",
      ),
    ],
    36: [
      VerseModel(
        number: 1,
        surahNumber: 36,
        arabicText: "يس",
        translationTurkish: "Yâ-Sîn.",
        translationEnglish: "Ya, Seen.",
        translationPersian: "یس.",
        translationArabic: "يس",
      ),
      VerseModel(
        number: 2,
        surahNumber: 36,
        arabicText: "وَٱلۡقُرۡءَانِ ٱلۡحَكِیمِ",
        translationTurkish: "Hikmet dolu Kur'an'a andolsun ki,",
        translationEnglish: "By the wise Qur'an.",
        translationPersian: "سوگند به قرآن حکیم.",
        translationArabic: "وَٱلۡقُرۡءَانِ ٱلۡحَكِیمِ",
      ),
      VerseModel(
        number: 3,
        surahNumber: 36,
        arabicText: "إِنَّكَ لَمِنَ الْمُرْسَلِينَ",
        translationTurkish: "Sen hiç şüphesiz gönderilmiş elçilerdensin.",
        translationEnglish: "Indeed you, [O Muhammad], are from among the messengers.",
        translationPersian: "که تو قطعاً از فرستادگانی.",
        translationArabic: "إِنَّكَ لَمِنَ الْمُرْسَلِينَ",
      ),
    ],
    67: [
      VerseModel(
        number: 1,
        surahNumber: 67,
        arabicText: "تَبَـٰرَكَ ٱلَّذِی بِیَدِهِ ٱلۡمُلۡكُ وَهُوَ عَلَىٰ كُلِّ شَیۡءٍ قَدِیرٌ",
        translationTurkish: "Hükümranlık elinde olan Allah ne yücedir. O, her şeye kadirdir.",
        translationEnglish: "Blessed is He in whose hand is dominion, and He is over all things competent -",
        translationPersian: "پربرکت و بزرگوار است آن کس که حکومت جهان هستی به دست اوست...",
        translationArabic: "تَبَـٰرَكَ ٱلَّذِی بِیَدِهِ ٱلۡمُلۡكُ...",
      ),
    ],
    112: [
      VerseModel(
        number: 1,
        surahNumber: 112,
        arabicText: "قُلۡ هُوَ ٱللَّهُ أَحَدٌ",
        translationTurkish: "De ki: O Allah tektir.",
        translationEnglish: "Say, 'He is Allah, [who is] One,'",
        translationPersian: "بگو: اوست خدای یگانه.",
        translationArabic: "قُلۡ... ",
      ),
      VerseModel(
        number: 2,
        surahNumber: 112,
        arabicText: "ٱللَّهُ ٱلصَّمَدُ",
        translationTurkish: "Allah Samed'dir (her şey O'na muhtaçtır).",
        translationEnglish: "Allah, the Eternal Refuge.",
        translationPersian: "خداوند بی نیاز است.",
        translationArabic: "ٱللَّهُ ٱلصَّمَدُ",
      ),
      VerseModel(
        number: 3,
        surahNumber: 112,
        arabicText: "لَمۡ یَلِدۡ وَلَمۡ یُولَدۡ",
        translationTurkish: "O doğurmamış ve doğmamıştır.",
        translationEnglish: "He neither begets nor is born,",
        translationPersian: "نه زاده ve نه زاده شده است.",
        translationArabic: "لَمۡ یَلِدۡ وَلَمۡ یُولَدۡ",
      ),
      VerseModel(
        number: 4,
        surahNumber: 112,
        arabicText: "وَلَمۡ یَكُن لَّهُۥ كُفُوًا أَحَدٌ",
        translationTurkish: "Hiçbir şey O'na denk değildir.",
        translationEnglish: "Nor is there to Him any equivalent.",
        translationPersian: "ve هیچ کس همتای او نبوده است.",
        translationArabic: "وَلَمۡ یَكُن لَّهُۥ كُفُوًا أَحَدٌ",
      ),
    ],
    113: [
      VerseModel(
        number: 1,
        surahNumber: 113,
        arabicText: "قُلۡ أَعُوذُ بِرَبِّ ٱلۡفَلَقِ",
        translationTurkish: "De ki: Sabahın Rabbine sığınırım.",
        translationEnglish: "Say, 'I seek refuge in the Lord of daybreak'",
        translationPersian: "بگو: پناه می‌برم به پروردگار سپیده دم.",
        translationArabic: "قُلۡ أَعُوذُ بِرَبِّ ٱلۡفَلَقِ",
      ),
    ],
    114: [
      VerseModel(
        number: 1,
        surahNumber: 114,
        arabicText: "قُلۡ أَعُوذُ بِرَبِّ ٱلنَّاسِ",
        translationTurkish: "De ki: İnsanların Rabbine sığınırım.",
        translationEnglish: "Say, 'I seek refuge in the Lord of mankind'",
        translationPersian: "بگو: پناه می‌برم به پروردگار مردم.",
        translationArabic: "قُلۡ أَعُوذُ بِرَبِّ ٱلنَّاسِ",
      ),
    ],
  };

  static final List<Map<String, dynamic>> _allSurahMetadata = [
    {'number': 1, 'ar': 'الفاتحة', 'tr': 'Fâtiha', 'en': 'Al-Fatihah', 'fa': 'حمد', 'translit': 'Al-Fātiḥah', 'verses': 7},
    {'number': 2, 'ar': 'البقرة', 'tr': 'Bakara', 'en': 'Al-Baqarah', 'fa': 'بقره', 'translit': 'Al-Baqarah', 'verses': 286},
    {'number': 3, 'ar': 'آل عمران', 'tr': 'Âl-i İmrân', 'en': 'Ali ' 'Imran', 'fa': 'آل عمران', 'translit': "Āl ʿImrān", 'verses': 200},
    {'number': 4, 'ar': 'النساء', 'tr': 'Nisâ', 'en': 'An-Nisa', 'fa': 'نساء', 'translit': 'An-Nisāʾ', 'verses': 176},
    {'number': 5, 'ar': 'المائدة', 'tr': 'Mâide', 'en': 'Al-Ma\'idah', 'fa': 'مائده', 'translit': 'Al-Māʾidah', 'verses': 120},
    {'number': 6, 'ar': 'الأنعام', 'tr': 'En\'âm', 'en': 'Al-An\'am', 'fa': 'انعام', 'translit': 'Al-Anʿām', 'verses': 165},
    {'number': 7, 'ar': 'الأعراف', 'tr': 'A\'râf', 'en': 'Al-A\'raf', 'fa': 'اعراف', 'translit': 'Al-Aʿrāf', 'verses': 206},
    {'number': 8, 'ar': 'الأنفال', 'tr': 'Enfâl', 'en': 'Al-Anfal', 'fa': 'انفال', 'translit': 'Al-Anfāl', 'verses': 75},
    {'number': 9, 'ar': 'التوبة', 'tr': 'Tevbe', 'en': 'At-Tawbah', 'fa': 'توبه', 'translit': 'At-Tawbah', 'verses': 129},
    {'number': 10, 'ar': 'يونس', 'tr': 'Yûnus', 'en': 'Yunus', 'fa': 'یونس', 'translit': 'Yūnus', 'verses': 109},
    {'number': 11, 'ar': 'هود', 'tr': 'Hûd', 'en': 'Hud', 'fa': 'هود', 'translit': 'Hūd', 'verses': 123},
    {'number': 12, 'ar': 'يوسف', 'tr': 'Yûsuf', 'en': 'Yusuf', 'fa': 'یوسف', 'translit': 'Yūsuf', 'verses': 111},
    {'number': 13, 'ar': 'الرعد', 'tr': 'Ra\'d', 'en': 'Ar-Ra\'d', 'fa': 'رعد', 'translit': 'Ar-Raʿd', 'verses': 43},
    {'number': 14, 'ar': 'إبراهيم', 'tr': 'İbrâhîm', 'en': 'Ibrahim', 'fa': 'ابراهیم', 'translit': 'Ibrāhīm', 'verses': 52},
    {'number': 15, 'ar': 'الحجر', 'tr': 'Hicr', 'en': 'Al-Hijr', 'fa': 'حجر', 'translit': 'Al-Ḥijr', 'verses': 99},
    {'number': 16, 'ar': 'النحل', 'tr': 'Nahl', 'en': 'An-Nahl', 'fa': 'نحل', 'translit': 'An-Naḥl', 'verses': 128},
    {'number': 17, 'ar': 'الإسراء', 'tr': 'İsrâ', 'en': 'Al-Isra', 'fa': 'اسراء', 'translit': 'Al-Isrāʾ', 'verses': 111},
    {'number': 18, 'ar': 'الكهف', 'tr': 'Kehf', 'en': 'Al-Kahf', 'fa': 'كهف', 'translit': 'Al-Kahf', 'verses': 110},
    {'number': 19, 'ar': 'مريم', 'tr': 'Meryem', 'en': 'Maryam', 'fa': 'مریم', 'translit': 'Maryam', 'verses': 98},
    {'number': 20, 'ar': 'طه', 'tr': 'Tâhâ', 'en': 'Taha', 'fa': 'طه', 'translit': 'Ṭā-Hā', 'verses': 135},
    {'number': 21, 'ar': 'الأنبياء', 'tr': 'Enbiyâ', 'en': 'Al-Anbiya', 'fa': 'انبیاء', 'translit': 'Al-Anbiyāʾ', 'verses': 112},
    {'number': 22, 'ar': 'الحج', 'tr': 'Hacc', 'en': 'Al-Hajj', 'fa': 'حج', 'translit': 'Al-Ḥajj', 'verses': 78},
    {'number': 23, 'ar': 'المؤمنون', 'tr': 'Mü\'minûn', 'en': 'Al-Mu\'minun', 'fa': 'مؤمنون', 'translit': 'Al-Muʾminūn', 'verses': 118},
    {'number': 24, 'ar': 'النور', 'tr': 'Nûr', 'en': 'An-Nur', 'fa': 'نور', 'translit': 'An-Nūr', 'verses': 64},
    {'number': 25, 'ar': 'الفرقان', 'tr': 'Furkân', 'en': 'Al-Furqan', 'fa': 'فرقان', 'translit': 'Al-Furqān', 'verses': 77},
    {'number': 36, 'ar': 'يس', 'tr': 'Yâsîn', 'en': 'Ya-Sin', 'fa': 'یس', 'translit': 'Yā-Sīn', 'verses': 83},
    {'number': 67, 'ar': 'الملك', 'tr': 'Mülk', 'en': 'Al-Mulk', 'fa': 'ملک', 'translit': 'Al-Mulk', 'verses': 30},
    {'number': 112, 'ar': 'الإخلاص', 'tr': 'İhlâs', 'en': 'Al-Ikhlas', 'fa': 'توحید', 'translit': 'Al-Ikhlāṣ', 'verses': 4},
    {'number': 113, 'ar': 'الفلق', 'tr': 'Felak', 'en': 'Al-Falaq', 'fa': 'فلق', 'translit': 'Al-Falaq', 'verses': 5},
    {'number': 114, 'ar': 'الناس', 'tr': 'Nâs', 'en': 'An-Nas', 'fa': 'ناس', 'translit': 'An-Nās', 'verses': 6},
  ];
}
