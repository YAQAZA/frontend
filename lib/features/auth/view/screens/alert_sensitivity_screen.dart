import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widget/core_widgets.dart';

class AlertSensitivityScreen extends StatefulWidget {
  const AlertSensitivityScreen({super.key});

  @override
  State<AlertSensitivityScreen> createState() => _AlertSensitivityScreenState();
}

class _AlertSensitivityScreenState extends State<AlertSensitivityScreen> {
  bool _soundAlerts = true;
  bool _vibration = true;
  bool _visualFlashes = false;
  double _volume = 0.7;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.textWhite,
        title: const Text(AppStrings.alertSensitivityTitle),
        actions: [
          TextButton(
            onPressed: _reset,
            child: const Text(
              AppStrings.reset,
              style: TextStyle(color: AppColors.textWhite),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppValues.screenPaddingHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.alertMethods,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: AppValues.spacingMedium),
            _buildToggleRow(
              icon: Icons.volume_up_outlined,
              label: AppStrings.soundAlerts,
              value: _soundAlerts,
              onChanged: (value) => setState(() => _soundAlerts = value),
            ),
            _buildToggleRow(
              icon: Icons.vibration,
              label: AppStrings.vibration,
              value: _vibration,
              onChanged: (value) => setState(() => _vibration = value),
            ),
            _buildToggleRow(
              icon: Icons.flash_on_outlined,
              label: AppStrings.visualFlashes,
              value: _visualFlashes,
              onChanged: (value) => setState(() => _visualFlashes = value),
            ),
            SizedBox(height: AppValues.spacingXLarge),
            Text(
              AppStrings.alertVolume,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            Slider(
              value: _volume,
              onChanged: (value) => setState(() => _volume = value),
              activeColor: AppColors.primaryColor,
            ),
            SizedBox(height: AppValues.spacingMedium),
            AppFilledIconButton(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppStrings.testAlertSound),
                    backgroundColor: AppColors.primaryColor,
                  ),
                );
              },
               label: '',
              icon: Icons.volume_up,
            ),
            const Spacer(),
            Center(
              child: Text(
                AppStrings.appVersionLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: AppValues.spacingXSmall),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(width: AppValues.spacingMedium),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textDark,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }

  void _reset() {
    setState(() {
      _soundAlerts = true;
      _vibration = true;
      _visualFlashes = false;
      _volume = 0.7;
    });
  }
}

