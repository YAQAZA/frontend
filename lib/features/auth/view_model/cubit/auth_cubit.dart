import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../model/models/user_model.dart';
import '../../model/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthInitial());

  final AuthRepository _authRepository;

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  String? _validateEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      return AppStrings.validationEmailRequired;
    }
    if (!_emailRegExp.hasMatch(trimmed)) {
      return AppStrings.validationEmailInvalid;
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return AppStrings.validationPasswordRequired;
    }
    if (password.length < 8) {
      return AppStrings.validationPasswordMin8;
    }
    return null;
  }

  String? _validateName(String name) {
    if (name.trim().isEmpty) {
      return AppStrings.validationNameRequired;
    }
    return null;
  }

  String? _validateConfirmPassword({
    required String password,
    required String confirmPassword,
  }) {
    if (confirmPassword.isEmpty) {
      return AppStrings.validationConfirmPasswordRequired;
    }
    if (password != confirmPassword) {
      return AppStrings.validationPasswordsNotMatch;
    }
    return null;
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final emailError = _validateEmail(email);
    final passwordError = _validatePassword(password);
    if (emailError != null || passwordError != null) {
      emit(AuthValidationError(
        emailError: emailError,
        passwordError: passwordError,
      ));
      return;
    }
    emit(const AuthLoading());
    try {
      final UserModel user = await _authRepository.login(
        email: email.trim(),
        password: password,
      );
      emit(AuthSuccess(user));
    } catch (e) {
      final message = e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString();
      emit(AuthError(message));
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final nameError = _validateName(name);
    final emailError = _validateEmail(email);
    final passwordError = _validatePassword(password);
    final confirmPasswordError = _validateConfirmPassword(
      password: password,
      confirmPassword: confirmPassword,
    );

    if (nameError != null ||
        emailError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      emit(
        AuthValidationError(
          nameError: nameError,
          emailError: emailError,
          passwordError: passwordError,
          confirmPasswordError: confirmPasswordError,
        ),
      );
      return;
    }

    emit(const AuthLoading());
    try {
      final UserModel user = await _authRepository.signUp(
        name: name.trim(),
        email: email.trim(),
        password: password,
      );
      emit(AuthSuccess(user));
    } catch (e) {
      final message =
          e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString();
      emit(AuthError(message));
    }
  }

  Future<void> sendResetPasswordLink({
    required String email,
  }) async {
    final emailError = _validateEmail(email);
    if (emailError != null) {
      emit(AuthValidationError(emailError: emailError));
      return;
    }

    emit(const AuthLoading());
    try {
      await _authRepository.sendResetPasswordLink(email: email.trim());
      emit(const AuthForgotPasswordSuccess());
    } catch (e) {
      final message =
          e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString();
      emit(AuthError(message));
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final currentOk = currentPassword == DummyData.loginPassword;
    if (!currentOk) {
      emit(const AuthError(AppStrings.validationCurrentPasswordWrong));
      return;
    }

    final newPasswordError = _validatePassword(newPassword);
    final confirmError = _validateConfirmPassword(
      password: newPassword,
      confirmPassword: confirmNewPassword,
    );
    if (newPasswordError != null || confirmError != null) {
      emit(
        AuthValidationError(
          passwordError: newPasswordError,
          confirmPasswordError: confirmError,
        ),
      );
      return;
    }

    emit(const AuthLoading());
    await Future<void>.delayed(const Duration(milliseconds: 400));
    emit(const AuthPasswordChangedSuccess());
  }
}
