import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/size_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paddingH = SizeHelper.screenPaddingHorizontal(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        title: Text(
          AppStrings.settingsTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: paddingH),
        child: Column(
          children: [
            SizedBox(height: AppValues.spacingMedium),
            _buildMenuItem(
              context,
              icon: Icons.notifications_outlined,
              label: AppStrings.notifications,
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Icons.lock_outline,
              label: AppStrings.privacy,
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Icons.help_outline,
              label: AppStrings.helpSupport,
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Icons.info_outline,
              label: AppStrings.about,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: AppColors.primaryColor,
        size: AppValues.iconSizeMedium,
      ),
      title: Text(
        label,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: AppColors.textDark,
          fontSize: AppValues.bodyFontSize,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMedium),
      onTap: onTap,
    );
  }
}
