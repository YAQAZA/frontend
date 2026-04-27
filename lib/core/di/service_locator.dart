import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:yaqazah/features/session/model/services/detection_service.dart';

import '../constants/constants.dart';
import '../database/database_service.dart';
import '../database/sqflite/app_database.dart';
import '../database/sqflite/sqflite_service.dart';
import '../network/api_consumer.dart';
import '../network/dio_consumer.dart';
import '../../features/auth/model/repositories/auth_repository.dart';
import '../../features/auth/model/services/auth_service.dart';
import '../../features/auth/view_model/cubit/auth_cubit.dart';
import '../../features/log_history/model/repositories/log_history_repository.dart';
import '../../features/log_history/model/services/log_history_service.dart';
import '../../features/log_history/view_model/cubit/log_history_cubit.dart';
import '../../features/session/model/services/session_log_local_service.dart';
import '../../features/session/model/services/session_log_remote_service.dart';
import '../../features/session/model/repositories/session_repository.dart';
import '../../features/session/model/services/session_service.dart';
import '../../features/session/view_model/cubit/session_cubit.dart';

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

  // 3.5. Session services (dummy for now)
  sl.registerLazySingleton<SessionService>(
    () => SessionService(sl<DetectionService>()),
  );
  sl.registerLazySingleton<SessionLogLocalService>(
    SessionLogLocalService.new,
  );
  sl.registerLazySingleton<SessionLogRemoteService>(
    () => SessionLogRemoteService(sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<LogHistoryService>(
    () => LogHistoryService(sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<DetectionService>(
    () => DetectionService(),
  );

  // 4. Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(sl<AuthService>()),
  );

  sl.registerLazySingleton<SessionRepository>(
    () => SessionRepository(
      sl<SessionService>(),
      sl<SessionLogLocalService>(),
      sl<SessionLogRemoteService>(),
    ),
  );
  sl.registerLazySingleton<LogHistoryRepository>(
    () => LogHistoryRepository(sl<LogHistoryService>()),
  );

  // 5. Cubits
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(sl<AuthRepository>()),
  );

  sl.registerFactory<SessionCubit>(
    () => SessionCubit(sl<SessionRepository>()),
  );
  sl.registerFactory<LogHistoryCubit>(
    () => LogHistoryCubit(sl<LogHistoryRepository>()),
  );

  sl.registerLazySingleton<DatabaseService>(
  () => SqfliteService(AppDatabase.instance),
);
}
