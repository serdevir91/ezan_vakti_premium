// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'أوقات الصلاة بريميوم';

  @override
  String get dashboard => 'الرئيسية';

  @override
  String get calendar => 'التقويم الهجري';

  @override
  String get qibla => 'بوصلة القبلة';

  @override
  String get quran => 'القرآن الكريم';

  @override
  String get tasbih => 'السبحة الإلكترونية';

  @override
  String get kaza => 'متابعة القضاء';

  @override
  String get settings => 'الإعدادات';

  @override
  String get cards => 'صانع البطاقات';

  @override
  String get nextPrayer => 'الصلاة القادمة';

  @override
  String get timeRemaining => 'الوقت المتبقي';

  @override
  String get location => 'الموقع';

  @override
  String get fajr => 'الفجر';

  @override
  String get sunrise => 'الشروق';

  @override
  String get dhuhr => 'الظهر';

  @override
  String get asr => 'العصر';

  @override
  String get maghrib => 'المغرب';

  @override
  String get isha => 'العشاء';

  @override
  String get dailyPrayerRing => 'متابعة الصلوات اليومية';

  @override
  String prayersCompleted(Object count) {
    return 'تم أداء $count/5 صلوات';
  }

  @override
  String get quranReadingGoal => 'تقدم تلاوة القرآن';

  @override
  String quranPagesRead(Object pages) {
    return 'تم قراءة $pages آية';
  }

  @override
  String get zikrGoal => 'هدف الأذكار';

  @override
  String zikrCount(Object current, Object target) {
    return '$current/$target ذكر';
  }

  @override
  String streakDays(Object days) {
    return 'سلسلة متواصلة $days يوم!';
  }

  @override
  String get dailyVerse => 'آية اليوم';

  @override
  String get dailyHadith => 'حديث اليوم';

  @override
  String get dailyDua => 'دعاء اليوم';

  @override
  String get gregorianCalendar => 'التقويم الميلادي';

  @override
  String get hijriCalendar => 'التقويم الهجري';

  @override
  String get holyDays => 'المناسبات والأعياد الإسلامية';

  @override
  String get todayDetails => 'تفاصيل اليوم';

  @override
  String get fastingStatus => 'حالة الصيام';

  @override
  String get fasted => 'تم الصيام';

  @override
  String get notFasted => 'لم يتم الصيام';

  @override
  String get qiblaDirection => 'اتجاه القبلة';

  @override
  String get qiblaAligned => 'أنت تتجه نحو القبلة!';

  @override
  String get alignDevice => 'أدر الجهاز باتجاه السهم';

  @override
  String get angleToMecca => 'زاوية الكعبة';

  @override
  String get distanceToKaaba => 'المسافة إلى الكعبة';

  @override
  String get sensorMode => 'الوضع التلقائي (المستشعر)';

  @override
  String get manualMode => 'الوضع اليدوي';

  @override
  String get enableLocation => 'تفعيل إذن الموقع';

  @override
  String get manualCompassHint =>
      'يمكنك تدوير البوصلة يدوياً عن طريق السحب يميناً أو يساراً.';

  @override
  String get surahs => 'السور';

  @override
  String get juz => 'الأجزاء';

  @override
  String get searchSurah => 'ابحث عن سورة أو آية...';

  @override
  String get lastRead => 'متابعة القراءة من حيث توقفت';

  @override
  String get verse => 'الآية';

  @override
  String get translation => 'التفسير / الترجمة';

  @override
  String get savedVerses => 'الآيات المحفوظة';

  @override
  String get activeSource => 'المصدر النشط';

  @override
  String get bookmarkSaved => 'تم حفظ الإشارة المرجعية.';

  @override
  String get createCardFromVerse => 'إنشاء بطاقة من الآية';

  @override
  String get targetReached => 'تم الوصول إلى الهدف!';

  @override
  String get reset => 'إعادة ضبط';

  @override
  String get addCustomZikr => 'إضافة ذكر خاص';

  @override
  String get presetZikrs => 'الأذكار الجاهزة';

  @override
  String get target => 'الهدف';

  @override
  String get missedPrayers => 'الصلوات الفائتة';

  @override
  String get missedFasts => 'أيام الصيام الفائتة';

  @override
  String get remaining => 'المتبقي';

  @override
  String get completed => 'المكتمل';

  @override
  String get theme => 'نظام المظهر';

  @override
  String get themeLight => 'المظهر الفاتح';

  @override
  String get themeDark => 'المظهر الداكن';

  @override
  String get themeAmoled => 'أموليد (أسود خالص)';

  @override
  String get systemDefault => 'الافتراضي للنظام';

  @override
  String get colorPalette => 'لوحة ألوان التطبيق';

  @override
  String get dataSource => 'مصدر البيانات';

  @override
  String get language => 'لغة التطبيق';

  @override
  String get vibration => 'اهتزاز اللمس';

  @override
  String get calculationMethod => 'طريقة حساب المواقيت';

  @override
  String get notifications => 'تنبيهات الأذان';

  @override
  String get silentMode => 'وضع الصامت التلقائي أثناء الصلاة';

  @override
  String get checkUpdates => 'التحقق من التحديثات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get version => 'الإصدار';

  @override
  String get appUpToDate => 'تطبيقك محدث لأحدث إصدار!';

  @override
  String get storeReview => 'كتابة مراجعة في المتجر';

  @override
  String get quickAccess => 'وصول سريع وأدوات';

  @override
  String get todaySummary => 'ملخص عبادات اليوم';

  @override
  String get todayZikr => 'أذكار اليوم';

  @override
  String get todayQuran => 'آيات القرآن اليوم';

  @override
  String get weeklyQuran => 'تلاوة الأسبوع (عدد الآيات)';

  @override
  String get congratsAllPrayers => 'مبارك! لقد أديت جميع الصلوات اليوم.';

  @override
  String get markPrayersHint => 'حدد الصلوات التي قمت بأدائها.';

  @override
  String get mark => 'تحديد';

  @override
  String get liveCompass => 'بوصلة مباشرة';

  @override
  String get gregorianHijri => 'ميلادي وهجري';

  @override
  String get digitalTasbih => 'سبحة إلكترونية';

  @override
  String get fridayCard => 'بطاقة الجمعة والآيات';

  @override
  String get monthlyProgress => 'تقدم العبادات الشهري';

  @override
  String get editGoals => 'تعديل الأهداف';

  @override
  String get monthlyGoals => 'الأهداف الشهرية';

  @override
  String get monthlyZikrGoal => 'هدف الأذكار الشهري (عدد)';

  @override
  String get monthlyQuranGoal => 'هدف القرآن الشهري (عدد الآيات)';

  @override
  String get monthlyFastingGoal => 'هدف الصيام الشهري (أيام)';

  @override
  String get futureDaysWarning => 'لا يمكن تحديد مهام الأيام القادمة بعد.';

  @override
  String get fivePrayerTracker => 'متابعة الصلوات الخمس';

  @override
  String get zikrCountLabel => 'عدد الأذكار';

  @override
  String get quranVersesLabel => 'آيات القرآن المتلوة';

  @override
  String get fastedLabel => 'صائم';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get todayPrayers => 'عبادات اليوم';

  @override
  String get ramadanMonth => '🌙 شهر رمضان المبارك';

  @override
  String get threeMonths => '✨ الأشهر الحرم والأشهر المباركة';

  @override
  String get holyMonthBadge => '✨ شهر إسلامي مبارك';

  @override
  String get todayZikrStats => 'إحصائيات أذكار اليوم';

  @override
  String get total => 'المجموع';

  @override
  String get ramadanStart => 'بداية شهر رمضان';

  @override
  String get laylatAlQadr => 'ليلة القدر المباركة';

  @override
  String get eidAlFitr => 'عيد الفطر المبارك (اليوم 1)';

  @override
  String get eidAlAdha => 'عيد الأضحى المبارك (اليوم 1)';

  @override
  String get hijriNewYear => 'رأس السنة الهجرية';

  @override
  String get dayOfAshura => 'يوم عاشوراء (10 محرم)';

  @override
  String get mawlid => 'المولد النبوي الشريف';
}
