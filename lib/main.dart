import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ezan_vakti_premium/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/cubits/theme_cubit.dart';
import 'core/cubits/locale_cubit.dart';
import 'core/cubits/prayer_cubit.dart';
import 'core/services/prayer_time_service.dart';
import 'core/services/permission_service.dart';
import 'core/services/adhan_notification_service.dart';
import 'features/main_navigation_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PermissionService.requestInitialPermissions();
  await AdhanNotificationService().initialize();
  runApp(const EzanVaktiApp());
}

class EzanVaktiApp extends StatelessWidget {
  const EzanVaktiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(
          create: (_) => PrayerCubit(PrayerTimeService())..loadPrayerTimes(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              ThemeData currentTheme;
              if (themeState.isAmoled) {
                currentTheme = AppTheme.getAmoledTheme(themeState.palette);
              } else if (themeState.themeMode == ThemeMode.light) {
                currentTheme = AppTheme.getLightTheme(themeState.palette);
              } else if (themeState.themeMode == ThemeMode.dark) {
                currentTheme = AppTheme.getDarkTheme(themeState.palette);
              } else {
                final isDarkMode = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
                currentTheme = isDarkMode
                    ? AppTheme.getDarkTheme(themeState.palette)
                    : AppTheme.getLightTheme(themeState.palette);
              }

              return MaterialApp(
                title: 'Ezan Vakti Premium',
                debugShowCheckedModeBanner: false,
                theme: currentTheme,
                darkTheme: themeState.isAmoled
                    ? AppTheme.getAmoledTheme(themeState.palette)
                    : AppTheme.getDarkTheme(themeState.palette),
                themeMode: themeState.themeMode,
                locale: locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('tr'),
                  Locale('en'),
                  Locale('ar'),
                  Locale('fa'),
                ],
                home: const MainNavigationScaffold(),
              );
            },
          );
        },
      ),
    );
  }
}
