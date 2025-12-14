import 'package:music_player/features/player/domain/entities/song.dart';

abstract class AudioRepository {
  Future<List<Song>> getSongs();
  Future<void> playSong(Song song);
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> seekTo(Duration position);
  Future<void> setVolume(double volume);
  Future<void> setSpeed(double speed);
}