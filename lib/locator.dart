import 'package:canli_konusma_app/repository/user_repository.dart';
import 'package:canli_konusma_app/services/bildirim_gonderme_servis.dart';
import 'package:canli_konusma_app/services/fake_auth_services.dart';
import 'package:canli_konusma_app/services/firebase_auth_services.dart';
import 'package:canli_konusma_app/services/firebase_storage_service.dart';
import 'package:canli_konusma_app/services/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthenticationService());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => BildirimGondermeServis());
}
