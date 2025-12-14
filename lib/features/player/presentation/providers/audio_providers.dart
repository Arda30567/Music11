import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/core/services/audio_service.dart';
import 'package:music_player/features/player/domain/entities/song.dart';

// Audio Player State
final audioPlayerProvider = Provider<AudioPlayerHandler>((ref) {
  // This will be initialized in main.dart
  throw UnimplementedError('AudioPlayerHandler should be initialized');
});

// Current Song Stream
final currentSongProvider = StreamProvider<Song?>((ref) {
  final audioHandler = ref.watch(audioPlayerProvider);
  return audioHandler.currentSongStream.map((song) => song);
});

// Is Playing Stream
final isPlayingProvider = StreamProvider<bool>((ref) {
  final audioHandler = ref.watch(audioPlayerProvider);
  return audioHandler.isPlayingStream;
});

// Playback Position Stream
final playbackPositionProvider = StreamProvider<Duration>((ref) {
  final audioHandler = ref.watch(audioPlayerProvider);
  return audioHandler.playbackPositionStream;
});

// Duration Stream
final durationProvider = StreamProvider<Duration>((ref) {
  final audioHandler = ref.watch(audioPlayerProvider);
  return audioHandler.durationStream;
});

// Progress Provider (combines position and duration)
final progressProvider = StreamProvider<PlaybackProgress>((ref) async* {
  final positionStream = ref.watch(playbackPositionProvider).stream;
  final durationStream = ref.watch(durationProvider).stream;
  
  await for (final position in positionStream) {
    final duration = await durationStream.first;
    yield PlaybackProgress(
      position: position,
      duration: duration,
      progress: duration.inMilliseconds > 0 
          ? position.inMilliseconds / duration.inMilliseconds 
          : 0.0,
    );
  }
});

// Queue Management
final queueProvider = StateProvider<List<Song>>((ref) => []);
final currentIndexProvider = StateProvider<int>((ref) => 0);

// Playback Controls
final shuffleModeProvider = StateProvider<bool>((ref) => false);
final repeatModeProvider = StateProvider<RepeatMode>((ref) => RepeatMode.off);

// Volume Control
final volumeProvider = StateProvider<double>((ref) => 1.0);

// Speed Control
final playbackSpeedProvider = StateProvider<double>((ref) => 1.0);

// Equalizer
final equalizerEnabledProvider = StateProvider<bool>((ref) => false);
final equalizerBandsProvider = StateProvider<List<EqualizerBand>>((ref) => [
  EqualizerBand(frequency: 60, gain: 0.0),
  EqualizerBand(frequency: 230, gain: 0.0),
  EqualizerBand(frequency: 910, gain: 0.0),
  EqualizerBand(frequency: 3600, gain: 0.0),
  EqualizerBand(frequency: 14000, gain: 0.0),
]);

// Playback State
final playbackStateProvider = Provider<PlaybackState>((ref) {
  final currentSong = ref.watch(currentSongProvider).value;
  final isPlaying = ref.watch(isPlayingProvider).value ?? false;
  final progress = ref.watch(progressProvider).value;
  final shuffleMode = ref.watch(shuffleModeProvider);
  final repeatMode = ref.watch(repeatModeProvider);
  
  return PlaybackState(
    currentSong: currentSong,
    isPlaying: isPlaying,
    progress: progress,
    shuffleMode: shuffleMode,
    repeatMode: repeatMode,
  );
});

// Models
class PlaybackProgress {
  final Duration position;
  final Duration duration;
  final double progress;

  const PlaybackProgress({
    required this.position,
    required this.duration,
    required this.progress,
  });
}

enum RepeatMode {
  off,
  one,
  all,
}

class EqualizerBand {
  final double frequency;
  final double gain;

  const EqualizerBand({
    required this.frequency,
    required this.gain,
  });

  EqualizerBand copyWith({double? gain}) {
    return EqualizerBand(
      frequency: frequency,
      gain: gain ?? this.gain,
    );
  }
}

class PlaybackState {
  final Song? currentSong;
  final bool isPlaying;
  final PlaybackProgress? progress;
  final bool shuffleMode;
  final RepeatMode repeatMode;

  const PlaybackState({
    this.currentSong,
    required this.isPlaying,
    this.progress,
    required this.shuffleMode,
    required this.repeatMode,
  });
}