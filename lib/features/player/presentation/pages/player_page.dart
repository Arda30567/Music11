import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:music_player/features/player/presentation/widgets/player_controls.dart';
import 'package:music_player/features/player/presentation/widgets/album_art_widget.dart';
import 'package:music_player/features/player/presentation/widgets/progress_bar.dart';
import 'package:music_player/features/player/presentation/widgets/vinyl_animation.dart';
import 'package:music_player/features/player/presentation/widgets/waveform_visualizer.dart';
import 'package:music_player/features/player/presentation/providers/audio_providers.dart';
import 'package:music_player/core/theme/app_theme.dart';

class PlayerPage extends ConsumerStatefulWidget {
  const PlayerPage({super.key});

  @override
  ConsumerState<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends ConsumerState<PlayerPage> with TickerProviderStateMixin {
  late AnimationController _albumArtController;
  late AnimationController _backgroundController;
  bool _showVinyl = false;
  bool _showWaveform = false;

  @override
  void initState() {
    super.initState();
    _albumArtController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _albumArtController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = ref.watch(currentSongProvider).value;
    final isPlaying = ref.watch(isPlayingProvider).value ?? false;
    final progress = ref.watch(progressProvider).value;

    if (isPlaying) {
      _albumArtController.repeat();
    } else {
      _albumArtController.stop();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, size: 24),
            onPressed: () => _showPlayerMenu(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Animated Background
          _buildAnimatedBackground(),
          
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Album Art Section
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: _buildAlbumArtSection(),
                  ),
                ),
                
                // Song Info Section
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildSongInfoSection(),
                  ),
                ),
                
                // Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: PlayerProgressBar(
                    progress: progress?.progress ?? 0.0,
                    position: progress?.position ?? Duration.zero,
                    duration: progress?.duration ?? Duration.zero,
                    onSeek: (position) {
                      ref.read(audioPlayerProvider).seekTo(position);
                    },
                  ),
                ),
                
                // Controls
                Expanded(
                  flex: 1,
                  child: PlayerControls(
                    isPlaying: isPlaying,
                    onPlayPause: () {
                      if (isPlaying) {
                        ref.read(audioPlayerProvider).pause();
                      } else {
                        ref.read(audioPlayerProvider).resume();
                      }
                    },
                    onNext: () => ref.read(audioPlayerProvider).skipToNext(),
                    onPrevious: () => ref.read(audioPlayerProvider).skipToPrevious(),
                  ),
                ),
                
                // Bottom Actions
                _buildBottomActions(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.3),
                Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
                Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ],
              stops: [
                0.0,
                0.33 + 0.1 * _backgroundController.value,
                0.66 + 0.1 * _backgroundController.value,
                1.0,
              ],
              transform: GradientRotation(2 * 3.14159 * _backgroundController.value),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlbumArtSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Effects
        if (_showVinyl)
          VinylAnimation(
            controller: _albumArtController,
            size: 300,
          )
        else if (_showWaveform)
          WaveformVisualizer(
            size: 300,
            isPlaying: ref.watch(isPlayingProvider).value ?? false,
          ),
        
        // Album Art
        Hero(
          tag: 'album_art_${ref.watch(currentSongProvider).value?.id ?? ''}',
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (_showVinyl) {
                  _showVinyl = false;
                  _showWaveform = true;
                } else if (_showWaveform) {
                  _showWaveform = false;
                } else {
                  _showVinyl = true;
                }
              });
            },
            child: AlbumArtWidget(
              size: 280,
              borderRadius: 20,
            ),
          ),
        )
            .animate()
            .scale(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            )
            .fadeIn(
              duration: const Duration(milliseconds: 300),
            ),
      ],
    );
  }

  Widget _buildSongInfoSection() {
    final currentSong = ref.watch(currentSongProvider).value;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Song Title
        Text(
          currentSong?.title ?? 'No Song Playing',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        )
            .animate()
            .fadeIn(
              duration: const Duration(milliseconds: 400),
              delay: const Duration(milliseconds: 200),
            )
            .slideY(
              duration: const Duration(milliseconds: 400),
              begin: 0.3,
              end: 0,
            ),
        
        const SizedBox(height: 8),
        
        // Artist and Album
        Text(
          currentSong?.displaySubtitle ?? 'Unknown Artist',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontSize: 16,
              ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
            .animate()
            .fadeIn(
              duration: const Duration(milliseconds: 400),
              delay: const Duration(milliseconds: 300),
            )
            .slideY(
              duration: const Duration(milliseconds: 400),
              begin: 0.3,
              end: 0,
            ),
        
        const SizedBox(height: 24),
        
        // Playback Info
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInfoChip(
              icon: Icons.speed,
              label: '${ref.watch(playbackSpeedProvider)}x',
              onTap: () => _showSpeedDialog(context),
            ),
            const SizedBox(width: 12),
            _buildInfoChip(
              icon: Icons.volume_up,
              label: '${(ref.watch(volumeProvider) * 100).toInt()}%',
              onTap: () => _showVolumeDialog(context),
            ),
            const SizedBox(width: 12),
            _buildInfoChip(
              icon: Icons.queue_music,
              label: '${ref.watch(queueProvider).length}',
              onTap: () => _showQueueDialog(context),
            ),
          ],
        )
            .animate()
            .fadeIn(
              duration: const Duration(milliseconds: 400),
              delay: const Duration(milliseconds: 400),
            )
            .slideY(
              duration: const Duration(milliseconds: 400),
              begin: 0.3,
              end: 0,
            ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.favorite_border, size: 24),
            onPressed: () => _toggleFavorite(),
          ),
          IconButton(
            icon: Icon(
              ref.watch(shuffleModeProvider) ? Icons.shuffle : Icons.shuffle_outlined,
              size: 24,
            ),
            onPressed: () => _toggleShuffle(),
          ),
          IconButton(
            icon: Icon(
              _getRepeatIcon(),
              size: 24,
            ),
            onPressed: () => _toggleRepeat(),
          ),
          IconButton(
            icon: const Icon(Icons.playlist_add, size: 24),
            onPressed: () => _showAddToPlaylistDialog(),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: const Duration(milliseconds: 400),
          delay: const Duration(milliseconds: 500),
        )
        .slideY(
          duration: const Duration(milliseconds: 400),
          begin: 0.3,
          end: 0,
        );
  }

  IconData _getRepeatIcon() {
    final repeatMode = ref.watch(repeatModeProvider);
    switch (repeatMode) {
      case RepeatMode.off:
        return Icons.repeat_outlined;
      case RepeatMode.one:
        return Icons.repeat_one;
      case RepeatMode.all:
        return Icons.repeat;
    }
  }

  void _toggleFavorite() {
    // Implementation for toggling favorite
  }

  void _toggleShuffle() {
    final current = ref.read(shuffleModeProvider.notifier);
    current.state = !current.state;
  }

  void _toggleRepeat() {
    final current = ref.read(repeatModeProvider.notifier);
    switch (current.state) {
      case RepeatMode.off:
        current.state = RepeatMode.all;
        break;
      case RepeatMode.all:
        current.state = RepeatMode.one;
        break;
      case RepeatMode.one:
        current.state = RepeatMode.off;
        break;
    }
  }

  void _showPlayerMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.equalizer),
              title: const Text('Equalizer'),
              onTap: () {
                Navigator.pop(context);
                _showEqualizerDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lyrics),
              title: const Text('Lyrics'),
              onTap: () {
                Navigator.pop(context);
                _showLyricsDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Song Info'),
              onTap: () {
                Navigator.pop(context);
                _showSongInfoDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSpeedDialog(BuildContext context) {
    final speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Playback Speed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: speeds.map((speed) => RadioListTile<double>(
            title: Text('${speed}x'),
            value: speed,
            groupValue: ref.read(playbackSpeedProvider),
            onChanged: (value) {
              if (value != null) {
                ref.read(playbackSpeedProvider.notifier).state = value;
                Navigator.pop(context);
              }
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showVolumeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Volume'),
        content: Slider(
          value: ref.read(volumeProvider),
          min: 0.0,
          max: 1.0,
          divisions: 20,
          label: '${(ref.read(volumeProvider) * 100).toInt()}%',
          onChanged: (value) {
            ref.read(volumeProvider.notifier).state = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showQueueDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Queue'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: ref.read(queueProvider).length,
            itemBuilder: (context, index) {
              final song = ref.read(queueProvider)[index];
              return ListTile(
                title: Text(song.title),
                subtitle: Text(song.artist),
                trailing: Icon(
                  index == ref.read(currentIndexProvider) 
                      ? Icons.play_arrow 
                      : null,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onTap: () {
                  ref.read(currentIndexProvider.notifier).state = index;
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showEqualizerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Equalizer'),
        content: const Text('Equalizer settings will be implemented'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLyricsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lyrics'),
        content: const Text('Lyrics will be displayed here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSongInfoDialog(BuildContext context) {
    final currentSong = ref.watch(currentSongProvider).value;
    if (currentSong == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Song Information'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Title: ${currentSong.title}'),
            Text('Artist: ${currentSong.artist}'),
            Text('Album: ${currentSong.album}'),
            Text('Duration: ${currentSong.formattedDuration}'),
            Text('ID: ${currentSong.id}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAddToPlaylistDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Playlist'),
        content: const Text('Playlist selection will be implemented'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}