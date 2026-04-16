import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class SessionBottomNav extends StatelessWidget {
  const SessionBottomNav({super.key, required this.selectedIndex});

  final int selectedIndex;

  static const List<String> _screens = [
        AppRoutes.sessionStart,
        AppRoutes.sessionsHistory,
        AppRoutes.stats,
        AppRoutes.profile,
      ];

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelSmall;
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        if (index != selectedIndex) {
          Navigator.pushNamed(context, _screens[index]);
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.backgroundLight,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.textMedium,
      selectedLabelStyle: labelStyle,
      unselectedLabelStyle: labelStyle,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: AppStrings.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time_outlined),
          label: AppStrings.sessionTab,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          label: AppStrings.stats,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: AppStrings.profileTab,
        ),
      ],
    );
  }
}

class SessionHistory extends StatelessWidget {
  const SessionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Session History'),
    );
  }
}

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Stats Screen'),
    );
  }
}
