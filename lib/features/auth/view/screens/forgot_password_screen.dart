import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/size_helper.dart';
import '../../view_model/cubit/auth_cubit.dart';
import '../../view_model/cubit/auth_state.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/form_section.dart';
import '../widgets/status_dialog.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        if (state is AuthForgotPasswordSuccess) {
          showDialog<void>(
            context: context,
            builder: (dialogContext) => StatusDialog(
              title: AppStrings.emailSentTitle,
              body: AppStrings.emailSentBody,
              primaryLabel: AppStrings.openEmailApp,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final emailError =
            state is AuthValidationError ? state.emailError : null;

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.textWhite,
            title: const Text(AppStrings.resetPasswordAppBarTitle),
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
                    SizedBox(height: AppValues.spacingXLarge),
                    Text(
                      AppStrings.forgotPasswordTitle,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        fontSize: AppValues.titleFontSize,
                      ),
                    ),
                    SizedBox(height: AppValues.spacingSmall),
                    Text(
                      AppStrings.forgotPasswordTagline,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMedium,
                        fontSize: AppValues.taglineFontSize,
                      ),
                    ),
                    SizedBox(height: AppValues.spacingXLarge),
                    FormSection(
                      spacingAfter: AppValues.spacingLarge,
                      child: AppTextField(
                        label: AppStrings.emailAddress,
                        controller: _emailController,
                        hintText: AppStrings.emailAddress,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        errorText: emailError,
                      ),
                    ),
                    AppButton(
                      label: AppStrings.sendResetLink,
                      isLoading: isLoading,
                      onPressed: () {
                        context.read<AuthCubit>().sendResetPasswordLink(
                              email: _emailController.text.trim(),
                            );
                      },
                      trailingIcon: const Icon(
                        Icons.arrow_forward,
                        color: AppColors.textWhite,
                        size: AppValues.iconSizeMedium,
                      ),
                    ),
                    SizedBox(height: AppValues.spacingXLarge),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          AppStrings.backToLogin,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: AppValues.bodyFontSize,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
