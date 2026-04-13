import 'package:flutter/material.dart';

import '../constants/app_values.dart';

/// Wraps a form field (label + input) with consistent spacing.
class FormSection extends StatelessWidget {
  const FormSection({
    super.key,
    required this.child,
    this.spacingAfter = AppValues.spacingMedium,
  });

  final Widget child;
  final double spacingAfter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        SizedBox(height: spacingAfter),
      ],
    );
  }
}
