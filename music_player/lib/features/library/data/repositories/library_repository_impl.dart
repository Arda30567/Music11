import 'package:music_player/features/library/domain/repositories/library_repository.dart';
import 'package:music_player/features/player/domain/entities/song.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  @override
  Future<List<Song>> getAllSongs() async {
    // Mock implementation
    return [];
  }

  @override
  Future<List<Song>> getSongsByArtist(String artist) async {
    // Mock implementation
    return [];
  }

  @override
  Future<List<Song>> getSongsByAlbum(String album) async {
    // Mock implementation
    return [];
  }

  @override
  Future<List<String>> getAllArtists() async {
    // Mock implementation
    return [];
  }

  @override
  Future<List<String>> getAllAlbums() async {
    // Mock implementation
    return [];
  }

  @override
  Future<void> scanMusicLibrary() async {
    // Implementation for scanning music library
  }

  @override
  Future<void> updateSongMetadata(Song song) async {
    // Implementation for updating song metadata
  }
}