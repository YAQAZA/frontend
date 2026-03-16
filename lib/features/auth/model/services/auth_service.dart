import '../../../../core/constants/constants.dart';
import '../models/user_model.dart';

/// Uses dummy data only. Replace with ApiConsumer when backend is ready.
class AuthService {
  AuthService();

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final emailMatch =
        email.trim().toLowerCase() == DummyData.loginEmail.toLowerCase();
    final passwordMatch = password == DummyData.loginPassword;
    if (emailMatch && passwordMatch) {
      return UserModel.fromJson(
        Map<String, dynamic>.from(DummyData.dummyUserMap),
      );
    }
    throw Exception(AppStrings.validationLoginFailed);
  }

  /// Dummy sign-up. Returns a user built from the provided data.
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return UserModel(
      id: '2',
      email: email.trim(),
      name: name,
      token: 'dummy_signup_token',
    );
  }

  /// Dummy forgot-password. Succeeds if email looks valid.
  Future<void> sendResetPasswordLink({
    required String email,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
}
