import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fa'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ezan Vakti Premium'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get dashboard;

  /// No description provided for @calendar.
  ///
  /// In tr, this message translates to:
  /// **'Takvim'**
  String get calendar;

  /// No description provided for @qibla.
  ///
  /// In tr, this message translates to:
  /// **'Kıble Bulucu'**
  String get qibla;

  /// No description provided for @quran.
  ///
  /// In tr, this message translates to:
  /// **'Kur\'an-ı Kerim'**
  String get quran;

  /// No description provided for @tasbih.
  ///
  /// In tr, this message translates to:
  /// **'Zikirmatik'**
  String get tasbih;

  /// No description provided for @kaza.
  ///
  /// In tr, this message translates to:
  /// **'Kaza Takibi'**
  String get kaza;

  /// No description provided for @settings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settings;

  /// No description provided for @cards.
  ///
  /// In tr, this message translates to:
  /// **'Kart Oluşturucu'**
  String get cards;

  /// No description provided for @nextPrayer.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki Namaz'**
  String get nextPrayer;

  /// No description provided for @timeRemaining.
  ///
  /// In tr, this message translates to:
  /// **'Kalan Süre'**
  String get timeRemaining;

  /// No description provided for @location.
  ///
  /// In tr, this message translates to:
  /// **'Konum'**
  String get location;

  /// No description provided for @fajr.
  ///
  /// In tr, this message translates to:
  /// **'İmsak'**
  String get fajr;

  /// No description provided for @sunrise.
  ///
  /// In tr, this message translates to:
  /// **'Güneş'**
  String get sunrise;

  /// No description provided for @dhuhr.
  ///
  /// In tr, this message translates to:
  /// **'Öğle'**
  String get dhuhr;

  /// No description provided for @asr.
  ///
  /// In tr, this message translates to:
  /// **'İkindi'**
  String get asr;

  /// No description provided for @maghrib.
  ///
  /// In tr, this message translates to:
  /// **'Akşam'**
  String get maghrib;

  /// No description provided for @isha.
  ///
  /// In tr, this message translates to:
  /// **'Yatsı'**
  String get isha;

  /// No description provided for @dailyPrayerRing.
  ///
  /// In tr, this message translates to:
  /// **'Günlük Namaz Takibi'**
  String get dailyPrayerRing;

  /// No description provided for @prayersCompleted.
  ///
  /// In tr, this message translates to:
  /// **'{count}/5 Namaz Kılındı'**
  String prayersCompleted(Object count);

  /// No description provided for @quranReadingGoal.
  ///
  /// In tr, this message translates to:
  /// **'Kur\'an Okuma İlerlemesi'**
  String get quranReadingGoal;

  /// No description provided for @quranPagesRead.
  ///
  /// In tr, this message translates to:
  /// **'{pages} Ayet Okundu'**
  String quranPagesRead(Object pages);

  /// No description provided for @zikrGoal.
  ///
  /// In tr, this message translates to:
  /// **'Zikir Hedefi'**
  String get zikrGoal;

  /// No description provided for @zikrCount.
  ///
  /// In tr, this message translates to:
  /// **'{current}/{target} Zikir'**
  String zikrCount(Object current, Object target);

  /// No description provided for @streakDays.
  ///
  /// In tr, this message translates to:
  /// **'{days} Günlük Seri!'**
  String streakDays(Object days);

  /// No description provided for @dailyVerse.
  ///
  /// In tr, this message translates to:
  /// **'Günün Ayeti'**
  String get dailyVerse;

  /// No description provided for @dailyHadith.
  ///
  /// In tr, this message translates to:
  /// **'Günün Hadisi'**
  String get dailyHadith;

  /// No description provided for @dailyDua.
  ///
  /// In tr, this message translates to:
  /// **'Günün Duası'**
  String get dailyDua;

  /// No description provided for @gregorianCalendar.
  ///
  /// In tr, this message translates to:
  /// **'Miladi Takvim'**
  String get gregorianCalendar;

  /// No description provided for @hijriCalendar.
  ///
  /// In tr, this message translates to:
  /// **'Hicri Takvim'**
  String get hijriCalendar;

  /// No description provided for @holyDays.
  ///
  /// In tr, this message translates to:
  /// **'Dini Günler & Geceler'**
  String get holyDays;

  /// No description provided for @todayDetails.
  ///
  /// In tr, this message translates to:
  /// **'Günün Detayları'**
  String get todayDetails;

  /// No description provided for @fastingStatus.
  ///
  /// In tr, this message translates to:
  /// **'Oruç Durumu'**
  String get fastingStatus;

  /// No description provided for @fasted.
  ///
  /// In tr, this message translates to:
  /// **'Oruç Tutuldu'**
  String get fasted;

  /// No description provided for @notFasted.
  ///
  /// In tr, this message translates to:
  /// **'Tutulmadı'**
  String get notFasted;

  /// No description provided for @qiblaDirection.
  ///
  /// In tr, this message translates to:
  /// **'Kıble Yönü'**
  String get qiblaDirection;

  /// No description provided for @qiblaAligned.
  ///
  /// In tr, this message translates to:
  /// **'Kıbleye Yöneldiniz!'**
  String get qiblaAligned;

  /// No description provided for @alignDevice.
  ///
  /// In tr, this message translates to:
  /// **'Cihazı ok yönünde çevirin'**
  String get alignDevice;

  /// No description provided for @angleToMecca.
  ///
  /// In tr, this message translates to:
  /// **'Kâbe Açısı'**
  String get angleToMecca;

  /// No description provided for @distanceToKaaba.
  ///
  /// In tr, this message translates to:
  /// **'Kâbe Uzaklığı'**
  String get distanceToKaaba;

  /// No description provided for @sensorMode.
  ///
  /// In tr, this message translates to:
  /// **'Sensör Moduna Geç'**
  String get sensorMode;

  /// No description provided for @manualMode.
  ///
  /// In tr, this message translates to:
  /// **'Manuel Çevirme Modu'**
  String get manualMode;

  /// No description provided for @enableLocation.
  ///
  /// In tr, this message translates to:
  /// **'Hassas Konum İznini Aç'**
  String get enableLocation;

  /// No description provided for @manualCompassHint.
  ///
  /// In tr, this message translates to:
  /// **'Ekranı parmağınızla sağa/sola kaydırarak pusulayı manuel döndürebilirsiniz.'**
  String get manualCompassHint;

  /// No description provided for @surahs.
  ///
  /// In tr, this message translates to:
  /// **'Sureler'**
  String get surahs;

  /// No description provided for @juz.
  ///
  /// In tr, this message translates to:
  /// **'Cüz'**
  String get juz;

  /// No description provided for @searchSurah.
  ///
  /// In tr, this message translates to:
  /// **'Sure veya Ayet Ara...'**
  String get searchSurah;

  /// No description provided for @lastRead.
  ///
  /// In tr, this message translates to:
  /// **'Kaldığım Yerden Devam Et'**
  String get lastRead;

  /// No description provided for @verse.
  ///
  /// In tr, this message translates to:
  /// **'Ayet'**
  String get verse;

  /// No description provided for @translation.
  ///
  /// In tr, this message translates to:
  /// **'Meal'**
  String get translation;

  /// No description provided for @savedVerses.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilen Ayetler'**
  String get savedVerses;

  /// No description provided for @activeSource.
  ///
  /// In tr, this message translates to:
  /// **'Aktif Kaynak'**
  String get activeSource;

  /// No description provided for @bookmarkSaved.
  ///
  /// In tr, this message translates to:
  /// **'Kaldığınız yer kaydedildi.'**
  String get bookmarkSaved;

  /// No description provided for @createCardFromVerse.
  ///
  /// In tr, this message translates to:
  /// **'Ayetten Kart Oluştur'**
  String get createCardFromVerse;

  /// No description provided for @targetReached.
  ///
  /// In tr, this message translates to:
  /// **'Hedefe Ulaşıldı!'**
  String get targetReached;

  /// No description provided for @reset.
  ///
  /// In tr, this message translates to:
  /// **'Sıfırla'**
  String get reset;

  /// No description provided for @addCustomZikr.
  ///
  /// In tr, this message translates to:
  /// **'Özel Zikir Ekle'**
  String get addCustomZikr;

  /// No description provided for @presetZikrs.
  ///
  /// In tr, this message translates to:
  /// **'Hazır Zikirler'**
  String get presetZikrs;

  /// No description provided for @target.
  ///
  /// In tr, this message translates to:
  /// **'Hedef'**
  String get target;

  /// No description provided for @missedPrayers.
  ///
  /// In tr, this message translates to:
  /// **'Kaza Namazları'**
  String get missedPrayers;

  /// No description provided for @missedFasts.
  ///
  /// In tr, this message translates to:
  /// **'Kaza Oruçları'**
  String get missedFasts;

  /// No description provided for @remaining.
  ///
  /// In tr, this message translates to:
  /// **'Kalan'**
  String get remaining;

  /// No description provided for @completed.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get completed;

  /// No description provided for @theme.
  ///
  /// In tr, this message translates to:
  /// **'Tema Mimarisi'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In tr, this message translates to:
  /// **'Aydınlık Tema'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu Tema'**
  String get themeDark;

  /// No description provided for @themeAmoled.
  ///
  /// In tr, this message translates to:
  /// **'Amoled (Saf Siyah)'**
  String get themeAmoled;

  /// No description provided for @systemDefault.
  ///
  /// In tr, this message translates to:
  /// **'Sistem Varsayılanı'**
  String get systemDefault;

  /// No description provided for @colorPalette.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Renk Paleti'**
  String get colorPalette;

  /// No description provided for @dataSource.
  ///
  /// In tr, this message translates to:
  /// **'Veri Kaynağı'**
  String get dataSource;

  /// No description provided for @language.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Dili'**
  String get language;

  /// No description provided for @vibration.
  ///
  /// In tr, this message translates to:
  /// **'Titreşim Geri Bildirimi'**
  String get vibration;

  /// No description provided for @calculationMethod.
  ///
  /// In tr, this message translates to:
  /// **'Hesaplama Yöntemi'**
  String get calculationMethod;

  /// No description provided for @notifications.
  ///
  /// In tr, this message translates to:
  /// **'Ezan Bildirimleri'**
  String get notifications;

  /// No description provided for @silentMode.
  ///
  /// In tr, this message translates to:
  /// **'Namazda Otomatik Sessize Al'**
  String get silentMode;

  /// No description provided for @checkUpdates.
  ///
  /// In tr, this message translates to:
  /// **'Güncellemeleri Kontrol Et'**
  String get checkUpdates;

  /// No description provided for @rateApp.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamayı Değerlendir'**
  String get rateApp;

  /// No description provided for @version.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm'**
  String get version;

  /// No description provided for @appUpToDate.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamanız Güncel!'**
  String get appUpToDate;

  /// No description provided for @storeReview.
  ///
  /// In tr, this message translates to:
  /// **'Mağaza Yorumu Yaz'**
  String get storeReview;

  /// No description provided for @quickAccess.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı Erişim & Araçlar'**
  String get quickAccess;

  /// No description provided for @todaySummary.
  ///
  /// In tr, this message translates to:
  /// **'Bugünün İbadet Özetim'**
  String get todaySummary;

  /// No description provided for @todayZikr.
  ///
  /// In tr, this message translates to:
  /// **'Bugün Çekilen Zikir'**
  String get todayZikr;

  /// No description provided for @todayQuran.
  ///
  /// In tr, this message translates to:
  /// **'Bugün Okunan Kur\'an'**
  String get todayQuran;

  /// No description provided for @weeklyQuran.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Okunan Kur\'an (Ayet Sayısı)'**
  String get weeklyQuran;

  /// No description provided for @congratsAllPrayers.
  ///
  /// In tr, this message translates to:
  /// **'Tebrikler! Bugün tüm namazlarınızı eda ettiniz.'**
  String get congratsAllPrayers;

  /// No description provided for @markPrayersHint.
  ///
  /// In tr, this message translates to:
  /// **'Namazla bereketlenmek için kılınanları işaretleyin.'**
  String get markPrayersHint;

  /// No description provided for @mark.
  ///
  /// In tr, this message translates to:
  /// **'İşaretle'**
  String get mark;

  /// No description provided for @liveCompass.
  ///
  /// In tr, this message translates to:
  /// **'Canlı Pusula'**
  String get liveCompass;

  /// No description provided for @gregorianHijri.
  ///
  /// In tr, this message translates to:
  /// **'Miladi & Hicri'**
  String get gregorianHijri;

  /// No description provided for @digitalTasbih.
  ///
  /// In tr, this message translates to:
  /// **'Zikirmatik'**
  String get digitalTasbih;

  /// No description provided for @fridayCard.
  ///
  /// In tr, this message translates to:
  /// **'Cuma & Ayet Kartı'**
  String get fridayCard;

  /// No description provided for @monthlyProgress.
  ///
  /// In tr, this message translates to:
  /// **'Aylık İbadet İlerleyişi'**
  String get monthlyProgress;

  /// No description provided for @editGoals.
  ///
  /// In tr, this message translates to:
  /// **'Hedefleri Düzenle'**
  String get editGoals;

  /// No description provided for @monthlyGoals.
  ///
  /// In tr, this message translates to:
  /// **'Aylık Hedefler'**
  String get monthlyGoals;

  /// No description provided for @monthlyZikrGoal.
  ///
  /// In tr, this message translates to:
  /// **'Aylık Zikir Hedefi (Adet)'**
  String get monthlyZikrGoal;

  /// No description provided for @monthlyQuranGoal.
  ///
  /// In tr, this message translates to:
  /// **'Aylık Kur\'an Hedefi (Ayet Sayısı)'**
  String get monthlyQuranGoal;

  /// No description provided for @monthlyFastingGoal.
  ///
  /// In tr, this message translates to:
  /// **'Aylık Oruç Hedefi (Gün)'**
  String get monthlyFastingGoal;

  /// No description provided for @futureDaysWarning.
  ///
  /// In tr, this message translates to:
  /// **'Gelecek günlerin görevleri ve takibi henüz işaretlenemez.'**
  String get futureDaysWarning;

  /// No description provided for @fivePrayerTracker.
  ///
  /// In tr, this message translates to:
  /// **'5 Vakit Namaz Takibi'**
  String get fivePrayerTracker;

  /// No description provided for @zikrCountLabel.
  ///
  /// In tr, this message translates to:
  /// **'Çekilen Zikir Sayısı'**
  String get zikrCountLabel;

  /// No description provided for @quranVersesLabel.
  ///
  /// In tr, this message translates to:
  /// **'Okunan Kur\'an (Ayet Sayısı)'**
  String get quranVersesLabel;

  /// No description provided for @fastedLabel.
  ///
  /// In tr, this message translates to:
  /// **'Oruç Tutuldu'**
  String get fastedLabel;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @todayPrayers.
  ///
  /// In tr, this message translates to:
  /// **'Bugünün İbadetleri'**
  String get todayPrayers;

  /// No description provided for @ramadanMonth.
  ///
  /// In tr, this message translates to:
  /// **'🌙 Mübarek Ramazan Ayı'**
  String get ramadanMonth;

  /// No description provided for @threeMonths.
  ///
  /// In tr, this message translates to:
  /// **'✨ Mübarek Üç Aylar (Recep / Şaban / Ramazan)'**
  String get threeMonths;

  /// No description provided for @holyMonthBadge.
  ///
  /// In tr, this message translates to:
  /// **'✨ Mübarek İslam Ayı'**
  String get holyMonthBadge;

  /// No description provided for @todayZikrStats.
  ///
  /// In tr, this message translates to:
  /// **'Bugünkü Zikir İstatistiğim'**
  String get todayZikrStats;

  /// No description provided for @total.
  ///
  /// In tr, this message translates to:
  /// **'Toplam'**
  String get total;

  /// No description provided for @ramadanStart.
  ///
  /// In tr, this message translates to:
  /// **'Ramazan Başlangıcı'**
  String get ramadanStart;

  /// No description provided for @laylatAlQadr.
  ///
  /// In tr, this message translates to:
  /// **'Kadir Gecesi'**
  String get laylatAlQadr;

  /// No description provided for @eidAlFitr.
  ///
  /// In tr, this message translates to:
  /// **'Ramazan Bayramı 1. Gün'**
  String get eidAlFitr;

  /// No description provided for @eidAlAdha.
  ///
  /// In tr, this message translates to:
  /// **'Kurban Bayramı 1. Gün'**
  String get eidAlAdha;

  /// No description provided for @hijriNewYear.
  ///
  /// In tr, this message translates to:
  /// **'Hicri Yılbaşı'**
  String get hijriNewYear;

  /// No description provided for @dayOfAshura.
  ///
  /// In tr, this message translates to:
  /// **'Aşure Günü'**
  String get dayOfAshura;

  /// No description provided for @mawlid.
  ///
  /// In tr, this message translates to:
  /// **'Mevlid Kandili'**
  String get mawlid;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fa', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
