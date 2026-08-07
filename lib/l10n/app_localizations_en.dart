// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ezan Vakti Premium';

  @override
  String get dashboard => 'Home';

  @override
  String get calendar => 'Calendar';

  @override
  String get qibla => 'Qibla Finder';

  @override
  String get quran => 'Holy Quran';

  @override
  String get tasbih => 'Digital Tasbih';

  @override
  String get kaza => 'Missed Prayers';

  @override
  String get settings => 'Settings';

  @override
  String get cards => 'Card Generator';

  @override
  String get nextPrayer => 'Next Prayer';

  @override
  String get timeRemaining => 'Time Remaining';

  @override
  String get location => 'Location';

  @override
  String get fajr => 'Fajr';

  @override
  String get sunrise => 'Sunrise';

  @override
  String get dhuhr => 'Dhuhr';

  @override
  String get asr => 'Asr';

  @override
  String get maghrib => 'Maghrib';

  @override
  String get isha => 'Isha';

  @override
  String get dailyPrayerRing => 'Daily Prayer Tracker';

  @override
  String prayersCompleted(Object count) {
    return '$count/5 Prayers Completed';
  }

  @override
  String get quranReadingGoal => 'Quran Reading Progress';

  @override
  String quranPagesRead(Object pages) {
    return '$pages Verses Read';
  }

  @override
  String get zikrGoal => 'Zikr Goal';

  @override
  String zikrCount(Object current, Object target) {
    return '$current/$target Zikrs';
  }

  @override
  String streakDays(Object days) {
    return '$days Day Streak!';
  }

  @override
  String get dailyVerse => 'Daily Verse';

  @override
  String get dailyHadith => 'Daily Hadith';

  @override
  String get dailyDua => 'Daily Supplication';

  @override
  String get gregorianCalendar => 'Gregorian Calendar';

  @override
  String get hijriCalendar => 'Hijri Calendar';

  @override
  String get holyDays => 'Islamic Holy Days';

  @override
  String get todayDetails => 'Day Summary';

  @override
  String get fastingStatus => 'Fasting Status';

  @override
  String get fasted => 'Fasted';

  @override
  String get notFasted => 'Not Fasted';

  @override
  String get qiblaDirection => 'Qibla Direction';

  @override
  String get qiblaAligned => 'Facing Qibla!';

  @override
  String get alignDevice => 'Rotate device towards arrow';

  @override
  String get angleToMecca => 'Angle to Kaaba';

  @override
  String get distanceToKaaba => 'Distance to Kaaba';

  @override
  String get sensorMode => 'Switch to Sensor Mode';

  @override
  String get manualMode => 'Manual Rotation Mode';

  @override
  String get enableLocation => 'Enable Precise Location';

  @override
  String get manualCompassHint =>
      'You can manually rotate the compass by dragging left/right.';

  @override
  String get surahs => 'Surahs';

  @override
  String get juz => 'Juz';

  @override
  String get searchSurah => 'Search Surah or Ayah...';

  @override
  String get lastRead => 'Continue Reading';

  @override
  String get verse => 'Verse';

  @override
  String get translation => 'Translation';

  @override
  String get savedVerses => 'Saved Verses';

  @override
  String get activeSource => 'Active Source';

  @override
  String get bookmarkSaved => 'Bookmark saved.';

  @override
  String get createCardFromVerse => 'Create Card from Verse';

  @override
  String get targetReached => 'Target Reached!';

  @override
  String get reset => 'Reset';

  @override
  String get addCustomZikr => 'Add Custom Zikr';

  @override
  String get presetZikrs => 'Preset Zikrs';

  @override
  String get target => 'Target';

  @override
  String get missedPrayers => 'Missed Prayers';

  @override
  String get missedFasts => 'Missed Fasts';

  @override
  String get remaining => 'Remaining';

  @override
  String get completed => 'Completed';

  @override
  String get theme => 'Theme System';

  @override
  String get themeLight => 'Light Mode';

  @override
  String get themeDark => 'Dark Mode';

  @override
  String get themeAmoled => 'Amoled (Pure Black)';

  @override
  String get systemDefault => 'System Default';

  @override
  String get colorPalette => 'App Color Palette';

  @override
  String get dataSource => 'Data Source';

  @override
  String get language => 'App Language';

  @override
  String get vibration => 'Vibration Feedback';

  @override
  String get calculationMethod => 'Calculation Method';

  @override
  String get notifications => 'Adhan Notifications';

  @override
  String get silentMode => 'Auto Mute During Prayer';

  @override
  String get checkUpdates => 'Check for Updates';

  @override
  String get rateApp => 'Rate & Review App';

  @override
  String get version => 'Version';

  @override
  String get appUpToDate => 'Your App is Up to Date!';

  @override
  String get storeReview => 'Write Store Review';

  @override
  String get quickAccess => 'Quick Access & Tools';

  @override
  String get todaySummary => 'Today\'s Worship Summary';

  @override
  String get todayZikr => 'Today\'s Zikr Count';

  @override
  String get todayQuran => 'Today\'s Quran Verses';

  @override
  String get weeklyQuran => 'Weekly Quran Reading (Verses)';

  @override
  String get congratsAllPrayers =>
      'Congratulations! You completed all prayers today.';

  @override
  String get markPrayersHint => 'Check off performed prayers for blessing.';

  @override
  String get mark => 'Check';

  @override
  String get liveCompass => 'Live Compass';

  @override
  String get gregorianHijri => 'Gregorian & Hijri';

  @override
  String get digitalTasbih => 'Digital Tasbih';

  @override
  String get fridayCard => 'Friday & Verse Card';

  @override
  String get monthlyProgress => 'Monthly Worship Progress';

  @override
  String get editGoals => 'Edit Goals';

  @override
  String get monthlyGoals => 'Monthly Goals';

  @override
  String get monthlyZikrGoal => 'Monthly Zikr Target (Count)';

  @override
  String get monthlyQuranGoal => 'Monthly Quran Target (Verses)';

  @override
  String get monthlyFastingGoal => 'Monthly Fasting Target (Days)';

  @override
  String get futureDaysWarning =>
      'Tasks for future dates cannot be marked yet.';

  @override
  String get fivePrayerTracker => '5 Daily Prayers Tracker';

  @override
  String get zikrCountLabel => 'Zikr Count';

  @override
  String get quranVersesLabel => 'Quran Verses Read';

  @override
  String get fastedLabel => 'Fasted';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get todayPrayers => 'Today\'s Worship';

  @override
  String get ramadanMonth => '🌙 Blessed Month of Ramadan';

  @override
  String get threeMonths =>
      '✨ Three Sacred Months (Rajab / Sha\'ban / Ramadan)';

  @override
  String get holyMonthBadge => '✨ Blessed Islamic Month';

  @override
  String get todayZikrStats => 'Today\'s Zikr Statistics';

  @override
  String get total => 'Total';

  @override
  String get ramadanStart => 'Beginning of Ramadan';

  @override
  String get laylatAlQadr => 'Laylat al-Qadr (Night of Power)';

  @override
  String get eidAlFitr => 'Eid al-Fitr (Day 1)';

  @override
  String get eidAlAdha => 'Eid al-Adha (Day 1)';

  @override
  String get hijriNewYear => 'Islamic New Year (1st Muharram)';

  @override
  String get dayOfAshura => 'Day of Ashura (10th Muharram)';

  @override
  String get mawlid => 'Mawlid an-Nabi (Prophet\'s Birthday)';
}
