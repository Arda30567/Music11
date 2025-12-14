import 'package:music_player/features/player/domain/entities/song.dart';

abstract class LibraryRepository {
  Future<List<Song>> getAllSongs();
  Future<List<Song>> getSongsByArtist(String artist);
  Future<List<Song>> getSongsByAlbum(String album);
  Future<List<String>> getAllArtists();
  Future<List<String>> getAllAlbums();
  Future<void> scanMusicLibrary();
  Future<void> updateSongMetadata(Song song);
}