import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/constants.dart';
import 'core/di/service_locator.dart';
import 'features/auth/view/screens/forgot_password_screen.dart';
import 'features/auth/view/screens/login_screen.dart';
import 'features/auth/view/screens/profile_screen.dart';
import 'features/auth/view/screens/sign_up_screen.dart';
import 'features/auth/view/screens/sign_up_permissions_screen.dart';
import 'features/auth/view/screens/settings_screen.dart';
import 'features/auth/view/screens/alert_sensitivity_screen.dart';
import 'features/auth/view/screens/change_password_screen.dart';
import 'features/auth/view_model/cubit/auth_cubit.dart';
import 'features/session/view/screens/session_start_screen.dart';
import 'features/session/view/screens/session_active_screen.dart';
import 'features/session/view_model/cubit/session_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();
  runApp(const YaqazahApp());
}

class YaqazahApp extends StatelessWidget {
  const YaqazahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider(create: (_) => sl<SessionCubit>()),
      ],
      child: MaterialApp(
        title: 'Yaqazah',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.login,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case AppRoutes.login:
              return MaterialPageRoute(builder: (_) => const LoginScreen());
            case AppRoutes.signUp:
              return MaterialPageRoute(builder: (_) => const SignUpScreen());
            case AppRoutes.signUpPermissions:
              return MaterialPageRoute(
                builder: (_) => const SignUpPermissionsScreen(),
              );
            case AppRoutes.forgotPassword:
              return MaterialPageRoute(
                builder: (_) => const ForgotPasswordScreen(),
              );
            case AppRoutes.profile:
              return MaterialPageRoute(builder: (_) => const ProfileScreen());
            case AppRoutes.settings:
              return MaterialPageRoute(builder: (_) => const SettingsScreen());
            case AppRoutes.alertSensitivity:
              return MaterialPageRoute(
                builder: (_) => const AlertSensitivityScreen(),
              );
            case AppRoutes.sessionStart:
              return MaterialPageRoute(
                builder: (_) => const SessionStartScreen(),
              );
            case AppRoutes.sessionActive:
              return MaterialPageRoute(
                builder: (_) => const SessionActiveScreen(),
              );
            case '/change-password':
              return MaterialPageRoute(
                builder: (_) => const ChangePasswordScreen(),
              );
            default:
              return MaterialPageRoute(
                builder: (_) => const SessionStartScreen(),
              );
          }
        },
      ),
    );
  }
}
