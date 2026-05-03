import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widget/core_widgets.dart';
import 'forgot_password_link.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
    this.emailError,
    this.passwordError,
    this.onForgotPasswordTap,
  });

  final void Function(String email, String password) onSubmit;
  final bool isLoading;
  final String? emailError;
  final String? passwordError;
  final VoidCallback? onForgotPasswordTap;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onSubmit(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final emailError = widget.emailError;
    final passwordError = widget.passwordError;
    final showEmailSuccess = emailError == null &&
        _emailController.text.trim().isNotEmpty &&
        _emailController.text.contains('@');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormSection(
          spacingAfter: AppValues.spacingMedium,
          child: AppTextField(
            label: AppStrings.emailAddress,
            controller: _emailController,
            hintText: AppStrings.emailAddress,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            errorText: emailError,
            showSuccessIcon: showEmailSuccess,
            onChanged: (_) => setState(() {}),
          ),
        ),
        FormSection(
          spacingAfter: AppValues.spacingXSmall,
          child: AppTextField(
            label: AppStrings.password,
            controller: _passwordController,
            hintText: AppStrings.enterYourPassword,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            errorText: passwordError,
            onSubmitted: (_) => _submit(),
            suffix: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textMedium,
                size: AppValues.iconSizeMedium,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        ForgotPasswordLink(onTap: widget.onForgotPasswordTap),
        SizedBox(height: AppValues.spacingLarge),
        AppButton(
          label: AppStrings.login,
          isLoading: widget.isLoading,
          onPressed: _submit,
          trailingIcon: const Icon(
            Icons.arrow_forward,
            color: AppColors.textWhite,
            size: AppValues.iconSizeMedium,
          ),
        ),
      ],
    );
  }
}
