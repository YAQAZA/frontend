import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/size_helper.dart';
import '../../view_model/cubit/auth_cubit.dart';
import '../../view_model/cubit/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paddingH = SizeHelper.screenPaddingHorizontal(context);

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthSuccess ? state.user : null;

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.textWhite,
            elevation: 0,
            title: const Text(AppStrings.myProfile),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: paddingH),
            child: Column(
              children: [
                SizedBox(height: AppValues.spacingXLarge),
                _buildAvatar(context),
                SizedBox(height: AppValues.spacingMedium),
                Text(
                  user?.name ?? '',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: AppValues.spacingSmall),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppValues.spacingMedium,
                    vertical: AppValues.spacingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified,
                        color: AppColors.primaryColor,
                        size: 16,
                      ),
                      SizedBox(width: AppValues.spacingSmall),
                      Text(
                        user?.role ?? AppStrings.googleDriver,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppValues.spacingXLarge),
                _buildDriverInfoCard(theme, user),
                SizedBox(height: AppValues.spacingLarge),
                _buildAccountInfoCard(context, theme, user),
                SizedBox(height: AppValues.spacingLarge),
                _buildPrimaryActions(context, theme),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: AppValues.logoSize * 2,
          height: AppValues.logoSize * 2,
          decoration: BoxDecoration(
            color: AppColors.logoBackground,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryColor,
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.person,
            size: 64,
            color: AppColors.primaryColor,
          ),
        ),
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.camera_alt,
            color: AppColors.textWhite,
            size: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildDriverInfoCard(ThemeData theme, dynamic user) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppValues.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(AppValues.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.driverInfo,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textMedium,
            ),
          ),
          SizedBox(height: AppValues.spacingMedium),
          Row(
            children: [
              Expanded(
                child: _buildInfoField(
                  theme: theme,
                  label: AppStrings.fullNameLabel,
                  value: (user?.name as String?) ?? '',
                ),
              ),
              SizedBox(width: AppValues.spacingMedium),
              Expanded(
                child: _buildInfoField(
                  theme: theme,
                  label: AppStrings.genderLabel,
                  value: (user?.gender as String?) ?? '',
                ),
              ),
            ],
          ),
          SizedBox(height: AppValues.spacingMedium),
          Row(
            children: [
              Expanded(
                child: _buildInfoField(
                  theme: theme,
                  label: AppStrings.birthDateLabel,
                  value: (user?.birthDate as String?) ?? '',
                ),
              ),
              SizedBox(width: AppValues.spacingMedium),
              Expanded(
                child: _buildInfoField(
                  theme: theme,
                  label: AppStrings.statusLabel,
                  value: (user?.status as String?) ?? AppStrings.statusActive,
                  valueColor: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoCard(BuildContext context, ThemeData theme, dynamic user) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppValues.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(AppValues.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.accountInformation,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textMedium,
            ),
          ),
          SizedBox(height: AppValues.spacingMedium),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.email_outlined, color: AppColors.primaryColor),
            title: const Text(AppStrings.emailAddressLabel),
            subtitle: Text((user?.email as String?) ?? ''),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.lock_outline, color: AppColors.primaryColor),
            title: const Text(AppStrings.changePassword),
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textMedium),
            onTap: () => Navigator.pushNamed(context, '/change-password'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.volume_up_outlined,
                color: AppColors.primaryColor),
            title: const Text(AppStrings.alertAndSensitivity),
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textMedium),
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.alertSensitivity,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryActions(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: AppValues.buttonHeight,
          child: FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.textWhite,
            ),
            child: const Text(AppStrings.saveChanges),
          ),
        ),
        SizedBox(height: AppValues.spacingMedium),
        SizedBox(
          width: double.infinity,
          height: AppValues.buttonHeight,
          child: OutlinedButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
            ),
            child: const Text(AppStrings.logOut),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoField({
    required ThemeData theme,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textMedium,
          ),
        ),
        SizedBox(height: AppValues.spacingSmall),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: valueColor ?? AppColors.textDark,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
