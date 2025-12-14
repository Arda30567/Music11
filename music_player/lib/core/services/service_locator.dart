import 'package:get_it/get_it.dart';
import 'package:music_player/features/player/data/repositories/audio_repository_impl.dart';
import 'package:music_player/features/player/domain/repositories/audio_repository.dart';
import 'package:music_player/features/library/data/repositories/library_repository_impl.dart';
import 'package:music_player/features/library/domain/repositories/library_repository.dart';
import 'package:music_player/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:music_player/features/settings/domain/repositories/settings_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Repositories
  sl.registerLazySingleton<AudioRepository>(() => AudioRepositoryImpl());
  sl.registerLazySingleton<LibraryRepository>(() => LibraryRepositoryImpl());
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl());
  
  // Services will be added here
}