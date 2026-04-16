# Feature Structure

Every feature must follow this structure:

features/
  feature_name/

    model/
      models/
      repositories/
      services/

    view_model/
      cubit/
        feature_cubit.dart
        feature_state.dart

    view/
      screen/
        feature_screen.dart
        widgets/

Example:

features/auth/

  model/
    models/
      user_model.dart
    repositories/
      auth_repository.dart
    services/
      auth_service.dart

  view_model/
    auth_bloc/
      auth_cubit.dart
      auth_state.dart
    gender_bloc/
        gender_cubit.dart
        gender_state.dart

  view/
    login_screen/
        login_screen.dart
        widgets/
            login_form.dart
    signup_screen/
        signup_screen.dart
        widgets/
            signup_form.dart