import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository(this._authService);

  final AuthService _authService;

  Future<UserModel> login({
    required String email,
    required String password,
  }) {
    return _authService.login(email: email, password: password);
  }

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return _authService.signUp(
      name: name,
      email: email,
      password: password,
    );
  }

  Future<void> sendResetPasswordLink({
    required String email,
  }) {
    return _authService.sendResetPasswordLink(email: email);
  }
}
