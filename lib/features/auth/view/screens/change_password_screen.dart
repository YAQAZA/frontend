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

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
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
        if (state is AuthPasswordChangedSuccess) {
          showDialog<void>(
            context: context,
            builder: (_) => StatusDialog(
              title: AppStrings.passwordChangedTitle,
              body: AppStrings.passwordChangedBody,
              primaryLabel: AppStrings.login,
              onPrimaryPressed: () {
                Navigator.of(context).pop(); // dialog
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final validation = state is AuthValidationError ? state : null;

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.textWhite,
            title: const Text(AppStrings.changePassword),
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
                    FormSection(
                      child: AppTextField(
                        label: AppStrings.currentPassword,
                        controller: _currentController,
                        hintText: AppStrings.currentPassword,
                        obscureText: _obscureCurrent,
                        suffix: IconButton(
                          icon: Icon(
                            _obscureCurrent
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textMedium,
                            size: AppValues.iconSizeMedium,
                          ),
                          onPressed: () => setState(
                            () => _obscureCurrent = !_obscureCurrent,
                          ),
                        ),
                      ),
                    ),
                    FormSection(
                      child: AppTextField(
                        label: AppStrings.newPassword,
                        controller: _newController,
                        hintText: AppStrings.newPassword,
                        obscureText: _obscureNew,
                        errorText: validation?.passwordError,
                        suffix: IconButton(
                          icon: Icon(
                            _obscureNew
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textMedium,
                            size: AppValues.iconSizeMedium,
                          ),
                          onPressed: () => setState(
                            () => _obscureNew = !_obscureNew,
                          ),
                        ),
                      ),
                    ),
                    FormSection(
                      spacingAfter: AppValues.spacingLarge,
                      child: AppTextField(
                        label: AppStrings.confirmNewPassword,
                        controller: _confirmController,
                        hintText: AppStrings.confirmNewPassword,
                        obscureText: _obscureConfirm,
                        errorText: validation?.confirmPasswordError,
                        suffix: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textMedium,
                            size: AppValues.iconSizeMedium,
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),
                      ),
                    ),
                    AppButton(
                      label: AppStrings.updatePassword,
                      isLoading: isLoading,
                      onPressed: () {
                        context.read<AuthCubit>().changePassword(
                              currentPassword: _currentController.text,
                              newPassword: _newController.text,
                              confirmNewPassword: _confirmController.text,
                            );
                      },
                      trailingIcon: const Icon(
                        Icons.arrow_forward,
                        color: AppColors.textWhite,
                        size: AppValues.iconSizeMedium,
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

