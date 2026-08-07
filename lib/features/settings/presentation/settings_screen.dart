import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ezan_vakti_premium/l10n/app_localizations.dart';
import '../../../core/cubits/theme_cubit.dart';
import '../../../core/cubits/locale_cubit.dart';
import '../../../core/services/quran_repository.dart';
import '../../../core/services/update_service.dart';
import '../../../core/services/review_service.dart';
import '../../../core/services/adhan_notification_service.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final QuranRepository _quranRepo = QuranRepository();
  final UpdateService _updateService = UpdateService();
  final ReviewService _reviewService = ReviewService();

  final AdhanNotificationService _adhanNotifyService = AdhanNotificationService();

  QuranProvider _selectedProvider = QuranProvider.fawazAhmed;
  bool _vibrationEnabled = true;
  bool _autoSilent = false;
  bool _notificationsEnabled = true;
  bool _adhanSoundEnabled = true;
  String _calcMethod = "Diyanet İşleri Başkanlığı";

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final provider = await _quranRepo.getSelectedProvider();
    final prefs = await SharedPreferences.getInstance();
    final notifOn = await _adhanNotifyService.isNotificationsEnabled();
    final soundOn = await _adhanNotifyService.isAdhanSoundEnabled();

    if (mounted) {
      setState(() {
        _selectedProvider = provider;
        _vibrationEnabled = prefs.getBool('pref_vibration_enabled') ?? true;
        _autoSilent = prefs.getBool('pref_auto_silent') ?? false;
        _notificationsEnabled = notifOn;
        _adhanSoundEnabled = soundOn;
        _calcMethod = prefs.getString('pref_calc_method') ?? "Diyanet İşleri Başkanlığı";
      });
    }
  }

  void _setQuranProvider(QuranProvider provider) async {
    await _quranRepo.setSelectedProvider(provider);
    setState(() {
      _selectedProvider = provider;
    });
  }

  void _setVibration(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pref_vibration_enabled', enabled);
    setState(() {
      _vibrationEnabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final themeState = context.watch<ThemeCubit>().state;
    final primaryColor = AppColors.getPrimary(themeState.palette);
    final accentColor = AppColors.getAccent(themeState.palette);
    final secondaryColor = AppColors.getSecondary(themeState.palette);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Ultra-Modern Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, accentColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.settings_suggest_rounded, color: secondaryColor, size: 32),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.appTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${l10n.version} 1.0.13+14 • ${locale.languageCode.toUpperCase()}",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. Application Color Palette Section (6 Dynamic Color Cards Grid)
            _buildSectionTitle(context, l10n.colorPalette, Icons.palette_outlined, primaryColor),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.2,
              children: [
                _buildPaletteCard(
                  context,
                  palette: AppColorPalette.emerald,
                  title: "Zümrüt & Altın",
                  primary: AppColors.getPrimary(AppColorPalette.emerald),
                  accent: AppColors.getAccent(AppColorPalette.emerald),
                  currentPalette: themeState.palette,
                ),
                _buildPaletteCard(
                  context,
                  palette: AppColorPalette.goldBlack,
                  title: "Altın & Saf Siyah",
                  primary: AppColors.getPrimary(AppColorPalette.goldBlack),
                  accent: AppColors.getAccent(AppColorPalette.goldBlack),
                  currentPalette: themeState.palette,
                ),
                _buildPaletteCard(
                  context,
                  palette: AppColorPalette.sapphire,
                  title: "Safir Mavi",
                  primary: AppColors.getPrimary(AppColorPalette.sapphire),
                  accent: AppColors.getAccent(AppColorPalette.sapphire),
                  currentPalette: themeState.palette,
                ),
                _buildPaletteCard(
                  context,
                  palette: AppColorPalette.ruby,
                  title: "Yakut Kırmızı",
                  primary: AppColors.getPrimary(AppColorPalette.ruby),
                  accent: AppColors.getAccent(AppColorPalette.ruby),
                  currentPalette: themeState.palette,
                ),
                _buildPaletteCard(
                  context,
                  palette: AppColorPalette.purple,
                  title: "Gece Moru",
                  primary: AppColors.getPrimary(AppColorPalette.purple),
                  accent: AppColors.getAccent(AppColorPalette.purple),
                  currentPalette: themeState.palette,
                ),
                _buildPaletteCard(
                  context,
                  palette: AppColorPalette.turquoise,
                  title: "Turkuaz & Gümüş",
                  primary: AppColors.getPrimary(AppColorPalette.turquoise),
                  accent: AppColors.getAccent(AppColorPalette.turquoise),
                  currentPalette: themeState.palette,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 3. Theme Mode & Display Options
            _buildSectionTitle(context, l10n.theme, Icons.dark_mode_outlined, primaryColor),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    secondary: _buildIconBadge(Icons.dark_mode, primaryColor),
                    title: Text(l10n.themeDark, style: const TextStyle(fontWeight: FontWeight.w600)),
                    value: themeState.themeMode == ThemeMode.dark,
                    activeTrackColor: primaryColor,
                    onChanged: (val) => context.read<ThemeCubit>().setThemeMode(val ? ThemeMode.dark : ThemeMode.light),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile.adaptive(
                    secondary: _buildIconBadge(Icons.contrast, primaryColor),
                    title: Text(l10n.themeAmoled, style: const TextStyle(fontWeight: FontWeight.w600)),
                    value: themeState.isAmoled,
                    activeTrackColor: primaryColor,
                    onChanged: (val) => context.read<ThemeCubit>().toggleAmoled(val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4. Language Selector Section
            _buildSectionTitle(context, l10n.language, Icons.language_outlined, primaryColor),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  _buildLanguageOptionTile(context, "Türkçe (TR)", "tr", locale.languageCode, "🇹🇷"),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildLanguageOptionTile(context, "English (US)", "en", locale.languageCode, "🇺🇸"),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildLanguageOptionTile(context, "العربية (AR) - RTL", "ar", locale.languageCode, "🇸🇦"),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildLanguageOptionTile(context, "فارسی (FA) - RTL", "fa", locale.languageCode, "🇮🇷"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5. Quran Data Source Selection
            _buildSectionTitle(context, l10n.quran, Icons.cloud_download_outlined, primaryColor),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildIconBadge(Icons.cloud_done, primaryColor),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.dataSource, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(
                              _selectedProvider == QuranProvider.fawazAhmed
                                  ? "Fawaz Ahmed CDN"
                                  : _selectedProvider == QuranProvider.alQuranCloud
                                      ? "AlQuran Cloud API"
                                      : "Çevrimdışı (Local)",
                              style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    DropdownButton<QuranProvider>(
                      value: _selectedProvider,
                      underline: const SizedBox(),
                      borderRadius: BorderRadius.circular(16),
                      items: const [
                        DropdownMenuItem(value: QuranProvider.fawazAhmed, child: Text('Fawaz Ahmed')),
                        DropdownMenuItem(value: QuranProvider.alQuranCloud, child: Text('AlQuran Cloud')),
                        DropdownMenuItem(value: QuranProvider.local, child: Text('Çevrimdışı')),
                      ],
                      onChanged: (val) => val != null ? _setQuranProvider(val) : null,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 6. Vibration & Notifications
            _buildSectionTitle(context, l10n.notifications, Icons.notifications_active_outlined, primaryColor),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    secondary: _buildIconBadge(Icons.alarm_on, primaryColor),
                    title: const Text("Ezan Vakti Alarmları", style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text("Vakit geldiğinde bildirim ve ezan alarmı calar", style: TextStyle(fontSize: 11)),
                    value: _notificationsEnabled,
                    activeTrackColor: primaryColor,
                    onChanged: (val) async {
                      await _adhanNotifyService.setNotificationsEnabled(val);
                      setState(() {
                        _notificationsEnabled = val;
                      });
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile.adaptive(
                    secondary: _buildIconBadge(Icons.volume_up, primaryColor),
                    title: const Text("Ezan Sesi İle Uyar", style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text("Alarmlarda ezan ses efekti dinletilir", style: TextStyle(fontSize: 11)),
                    value: _adhanSoundEnabled,
                    activeTrackColor: primaryColor,
                    onChanged: _notificationsEnabled
                        ? (val) async {
                            await _adhanNotifyService.setAdhanSoundEnabled(val);
                            setState(() {
                              _adhanSoundEnabled = val;
                            });
                          }
                        : null,
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile.adaptive(
                    secondary: _buildIconBadge(Icons.vibration, primaryColor),
                    title: Text(l10n.vibration, style: const TextStyle(fontWeight: FontWeight.w600)),
                    value: _vibrationEnabled,
                    activeTrackColor: primaryColor,
                    onChanged: _setVibration,
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: _buildIconBadge(Icons.calculate, primaryColor),
                    title: Text(l10n.calculationMethod, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(_calcMethod, style: const TextStyle(fontSize: 11)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile.adaptive(
                    secondary: _buildIconBadge(Icons.volume_off, primaryColor),
                    title: Text(l10n.silentMode, style: const TextStyle(fontWeight: FontWeight.w600)),
                    value: _autoSilent,
                    activeTrackColor: primaryColor,
                    onChanged: (val) async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('pref_auto_silent', val);
                      setState(() {
                        _autoSilent = val;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 7. Update & Store Review Action Card
            _buildSectionTitle(context, l10n.checkUpdates, Icons.system_update_outlined, primaryColor),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: _buildIconBadge(Icons.system_update, primaryColor),
                    title: Text(l10n.checkUpdates, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text("Sürüm 1.0.13+14"),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        final info = await _updateService.checkAppUpdate();
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              title: Text(l10n.appUpToDate),
                              content: Text("Mevcut Sürüm: v${info.version}+${info.buildNumber}"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Tamam"),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: const Text("Kontrol Et"),
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: _buildIconBadge(Icons.star, primaryColor),
                    title: Text(l10n.rateApp, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(l10n.storeReview, style: const TextStyle(fontSize: 11)),
                    trailing: const Icon(Icons.open_in_new, size: 16),
                    onTap: () {
                      _reviewService.requestInAppReview(isManualTrigger: true);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildIconBadge(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildPaletteCard(
    BuildContext context, {
    required AppColorPalette palette,
    required String title,
    required Color primary,
    required Color accent,
    required AppColorPalette currentPalette,
  }) {
    final isSelected = palette == currentPalette;
    return GestureDetector(
      onTap: () {
        context.read<ThemeCubit>().setPalette(palette);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primary : Colors.grey.withValues(alpha: 0.2),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [primary, accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? primary : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOptionTile(BuildContext context, String title, String code, String currentCode, String flag) {
    final isSelected = code == currentCode;
    final primaryColor = Theme.of(context).primaryColor;

    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 22)),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? primaryColor : null,
          fontSize: 13,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: primaryColor)
          : const Icon(Icons.circle_outlined, color: Colors.grey, size: 18),
      onTap: () => context.read<LocaleCubit>().changeLocale(code),
    );
  }
}
