import 'package:flutter/material.dart';
import 'package:yaqazah/core/constants/app_routes.dart';
import 'package:yaqazah/features/auth/view/screens/alert_sensitivity_screen.dart';
import 'package:yaqazah/features/auth/view/screens/change_password_screen.dart';
import 'package:yaqazah/features/auth/view/screens/forgot_password_screen.dart';
import 'package:yaqazah/features/auth/view/screens/login_screen.dart';
import 'package:yaqazah/features/auth/view/screens/profile_screen.dart';
import 'package:yaqazah/features/auth/view/screens/settings_screen.dart';
import 'package:yaqazah/features/auth/view/screens/sign_up_permissions_screen.dart';
import 'package:yaqazah/features/auth/view/screens/sign_up_screen.dart';
import 'package:yaqazah/features/session/view/screens/session_active_screen.dart';
import 'package:yaqazah/features/session/view/screens/session_start_screen.dart';
import 'package:yaqazah/features/session/view/widgets/session_bottom_nav.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
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
            case AppRoutes.changePassword:
              return MaterialPageRoute(
                builder: (_) => const ChangePasswordScreen(),
              );
            case AppRoutes.sessionsHistory:
              return MaterialPageRoute(
                builder: (_) => const SessionHistory(),
              );
            case AppRoutes.stats:
              return MaterialPageRoute(
                builder: (_) => const StatsScreen(),
              );
            default:
              return MaterialPageRoute(
                builder: (_) => const SessionStartScreen(),
              );
          }
        }
}