import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/size_helper.dart';
import '../../../../core/widget/core_widgets.dart';
import '../../view_model/cubit/auth_cubit.dart';
import '../../view_model/cubit/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _birthDateController = TextEditingController();
  String _gender = AppStrings.female;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked == null) return;

    final yyyy = picked.year.toString().padLeft(4, '0');
    final mm = picked.month.toString().padLeft(2, '0');
    final dd = picked.day.toString().padLeft(2, '0');
    _birthDateController.text = '$yyyy-$mm-$dd';
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paddingH = SizeHelper.screenPaddingHorizontal(context);
    final topPadding = SizeHelper.screenPaddingTop(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
        if (state is AuthSuccess) {
          Navigator.pushNamed(
            context,
            AppRoutes.signUpPermissions,
          );
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        final isLoading = state is AuthLoading;
        final validation = state is AuthValidationError ? state : null;

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
                      AppStrings.createAccount,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        fontSize: AppValues.titleFontSize,
                      ),
                    ),
                    SizedBox(height: AppValues.spacingSmall),
                    Text(
                      AppStrings.signUpTagline,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMedium,
                        fontSize: AppValues.taglineFontSize,
                      ),
                    ),
                    SizedBox(height: AppValues.spacingXLarge),
                    _buildForm(
                      nameError: validation?.nameError,
                      emailError: validation?.emailError,
                      passwordError: validation?.passwordError,
                      confirmPasswordError: validation?.confirmPasswordError,
                      isLoading: isLoading,
                    ),
                    SizedBox(height: AppValues.spacingLarge),
                    _buildSignInLink(context, theme),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
              AppStrings.signUpStep1Label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textMedium,
              ),
            ),
            Text(
              AppStrings.signUpStep1Name.toUpperCase(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: AppValues.spacingSmall),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: 0.5,
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

  Widget _buildForm({
    required bool isLoading,
    String? nameError,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormSection(
          child: AppTextField(
            label: AppStrings.fullName,
            controller: _nameController,
            hintText: AppStrings.enterFullName,
            textInputAction: TextInputAction.next,
            errorText: nameError,
          ),
        ),
        FormSection(
          child: AppTextField(
            label: AppStrings.username,
            controller: _usernameController,
            hintText: AppStrings.enterUsername,
            textInputAction: TextInputAction.next,
          ),
        ),
        FormSection(
          child: AppTextField(
            label: AppStrings.emailAddress,
            controller: _emailController,
            hintText: AppStrings.emailAddress,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            errorText: emailError,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: FormSection(
                child: AppTextField(
                  label: AppStrings.birthDate,
                  controller: _birthDateController,
                  hintText: AppStrings.birthDateHint,
                  textInputAction: TextInputAction.next,
                  suffix: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickBirthDate,
                  ),
                ),
              ),
            ),
            SizedBox(width: AppValues.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.gender,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark,
                          fontSize: AppValues.labelFontSize,
                        ),
                  ),
                  SizedBox(height: AppValues.spacingSmall),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: const Text(AppStrings.female),
                          value: AppStrings.female,
                          groupValue: _gender,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _gender = value);
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: const Text(AppStrings.male),
                          value: AppStrings.male,
                          groupValue: _gender,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _gender = value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        FormSection(
          child: AppTextField(
            label: AppStrings.password,
            controller: _passwordController,
            hintText: AppStrings.enterYourPassword,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            errorText: passwordError,
            suffix: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textMedium,
                size: AppValues.iconSizeMedium,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        FormSection(
          spacingAfter: AppValues.spacingLarge,
          child: AppTextField(
            label: AppStrings.confirmPassword,
            controller: _confirmPasswordController,
            hintText: AppStrings.enterConfirmPassword,
            obscureText: _obscureConfirm,
            textInputAction: TextInputAction.done,
            errorText: confirmPasswordError,
            suffix: IconButton(
              icon: Icon(
                _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textMedium,
                size: AppValues.iconSizeMedium,
              ),
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
        ),
        AppButton(
          label: AppStrings.register,
          isLoading: isLoading,
          onPressed: () {
            context.read<AuthCubit>().signUp(
                  name: _nameController.text,
                  email: _emailController.text,
                  password: _passwordController.text,
                  confirmPassword: _confirmPasswordController.text,
                );
          },
          trailingIcon: const Icon(
            Icons.arrow_forward,
            color: AppColors.textWhite,
            size: AppValues.iconSizeMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildSignInLink(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.alreadyHaveAccount,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textMedium,
            fontSize: AppValues.bodyFontSize,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppStrings.signIn,
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
