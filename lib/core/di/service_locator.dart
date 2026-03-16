import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../constants/constants.dart';
import '../network/api_consumer.dart';
import '../network/dio_consumer.dart';
import '../../features/auth/model/repositories/auth_repository.dart';
import '../../features/auth/model/services/auth_service.dart';
import '../../features/auth/view_model/cubit/auth_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // 1. HTTP Client
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  sl.registerLazySingleton<Dio>(() => dio);

  // 2. ApiConsumer
  sl.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(sl<Dio>()),
  );

  // 3. Services (AuthService uses dummy data for now)
  sl.registerLazySingleton<AuthService>(() => AuthService());

  // 4. Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(sl<AuthService>()),
  );

  // 5. Cubits
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(sl<AuthRepository>()),
  );
}
