library data;

import 'package:data/src/repository/auth_repository_impl.dart';
import 'package:data/src/repository/device_repository_impl.dart';
import 'package:data/src/repository/user_repository_impl.dart';
import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';

class Data {
  static init() {
    GetIt.I.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
    GetIt.I
        .registerLazySingleton<DeviceRepository>(() => DeviceRepositoryImpl());
    GetIt.I.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());
  }
}
