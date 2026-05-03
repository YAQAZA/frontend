import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_values.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.errorText,
    this.showSuccessIcon = false,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
    this.validator,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? errorText;
  final bool showSuccessIcon;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;

  static InputDecoration _decoration({
    required String hintText,
    String? errorText,
    bool showSuccessIcon = false,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: AppColors.inputBackground,
      errorText: errorText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppValues.borderRadius),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppValues.borderRadius),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppValues.borderRadius),
        borderSide: const BorderSide(
          color: AppColors.primaryColor,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppValues.borderRadius),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      suffixIcon: suffix ?? (showSuccessIcon ? _successIcon() : null),
    );
  }

  static Widget _successIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: AppValues.inputSuffixPaddingRight),
      child: Icon(
        Icons.check_circle,
        color: AppColors.success,
        size: AppValues.iconSizeMedium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
            fontSize: AppValues.labelFontSize,
          ),
        ),
        SizedBox(height: AppValues.spacingXSmall),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          validator: validator,
          decoration: _decoration(
            hintText: hintText ?? label,
            errorText: errorText,
            showSuccessIcon: showSuccessIcon,
            suffix: suffix,
          ),
        ),
      ],
    );
  }
}
