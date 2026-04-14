import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaqazah/core/utils/app_router.dart';
import 'core/constants/constants.dart';
import 'core/di/service_locator.dart';
import 'features/auth/view_model/cubit/auth_cubit.dart';
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
        initialRoute: AppRoutes.sessionStart,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
