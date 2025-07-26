import 'package:get_it/get_it.dart';
import 'package:kointos/core/constants/app_constants.dart';
import 'package:kointos/core/services/amplify_storage_service.dart';
import 'package:kointos/core/services/api_service.dart';
import 'package:kointos/core/services/auth_service.dart';
import 'package:kointos/core/services/local_storage_service.dart';
import 'package:kointos/core/services/storage_interface.dart';
import 'package:kointos/data/datasources/coingecko_service.dart';
import 'package:kointos/data/repositories/article_repository.dart';
import 'package:kointos/data/repositories/cryptocurrency_repository.dart';
import 'package:kointos/data/repositories/post_repository.dart';
import 'package:kointos/data/repositories/user_profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  final prefs = await SharedPreferences.getInstance();

  // Core Services
  serviceLocator.registerLazySingleton<AuthService>(() => AuthService());

  serviceLocator.registerLazySingleton<LocalStorageService>(
    () => LocalStorageService(prefs: prefs),
  );

  serviceLocator.registerLazySingleton<ApiService>(
    () => ApiService(
      baseUrl: AppConstants.apiBaseUrl,
      authService: serviceLocator<AuthService>(),
    ),
  );

  serviceLocator.registerLazySingleton<StorageInterface>(
    () => AmplifyStorageService(),
  );

  // Data Sources
  serviceLocator.registerLazySingleton<CoinGeckoService>(
    () => const CoinGeckoService(baseUrl: AppConstants.coinGeckoBaseUrl),
  );

  // Repositories
  serviceLocator.registerLazySingleton<CryptocurrencyRepository>(
    () => CryptocurrencyRepository(
      coinGeckoService: serviceLocator<CoinGeckoService>(),
      localStorageService: serviceLocator<LocalStorageService>(),
    ),
  );

  serviceLocator.registerLazySingleton<ArticleRepository>(
    () => ArticleRepository(
      authService: serviceLocator<AuthService>(),
      storageService: serviceLocator<StorageInterface>(),
      apiService: serviceLocator<ApiService>(),
    ),
  );

  serviceLocator.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepository(
      apiService: serviceLocator<ApiService>(),
      storageService: serviceLocator<StorageInterface>(),
    ),
  );

  serviceLocator.registerLazySingleton<PostRepository>(
    () => PostRepository(
      apiService: serviceLocator<ApiService>(),
      storageService: serviceLocator<StorageInterface>(),
    ),
  );
}

T getService<T extends Object>() {
  return serviceLocator.get<T>();
}
