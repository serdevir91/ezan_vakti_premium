// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Ezan Vakti Premium';

  @override
  String get dashboard => 'Ana Sayfa';

  @override
  String get calendar => 'Takvim';

  @override
  String get qibla => 'Kıble Bulucu';

  @override
  String get quran => 'Kur\'an-ı Kerim';

  @override
  String get tasbih => 'Zikirmatik';

  @override
  String get kaza => 'Kaza Takibi';

  @override
  String get settings => 'Ayarlar';

  @override
  String get cards => 'Kart Oluşturucu';

  @override
  String get nextPrayer => 'Sıradaki Namaz';

  @override
  String get timeRemaining => 'Kalan Süre';

  @override
  String get location => 'Konum';

  @override
  String get fajr => 'İmsak';

  @override
  String get sunrise => 'Güneş';

  @override
  String get dhuhr => 'Öğle';

  @override
  String get asr => 'İkindi';

  @override
  String get maghrib => 'Akşam';

  @override
  String get isha => 'Yatsı';

  @override
  String get dailyPrayerRing => 'Günlük Namaz Takibi';

  @override
  String prayersCompleted(Object count) {
    return '$count/5 Namaz Kılındı';
  }

  @override
  String get quranReadingGoal => 'Kur\'an Okuma İlerlemesi';

  @override
  String quranPagesRead(Object pages) {
    return '$pages Ayet Okundu';
  }

  @override
  String get zikrGoal => 'Zikir Hedefi';

  @override
  String zikrCount(Object current, Object target) {
    return '$current/$target Zikir';
  }

  @override
  String streakDays(Object days) {
    return '$days Günlük Seri!';
  }

  @override
  String get dailyVerse => 'Günün Ayeti';

  @override
  String get dailyHadith => 'Günün Hadisi';

  @override
  String get dailyDua => 'Günün Duası';

  @override
  String get gregorianCalendar => 'Miladi Takvim';

  @override
  String get hijriCalendar => 'Hicri Takvim';

  @override
  String get holyDays => 'Dini Günler & Geceler';

  @override
  String get todayDetails => 'Günün Detayları';

  @override
  String get fastingStatus => 'Oruç Durumu';

  @override
  String get fasted => 'Oruç Tutuldu';

  @override
  String get notFasted => 'Tutulmadı';

  @override
  String get qiblaDirection => 'Kıble Yönü';

  @override
  String get qiblaAligned => 'Kıbleye Yöneldiniz!';

  @override
  String get alignDevice => 'Cihazı ok yönünde çevirin';

  @override
  String get angleToMecca => 'Kâbe Açısı';

  @override
  String get distanceToKaaba => 'Kâbe Uzaklığı';

  @override
  String get sensorMode => 'Sensör Moduna Geç';

  @override
  String get manualMode => 'Manuel Çevirme Modu';

  @override
  String get enableLocation => 'Hassas Konum İznini Aç';

  @override
  String get manualCompassHint =>
      'Ekranı parmağınızla sağa/sola kaydırarak pusulayı manuel döndürebilirsiniz.';

  @override
  String get surahs => 'Sureler';

  @override
  String get juz => 'Cüz';

  @override
  String get searchSurah => 'Sure veya Ayet Ara...';

  @override
  String get lastRead => 'Kaldığım Yerden Devam Et';

  @override
  String get verse => 'Ayet';

  @override
  String get translation => 'Meal';

  @override
  String get savedVerses => 'Kaydedilen Ayetler';

  @override
  String get activeSource => 'Aktif Kaynak';

  @override
  String get bookmarkSaved => 'Kaldığınız yer kaydedildi.';

  @override
  String get createCardFromVerse => 'Ayetten Kart Oluştur';

  @override
  String get targetReached => 'Hedefe Ulaşıldı!';

  @override
  String get reset => 'Sıfırla';

  @override
  String get addCustomZikr => 'Özel Zikir Ekle';

  @override
  String get presetZikrs => 'Hazır Zikirler';

  @override
  String get target => 'Hedef';

  @override
  String get missedPrayers => 'Kaza Namazları';

  @override
  String get missedFasts => 'Kaza Oruçları';

  @override
  String get remaining => 'Kalan';

  @override
  String get completed => 'Tamamlandı';

  @override
  String get theme => 'Tema Mimarisi';

  @override
  String get themeLight => 'Aydınlık Tema';

  @override
  String get themeDark => 'Koyu Tema';

  @override
  String get themeAmoled => 'Amoled (Saf Siyah)';

  @override
  String get systemDefault => 'Sistem Varsayılanı';

  @override
  String get colorPalette => 'Uygulama Renk Paleti';

  @override
  String get dataSource => 'Veri Kaynağı';

  @override
  String get language => 'Uygulama Dili';

  @override
  String get vibration => 'Titreşim Geri Bildirimi';

  @override
  String get calculationMethod => 'Hesaplama Yöntemi';

  @override
  String get notifications => 'Ezan Bildirimleri';

  @override
  String get silentMode => 'Namazda Otomatik Sessize Al';

  @override
  String get checkUpdates => 'Güncellemeleri Kontrol Et';

  @override
  String get rateApp => 'Uygulamayı Değerlendir';

  @override
  String get version => 'Sürüm';

  @override
  String get appUpToDate => 'Uygulamanız Güncel!';

  @override
  String get storeReview => 'Mağaza Yorumu Yaz';

  @override
  String get quickAccess => 'Hızlı Erişim & Araçlar';

  @override
  String get todaySummary => 'Bugünün İbadet Özetim';

  @override
  String get todayZikr => 'Bugün Çekilen Zikir';

  @override
  String get todayQuran => 'Bugün Okunan Kur\'an';

  @override
  String get weeklyQuran => 'Haftalık Okunan Kur\'an (Ayet Sayısı)';

  @override
  String get congratsAllPrayers =>
      'Tebrikler! Bugün tüm namazlarınızı eda ettiniz.';

  @override
  String get markPrayersHint =>
      'Namazla bereketlenmek için kılınanları işaretleyin.';

  @override
  String get mark => 'İşaretle';

  @override
  String get liveCompass => 'Canlı Pusula';

  @override
  String get gregorianHijri => 'Miladi & Hicri';

  @override
  String get digitalTasbih => 'Zikirmatik';

  @override
  String get fridayCard => 'Cuma & Ayet Kartı';

  @override
  String get monthlyProgress => 'Aylık İbadet İlerleyişi';

  @override
  String get editGoals => 'Hedefleri Düzenle';

  @override
  String get monthlyGoals => 'Aylık Hedefler';

  @override
  String get monthlyZikrGoal => 'Aylık Zikir Hedefi (Adet)';

  @override
  String get monthlyQuranGoal => 'Aylık Kur\'an Hedefi (Ayet Sayısı)';

  @override
  String get monthlyFastingGoal => 'Aylık Oruç Hedefi (Gün)';

  @override
  String get futureDaysWarning =>
      'Gelecek günlerin görevleri ve takibi henüz işaretlenemez.';

  @override
  String get fivePrayerTracker => '5 Vakit Namaz Takibi';

  @override
  String get zikrCountLabel => 'Çekilen Zikir Sayısı';

  @override
  String get quranVersesLabel => 'Okunan Kur\'an (Ayet Sayısı)';

  @override
  String get fastedLabel => 'Oruç Tutuldu';

  @override
  String get cancel => 'İptal';

  @override
  String get save => 'Kaydet';

  @override
  String get todayPrayers => 'Bugünün İbadetleri';

  @override
  String get ramadanMonth => '🌙 Mübarek Ramazan Ayı';

  @override
  String get threeMonths => '✨ Mübarek Üç Aylar (Recep / Şaban / Ramazan)';

  @override
  String get holyMonthBadge => '✨ Mübarek İslam Ayı';

  @override
  String get todayZikrStats => 'Bugünkü Zikir İstatistiğim';

  @override
  String get total => 'Toplam';

  @override
  String get ramadanStart => 'Ramazan Başlangıcı';

  @override
  String get laylatAlQadr => 'Kadir Gecesi';

  @override
  String get eidAlFitr => 'Ramazan Bayramı 1. Gün';

  @override
  String get eidAlAdha => 'Kurban Bayramı 1. Gün';

  @override
  String get hijriNewYear => 'Hicri Yılbaşı';

  @override
  String get dayOfAshura => 'Aşure Günü';

  @override
  String get mawlid => 'Mevlid Kandili';
}
