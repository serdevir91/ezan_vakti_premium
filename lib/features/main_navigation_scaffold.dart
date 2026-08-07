import 'package:flutter/material.dart';
import 'package:ezan_vakti_premium/l10n/app_localizations.dart';
import 'dashboard/presentation/dashboard_screen.dart';
import 'calendar/presentation/calendar_screen.dart';
import 'qibla/presentation/qibla_screen.dart';
import 'quran/presentation/quran_screen.dart';
import 'tasbih/presentation/tasbih_screen.dart';
import 'kaza/presentation/kaza_screen.dart';
import 'cards/presentation/card_creator_screen.dart';
import '../core/theme/app_colors.dart';

class MainNavigationScaffold extends StatefulWidget {
  const MainNavigationScaffold({super.key});

  @override
  State<MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<Widget> pages = [
      DashboardScreen(
        onNavigateTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      const QuranScreen(),
      const TasbihScreen(),
      const CalendarScreen(),
      QiblaScreen(isActive: _currentIndex == 4),
      const CardCreatorScreen(),
      const KazaScreen(),
    ];

    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex > 3 ? 0 : _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          indicatorColor: AppColors.emeraldPrimary.withValues(alpha: 0.2),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home, color: AppColors.emeraldPrimary),
              label: l10n.dashboard,
            ),
            NavigationDestination(
              icon: const Icon(Icons.menu_book_outlined),
              selectedIcon: const Icon(Icons.menu_book, color: AppColors.emeraldPrimary),
              label: l10n.quran,
            ),
            NavigationDestination(
              icon: const Icon(Icons.fingerprint_outlined),
              selectedIcon: const Icon(Icons.fingerprint, color: AppColors.emeraldPrimary),
              label: l10n.tasbih,
            ),
            NavigationDestination(
              icon: const Icon(Icons.calendar_month_outlined),
              selectedIcon: const Icon(Icons.calendar_month, color: AppColors.emeraldPrimary),
              label: l10n.calendar,
            ),
          ],
        ),
      ),
    );
  }
}
