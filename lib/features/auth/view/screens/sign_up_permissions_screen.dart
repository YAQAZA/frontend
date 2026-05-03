import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/size_helper.dart';
import '../../../../core/widget/core_widgets.dart';
import '../widgets/permission_tile.dart';

class SignUpPermissionsScreen extends StatefulWidget {
  const SignUpPermissionsScreen({super.key});

  @override
  State<SignUpPermissionsScreen> createState() =>
      _SignUpPermissionsScreenState();
}

class _SignUpPermissionsScreenState extends State<SignUpPermissionsScreen> {
  bool _cameraEnabled = true;
  bool _backgroundEnabled = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paddingH = SizeHelper.screenPaddingHorizontal(context);
    final topPadding = SizeHelper.screenPaddingTop(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.textWhite,
        centerTitle: true,
        title: const Text(AppStrings.signUpAppBarTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: paddingH,
              right: paddingH,
              top: topPadding,
              bottom: AppValues.screenPaddingVertical,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStepHeader(theme),
                SizedBox(height: AppValues.spacingLarge),
                Text(
                  AppStrings.systemPermissionsTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    fontSize: AppValues.titleFontSize,
                  ),
                ),
                SizedBox(height: AppValues.spacingXSmall),
                Text(
                  AppStrings.systemPermissionsSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMedium,
                    fontSize: AppValues.bodyFontSize,
                  ),
                ),
                SizedBox(height: AppValues.spacingXLarge),
                PermissionTile(
                  icon: Icons.videocam_outlined,
                  title: AppStrings.cameraAccessTitle,
                  subtitle: AppStrings.cameraAccessSubtitle,
                  value: _cameraEnabled,
                  onChanged: (value) =>
                      setState(() => _cameraEnabled = value),
                ),
                SizedBox(height: AppValues.spacingMedium),
                PermissionTile(
                  icon: Icons.sync,
                  title: AppStrings.backgroundActivityTitle,
                  subtitle: AppStrings.backgroundActivitySubtitle,
                  value: _backgroundEnabled,
                  onChanged: (value) =>
                      setState(() => _backgroundEnabled = value),
                ),
                SizedBox(height: AppValues.spacingXLarge),
                AppButton(
                  label: AppStrings.register,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.profile,
                      (route) => false,
                    );
                  },
                  trailingIcon: const Icon(
                    Icons.arrow_forward,
                    color: AppColors.textWhite,
                    size: AppValues.iconSizeMedium,
                  ),
                ),
                SizedBox(height: AppValues.spacingLarge),
                Center(
                  child: Text(
                    AppStrings.learnMorePermissions,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryColor,
                      fontSize: AppValues.bodyFontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.signUpStep2Name,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textMedium,
              ),
            ),
            Text(
              AppStrings.signUpStep2Label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: AppValues.spacingXSmall),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: 0.9,
            minHeight: 4,
            backgroundColor: AppColors.borderLight,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

