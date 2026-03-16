import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class SignUpPrompt extends StatelessWidget {
  const SignUpPrompt({
    super.key,
    this.onSignUpTap,
  });

  final VoidCallback? onSignUpTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.dontHaveAccount,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textMedium,
            fontSize: AppValues.bodyFontSize,
          ),
        ),
        TextButton(
          onPressed: onSignUpTap,
          child: Text(
            AppStrings.signUp,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: AppValues.bodyFontSize,
            ),
          ),
        ),
      ],
    );
  }
}
