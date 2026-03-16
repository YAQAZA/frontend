import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onTap,
        child: Text(
          AppStrings.forgotPassword,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: AppValues.bodyFontSize,
          ),
        ),
      ),
    );
  }
}
