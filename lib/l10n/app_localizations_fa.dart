// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'اذان گو و دستیار عبادی پرمیوم';

  @override
  String get dashboard => 'صفحه اصلی';

  @override
  String get calendar => 'تقویم هجری';

  @override
  String get qibla => 'قبلە نما';

  @override
  String get quran => 'قرآن کریم';

  @override
  String get tasbih => 'ذکرشمار';

  @override
  String get kaza => 'پیگیری قضایی';

  @override
  String get settings => 'تنظیمات';

  @override
  String get cards => 'کارت‌ساز مناسبتی';

  @override
  String get nextPrayer => 'نماز بعدی';

  @override
  String get timeRemaining => 'زمان باقی‌مانده';

  @override
  String get location => 'موقعیت مکانی';

  @override
  String get fajr => 'اذان صبح';

  @override
  String get sunrise => 'طلوع آفتاب';

  @override
  String get dhuhr => 'اذان ظهر';

  @override
  String get asr => 'عصر';

  @override
  String get maghrib => 'اذان مغرب';

  @override
  String get isha => 'عشاء';

  @override
  String get dailyPrayerRing => 'پیگیری نمازهای روزانه';

  @override
  String prayersCompleted(Object count) {
    return '$count/5 نماز خوانده شد';
  }

  @override
  String get quranReadingGoal => 'پیشرفت قرائت قرآن';

  @override
  String quranPagesRead(Object pages) {
    return '$pages آیه خوانده شد';
  }

  @override
  String get zikrGoal => 'هدف ذکر روزانه';

  @override
  String zikrCount(Object current, Object target) {
    return '$current/$target ذکر';
  }

  @override
  String streakDays(Object days) {
    return '$days روز مداومت!';
  }

  @override
  String get dailyVerse => 'آیه روز';

  @override
  String get dailyHadith => 'حدیث روز';

  @override
  String get dailyDua => 'دعای روز';

  @override
  String get gregorianCalendar => 'تقویم میلادی';

  @override
  String get hijriCalendar => 'تقویم هجری قمری';

  @override
  String get holyDays => 'مناسبت‌ها و اعیاد اسلامی';

  @override
  String get todayDetails => 'جزئیات امروز';

  @override
  String get fastingStatus => 'وضعیت روزه';

  @override
  String get fasted => 'روزه گرفته شد';

  @override
  String get notFasted => 'روزه گرفته نشد';

  @override
  String get qiblaDirection => 'جهت قبله';

  @override
  String get qiblaAligned => 'شما دقیقا رو به قبله هستید!';

  @override
  String get alignDevice => 'دستگاه را به سمت فلش بچرخانید';

  @override
  String get angleToMecca => 'زاویه کعبه';

  @override
  String get distanceToKaaba => 'فاصله تا کعبه';

  @override
  String get sensorMode => 'حالت سنسور خودکار';

  @override
  String get manualMode => 'حالت دستی';

  @override
  String get enableLocation => 'فعال‌سازی دسترسی مکان';

  @override
  String get manualCompassHint =>
      'می‌توانید قطب‌نما را با کشیدن به چپ/راست بچرخانید.';

  @override
  String get surahs => 'سوره‌ها';

  @override
  String get juz => 'جزءها';

  @override
  String get searchSurah => 'جستجوی سوره یا آیه...';

  @override
  String get lastRead => 'ادامه از آخرین مطالعه';

  @override
  String get verse => 'آیه';

  @override
  String get translation => 'ترجمه و تفسیر';

  @override
  String get savedVerses => 'آیه‌های ذخیره‌شده';

  @override
  String get activeSource => 'منبع فعال';

  @override
  String get bookmarkSaved => 'علامت‌گذاری ذخیره شد.';

  @override
  String get createCardFromVerse => 'ساخت کارت از آیه';

  @override
  String get targetReached => 'به هدف رسیدید!';

  @override
  String get reset => 'بازنشانی';

  @override
  String get addCustomZikr => 'افزودن ذکر دلخواه';

  @override
  String get presetZikrs => 'ذکرهای آماده';

  @override
  String get target => 'هدف';

  @override
  String get missedPrayers => 'نمازهای قضا';

  @override
  String get missedFasts => 'روزه‌های قضا';

  @override
  String get remaining => 'باقی‌مانده';

  @override
  String get completed => 'انجام‌شده';

  @override
  String get theme => 'سیستم پوسته';

  @override
  String get themeLight => 'پوسته روشن';

  @override
  String get themeDark => 'پوسته تاریک';

  @override
  String get themeAmoled => 'آمولد (مشکی خالص)';

  @override
  String get systemDefault => 'پیش‌فرض سیستم';

  @override
  String get colorPalette => 'پالت رنگی برنامه';

  @override
  String get dataSource => 'منبع داده‌ها';

  @override
  String get language => 'زبان برنامه';

  @override
  String get vibration => 'بازخورد لرزشی';

  @override
  String get calculationMethod => 'روش محاسباتی اذان';

  @override
  String get notifications => 'هشدار و اعلان اذان';

  @override
  String get silentMode => 'بی‌صدا کردن خودکار هنگام نماز';

  @override
  String get checkUpdates => 'بررسی به‌روزرسانی';

  @override
  String get rateApp => 'امتیاز به برنامه';

  @override
  String get version => 'نسخه';

  @override
  String get appUpToDate => 'برنامه شما به‌روز است!';

  @override
  String get storeReview => 'ثبت نظر در فروشگاه';

  @override
  String get quickAccess => 'دسترسی سریع و ابزارها';

  @override
  String get todaySummary => 'خلاصه عبادات امروز';

  @override
  String get todayZikr => 'ذکرهای امروز';

  @override
  String get todayQuran => 'آیه‌های امروز قرآن';

  @override
  String get weeklyQuran => 'قرائت هفتگی (تعداد آیه)';

  @override
  String get congratsAllPrayers => 'تبریک! تمام نمازهای امروز را خواندید.';

  @override
  String get markPrayersHint => 'نمازهای خوانده شده را علامت بزنید.';

  @override
  String get mark => 'علامت‌گذاری';

  @override
  String get liveCompass => 'قبلە‌نمای زنده';

  @override
  String get gregorianHijri => 'میلادی و هجری';

  @override
  String get digitalTasbih => 'ذکرشمار دیجیتال';

  @override
  String get fridayCard => 'کارت جمعه و آیه';

  @override
  String get monthlyProgress => 'پیشرفت ماهانه عبادات';

  @override
  String get editGoals => 'ویرایش هدف‌ها';

  @override
  String get monthlyGoals => 'هدف‌های ماهانه';

  @override
  String get monthlyZikrGoal => 'هدف ماهانه ذکر (تعداد)';

  @override
  String get monthlyQuranGoal => 'هدف ماهانه قرآن (تعداد آیه)';

  @override
  String get monthlyFastingGoal => 'هدف ماهانه روزه (روز)';

  @override
  String get futureDaysWarning => 'وظایف روزهای آینده هنوز قابل ثبت نیستند.';

  @override
  String get fivePrayerTracker => 'پیگیری نمازهای پنج‌گانه';

  @override
  String get zikrCountLabel => 'تعداد ذکرها';

  @override
  String get quranVersesLabel => 'آیه‌های خوانده شده';

  @override
  String get fastedLabel => 'روزه گرفته شد';

  @override
  String get cancel => 'لغو';

  @override
  String get save => 'ذخیره';

  @override
  String get todayPrayers => 'عبادتهای امروز';

  @override
  String get ramadanMonth => '🌙 ماه مبارک رمضان';

  @override
  String get threeMonths => '✨ ماه‌های مبارک رجب، شعبان و رمضان';

  @override
  String get holyMonthBadge => '✨ ماه مبارک اسلامی';

  @override
  String get todayZikrStats => 'آمار ذکرهای امروز';

  @override
  String get total => 'مجموع';

  @override
  String get ramadanStart => 'آغاز ماه مبارک رمضان';

  @override
  String get laylatAlQadr => 'شب قدر';

  @override
  String get eidAlFitr => 'عید سعید فطر (روز ۱)';

  @override
  String get eidAlAdha => 'عید سعید قربان (روز ۱)';

  @override
  String get hijriNewYear => 'آغاز سال جدید هجری';

  @override
  String get dayOfAshura => 'روز عاشورا (۱۰ محرم)';

  @override
  String get mawlid => 'میلاد پیامبر اکرم (ص)';
}
