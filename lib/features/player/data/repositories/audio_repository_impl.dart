import 'package:music_player/features/player/domain/repositories/audio_repository.dart';
import 'package:music_player/features/player/domain/entities/song.dart';

class AudioRepositoryImpl implements AudioRepository {
  @override
  Future<List<Song>> getSongs() async {
    // Mock implementation
    return [
      Song(
        id: '1',
        title: 'Blinding Lights',
        artist: 'The Weeknd',
        album: 'After Hours',
        duration: 200000,
        audioUrl: 'https://example.com/song1.mp3',
        albumArtUrl: 'https://example.com/art1.jpg',
      ),
      Song(
        id: '2',
        title: 'Shape of You',
        artist: 'Ed Sheeran',
        album: '÷ (Divide)',
        duration: 233000,
        audioUrl: 'https://example.com/song2.mp3',
        albumArtUrl: 'https://example.com/art2.jpg',
      ),
    ];
  }

  @override
  Future<void> playSong(Song song) async {
    // Implementation for playing a song
  }

  @override
  Future<void> pause() async {
    // Implementation for pausing
  }

  @override
  Future<void> resume() async {
    // Implementation for resuming
  }

  @override
  Future<void> stop() async {
    // Implementation for stopping
  }

  @override
  Future<void> seekTo(Duration position) async {
    // Implementation for seeking
  }

  @override
  Future<void> setVolume(double volume) async {
    // Implementation for setting volume
  }

  @override
  Future<void> setSpeed(double speed) async {
    // Implementation for setting speed
  }
}