# Dependency Injection

Use GetIt as the service locator.

Location:
core/di/service_locator.dart

Register dependencies in this order:

1. HTTP Client
2. ApiConsumer
3. Services
4. Repositories
5. Cubits

Rules:

- Services and repositories use registerLazySingleton
- Cubits use registerFactory

Initialization must occur before runApp().