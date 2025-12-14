import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/features/player/domain/entities/song.dart';
import 'package:rxdart/rxdart.dart';

class AudioServiceManager {
  static final AudioServiceManager _instance = AudioServiceManager._internal();
  factory AudioServiceManager() => _instance;
  AudioServiceManager._internal();

  static Future<void> init() async {
    await AudioService.init(
      builder: () => AudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.musicplayer.channel',
        androidNotificationChannelName: 'Music Player',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: false,
        androidNotificationIcon: 'mipmap/ic_launcher',
        notificationColor: 0xFF6366F1,
      ),
    );
  }
}

class AudioPlayerHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);
  
  // Song queue
  final List<Song> _songQueue = [];
  int _currentIndex = 0;
  
  // Stream controllers
  final _currentSongController = BehaviorSubject<Song?>();
  final _isPlayingController = BehaviorSubject<bool>.seeded(false);
  final _playbackPositionController = BehaviorSubject<Duration>.seeded(Duration.zero);
  final _durationController = BehaviorSubject<Duration>.seeded(Duration.zero);
  
  // Getters for streams
  Stream<Song?> get currentSongStream => _currentSongController.stream;
  Stream<bool> get isPlayingStream => _isPlayingController.stream;
  Stream<Duration> get playbackPositionStream => _playbackPositionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  
  Song? get currentSong => _currentSongController.value;
  bool get isPlaying => _isPlayingController.value;
  Duration get playbackPosition => _playbackPositionController.value;
  Duration get duration => _durationController.value;

  AudioPlayerHandler() {
    _init();
  }

  Future<void> _init() async {
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      print("Error initializing audio player: $e");
    }

    // Listen to player state changes
    _player.playerStateStream.listen((state) {
      _isPlayingController.add(state.playing);
      
      // Update media item
      if (_currentIndex < _songQueue.length) {
        final song = _songQueue[_currentIndex];
        _currentSongController.add(song);
        
        mediaItem.add(MediaItem(
          id: song.id,
          title: song.title,
          artist: song.artist,
          duration: Duration(milliseconds: song.duration),
          artUri: Uri.parse(song.albumArtUrl),
        ));
      }
    });

    // Listen to position changes
    _player.positionStream.listen((position) {
      _playbackPositionController.add(position);
    });

    // Listen to duration changes
    _player.durationStream.listen((duration) {
      if (duration != null) {
        _durationController.add(duration);
      }
    });

    // Listen to completion
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        skipToNext();
      }
    });
  }

  // Queue management
  Future<void> setQueue(List<Song> songs, {int initialIndex = 0}) async {
    _songQueue.clear();
    _songQueue.addAll(songs);
    _currentIndex = initialIndex;
    
    // Update playlist
    final audioSources = songs.map((song) => AudioSource.uri(
      Uri.parse(song.audioUrl),
      tag: MediaItem(
        id: song.id,
        title: song.title,
        artist: song.artist,
        duration: Duration(milliseconds: song.duration),
        artUri: Uri.parse(song.albumArtUrl),
      ),
    )).toList();
    
    await _playlist.clear();
    await _playlist.addAll(audioSources);
    
    if (initialIndex < audioSources.length) {
      await _player.seek(Duration.zero, index: initialIndex);
    }
  }

  // Playback controls
  Future<void> play() async {
    if (_songQueue.isEmpty) return;
    await _player.play();
    _isPlayingController.add(true);
  }

  Future<void> pause() async {
    await _player.pause();
    _isPlayingController.add(false);
  }

  Future<void> resume() async {
    await _player.play();
    _isPlayingController.add(true);
  }

  Future<void> stop() async {
    await _player.stop();
    _isPlayingController.add(false);
    _playbackPositionController.add(Duration.zero);
  }

  Future<void> skipToNext() async {
    if (_currentIndex < _songQueue.length - 1) {
      _currentIndex++;
      await _player.seekToNext();
      await _player.play();
    }
  }

  Future<void> skipToPrevious() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      await _player.seekToPrevious();
      await _player.play();
    }
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
  }

  Future<void> setShuffleModeEnabled(bool enabled) async {
    await _player.setShuffleModeEnabled(enabled);
  }

  Future<void> setLoopMode(LoopMode mode) async {
    await _player.setLoopMode(mode);
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  // Cleanup
  @override
  Future<void> dispose() async {
    await _player.dispose();
    await _currentSongController.close();
    await _isPlayingController.close();
    await _playbackPositionController.close();
    await _durationController.close();
    super.dispose();
  }

  // AudioService overrides
  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    // Implementation for playing a single media item
    final song = Song(
      id: mediaItem.id,
      title: mediaItem.title,
      artist: mediaItem.artist ?? '',
      album: '',
      duration: mediaItem.duration?.inMilliseconds ?? 0,
      audioUrl: mediaItem.id,
      albumArtUrl: mediaItem.artUri?.toString() ?? '',
    );
    
    await setQueue([song]);
    await play();
  }

  @override
  Future<void> playFromMediaId(String mediaId, {Map<String, dynamic>? extras}) async {
    // Implementation for playing from media ID
    final index = _songQueue.indexWhere((song) => song.id == mediaId);
    if (index != -1) {
      _currentIndex = index;
      await _player.seek(Duration.zero, index: index);
      await play();
    }
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index >= 0 && index < _songQueue.length) {
      _currentIndex = index;
      await _player.seek(Duration.zero, index: index);
      await play();
    }
  }

  @override
  Future<void> seek(Duration position) async {
    await seekTo(position);
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    await setShuffleModeEnabled(shuffleMode == AudioServiceShuffleMode.all);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    LoopMode loopMode;
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        loopMode = LoopMode.off;
        break;
      case AudioServiceRepeatMode.one:
        loopMode = LoopMode.one;
        break;
      case AudioServiceRepeatMode.all:
      case AudioServiceRepeatMode.group:
        loopMode = LoopMode.all;
        break;
    }
    await setLoopMode(loopMode);
  }
}