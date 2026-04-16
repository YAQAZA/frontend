import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/size_helper.dart';
import '../../view_model/cubit/auth_cubit.dart';
import '../../view_model/cubit/auth_state.dart';
import '../widgets/login_form.dart';
import '../widgets/sign_in_header.dart';
import '../widgets/sign_up_prompt.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: _listenAuthState,
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            final emailError =
                state is AuthValidationError ? state.emailError : null;
            final passwordError =
                state is AuthValidationError ? state.passwordError : null;
            return _buildBody(
              context,
              isLoading: isLoading,
              emailError: emailError,
              passwordError: passwordError,
            );
          },
        ),
      ),
    );
  }

  void _listenAuthState(BuildContext context, AuthState state) {
    if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.error,
        ),
      );
    }
    if (state is AuthSuccess) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.sessionStart,
        (route) => false,
      );
    }
  }

  Widget _buildBody(
    BuildContext context, {
    required bool isLoading,
    String? emailError,
    String? passwordError,
  }) {
    final paddingH = SizeHelper.screenPaddingHorizontal(context);
    final topPadding = SizeHelper.screenPaddingTop(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: paddingH,
          right: paddingH,
          top: topPadding,
          bottom: AppValues.screenPaddingVertical,
        ),
        child: Column(
          children: [
            SizedBox(height: AppValues.spacingXLarge),
            const SignInHeader(),
            SizedBox(height: AppValues.spacingXLarge),
            LoginForm(
              isLoading: isLoading,
              emailError: emailError,
              passwordError: passwordError,
              onSubmit: (email, password) {
                context.read<AuthCubit>().login(
                      email: email,
                      password: password,
                    );
              },
              onForgotPasswordTap: () {
                Navigator.pushNamed(context, AppRoutes.forgotPassword);
              },
            ),
            SizedBox(height: AppValues.spacingXLarge),
            SignUpPrompt(
              onSignUpTap: () {
                Navigator.pushNamed(context, AppRoutes.signUp);
              },
            ),
          ],
        ),
      ),
    );
  }
}
