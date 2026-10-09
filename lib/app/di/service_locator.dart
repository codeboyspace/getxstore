import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'package:getx/app/services/api_service.dart';
import 'package:getx/app/services/local_storage_service.dart';

final getIt = GetIt.instance;

void configureDependencies(Box<String> storageBox) {
  if (!getIt.isRegistered<ApiService>()) {
    getIt.registerLazySingleton<ApiService>(ApiService.new);
  }
  if (!getIt.isRegistered<LocalStorageService>()) {
    getIt.registerLazySingleton<LocalStorageService>(
      () => LocalStorageService(storageBox),
    );
  }
}
