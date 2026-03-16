import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class SignInHeader extends StatelessWidget {
  const SignInHeader({
    super.key,
    this.logoSize,
    this.title,
    this.tagline,
  });

  final double? logoSize;
  final String? title;
  final String? tagline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = logoSize ?? AppValues.logoSize;
    final headerTitle = title ?? AppStrings.welcomeBack;
    final headerTagline = tagline ?? AppStrings.loginTagline;
    return Column(
      children: [
        _buildLogo(size),
        SizedBox(height: AppValues.spacingXLarge),
        Text(
          headerTitle,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
            fontSize: AppValues.titleFontSize,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppValues.spacingSmall),
        Text(
          headerTagline,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textMedium,
            fontSize: AppValues.taglineFontSize,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLogo(double size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppValues.borderRadius),
      child: Image.asset(
        AppAssets.logoImage,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _logoPlaceholder(size),
      ),
    );
  }

  Widget _logoPlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.logoBackground,
        borderRadius: BorderRadius.circular(AppValues.borderRadius),
      ),
      child: Icon(
        Icons.directions_car,
        size: AppValues.logoPlaceholderIconSize,
        color: AppColors.primaryColor,
      ),
    );
  }
}
