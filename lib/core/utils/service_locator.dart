import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasource/auth_remote_datasource.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/products/data/datasource/products_remote_datasource.dart';
import '../../features/products/data/repository/products_repository_impl.dart';
import '../../features/products/domain/repository/products_repository.dart';
import '../../features/products/domain/usecases/get_products_usecase.dart';
import '../../features/products/domain/usecases/update_product_status_usecase.dart';
import '../../features/products/presentation/bloc/products_bloc.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // Network
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  // Auth — Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<Dio>()),
  );

  // Auth — Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl<AuthRemoteDataSource>(),
      sl<SharedPreferences>(),
    ),
  );

  // Auth — Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));

  // Auth — BLoC
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
    ),
  );

  // Products — Data Sources
  sl.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSourceImpl(sl<Dio>()),
  );

  // Products — Repository
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(sl<ProductsRemoteDataSource>()),
  );

  // Products — Use Cases
  sl.registerLazySingleton(() => GetProductsUseCase(sl<ProductsRepository>()));
  sl.registerLazySingleton(
    () => UpdateProductStatusUseCase(sl<ProductsRepository>()),
  );

  // Products — BLoC
  sl.registerFactory(
    () => ProductsBloc(
      getProductsUseCase: sl<GetProductsUseCase>(),
      updateProductStatusUseCase: sl<UpdateProductStatusUseCase>(),
    ),
  );
}
