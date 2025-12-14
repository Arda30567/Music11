import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'song.freezed.dart';
part 'song.g.dart';

@freezed
class Song extends Equatable with _$Song {
  const factory Song({
    required String id,
    required String title,
    required String artist,
    required String album,
    required int duration,
    required String audioUrl,
    required String albumArtUrl,
    String? lyrics,
    int? playCount,
    bool? isFavorite,
    DateTime? lastPlayed,
    DateTime? dateAdded,
  }) = _Song;

  const Song._();

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);

  @override
  List<Object?> get props => [id, title, artist, album];

  // Helper methods
  String get formattedDuration {
    final minutes = (duration / 60000).floor();
    final seconds = ((duration % 60000) / 1000).floor();
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String get displayTitle => title;
  String get displaySubtitle => '$artist • $album';
  
  Song copyWithFavorite(bool isFavorite) {
    return copyWith(isFavorite: isFavorite);
  }
  
  Song copyWithPlayCount(int playCount) {
    return copyWith(playCount: playCount);
  }
  
  Song copyWithLastPlayed(DateTime lastPlayed) {
    return copyWith(lastPlayed: lastPlayed);
  }
}

@freezed
class Playlist extends Equatable with _$Playlist {
  const factory Playlist({
    required String id,
    required String name,
    required List<Song> songs,
    String? description,
    String? coverUrl,
    DateTime? createdAt,
    DateTime? lastModified,
    bool? isSmartPlaylist,
    String? smartPlaylistType,
  }) = _Playlist;

  const Playlist._();

  factory Playlist.fromJson(Map<String, dynamic> json) => _$PlaylistFromJson(json);

  @override
  List<Object?> get props => [id, name];

  int get songCount => songs.length;
  int get totalDuration => songs.fold(0, (sum, song) => sum + song.duration);
  
  String get formattedTotalDuration {
    final totalMinutes = (totalDuration / 60000).floor();
    final hours = (totalMinutes / 60).floor();
    final minutes = totalMinutes % 60;
    
    if (hours > 0) {
      return '$hours hr ${minutes}min';
    } else {
      return '$totalMinutes min';
    }
  }
  
  Playlist copyWithSongs(List<Song> newSongs) {
    return copyWith(songs: newSongs);
  }
}