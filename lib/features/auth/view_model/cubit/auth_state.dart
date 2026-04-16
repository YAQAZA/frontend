import 'package:equatable/equatable.dart';

import '../../model/models/user_model.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthSuccess extends AuthState {
  const AuthSuccess(this.user);

  final UserModel user;

  @override
  List<Object?> get props => [user];
}

final class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Emitted when form validation fails. UI shows these on the fields.
final class AuthValidationError extends AuthState {
  const AuthValidationError({
    this.nameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
  });

  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;

  @override
  List<Object?> get props => [
        nameError,
        emailError,
        passwordError,
        confirmPasswordError,
      ];
}

/// Emitted when forgot-password flow succeeds.
final class AuthForgotPasswordSuccess extends AuthState {
  const AuthForgotPasswordSuccess();
}

final class AuthPasswordChangedSuccess extends AuthState {
  const AuthPasswordChangedSuccess();
}
