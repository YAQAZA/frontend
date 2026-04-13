import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class SessionBottomNav extends StatelessWidget {
  const SessionBottomNav({super.key, required this.selectedIndex, this.onTap});

  final int selectedIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelSmall;
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
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
