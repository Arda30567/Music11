import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PlayerControls extends ConsumerWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const PlayerControls({
    super.key,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Previous Button
          _buildControlButton(
            icon: Icons.skip_previous,
            size: 32,
            onTap: onPrevious,
          )
              .animate()
              .scale(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 100),
              )
              .fadeIn(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 100),
              ),
          
          // Play/Pause Button
          _buildPlayPauseButton()
              .animate()
              .scale(
                duration: const Duration(milliseconds: 300),
                curve: Curves.elasticOut,
              )
              .fadeIn(
                duration: const Duration(milliseconds: 300),
              ),
          
          // Next Button
          _buildControlButton(
            icon: Icons.skip_next,
            size: 32,
            onTap: onNext,
          )
              .animate()
              .scale(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 200),
              )
              .fadeIn(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 200),
              ),
        ],
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return GestureDetector(
      onTap: onPlayPause,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required double size,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size + 16,
        height: size + 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: size,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

class PlayerProgressBar extends ConsumerWidget {
  final double progress;
  final Duration position;
  final Duration duration;
  final Function(Duration) onSeek;

  const PlayerProgressBar({
    super.key,
    required this.progress,
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Progress Bar
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveTrackColor: Theme.of(context).colorScheme.surface.withOpacity(0.3),
            thumbColor: Theme.of(context).colorScheme.primary,
            overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
          child: Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: (value) {
              final newPosition = Duration(
                milliseconds: (value * duration.inMilliseconds).round(),
              );
              onSeek(newPosition);
            },
          ),
        )
            .animate()
            .fadeIn(
              duration: const Duration(milliseconds: 400),
              delay: const Duration(milliseconds: 200),
            )
            .slideY(
              duration: const Duration(milliseconds: 400),
              delay: const Duration(milliseconds: 200),
              begin: 0.3,
              end: 0,
            ),
        
        // Time Labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 12,
                    ),
              ),
              Text(
                _formatDuration(duration),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(
              duration: const Duration(milliseconds: 400),
              delay: const Duration(milliseconds: 300),
            )
            .slideY(
              duration: const Duration(milliseconds: 400),
              delay: const Duration(milliseconds: 300),
              begin: 0.3,
              end: 0,
            ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }
}

class AlbumArtWidget extends ConsumerWidget {
  final double size;
  final double borderRadius;

  const AlbumArtWidget({
    super.key,
    this.size = 200,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider).value;
    final albumArtUrl = currentSong?.albumArtUrl ?? '';
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: albumArtUrl.isNotEmpty
            ? Image.network(
                albumArtUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildPlaceholder();
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder();
                },
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Center(
        child: Icon(
          Icons.music_note,
          size: size * 0.4,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class VinylAnimation extends StatelessWidget {
  final AnimationController controller;
  final double size;

  const VinylAnimation({
    super.key,
    required this.controller,
    this.size = 300,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: 2 * 3.14159 * controller.value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Colors.black87, Colors.black54],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Vinyl Grooves
                for (int i = 0; i < 8; i++)
                  Container(
                    width: size - (i * 20),
                    height: size - (i * 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 0.5,
                      ),
                    ),
                  ),
                
                // Center Label
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.music_note,
                      size: 30,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                
                // Center Hole
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WaveformVisualizer extends ConsumerWidget {
  final double size;
  final bool isPlaying;

  const WaveformVisualizer({
    super.key,
    this.size = 300,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.secondary.withOpacity(0.2),
            Colors.transparent,
          ],
          stops: const [0.3, 0.6, 1.0],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Concentric Circles
          for (int i = 0; i < 6; i++)
            AnimatedContainer(
              duration: Duration(milliseconds: 500 + i * 100),
              width: size * (0.2 + i * 0.13),
              height: size * (0.2 + i * 0.13),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isPlaying
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.6 - i * 0.1)
                      : Colors.transparent,
                  width: isPlaying ? 2.0 : 0.0,
                ),
              ),
            )
                .animate(
                  target: isPlaying ? 1 : 0,
                  onPlay: (controller) => isPlaying ? controller.repeat() : controller.stop(),
                )
                .scale(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.2, 1.2),
                )
                .fadeIn(
                  duration: const Duration(milliseconds: 500),
                ),
          
          // Center Pulse
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: isPlaying ? size * 0.15 : size * 0.1,
            height: isPlaying ? size * 0.15 : size * 0.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  blurRadius: isPlaying ? 20 : 10,
                  spreadRadius: isPlaying ? 5 : 2,
                ),
              ],
            ),
          )
              .animate(
                target: isPlaying ? 1 : 0,
                onPlay: (controller) => isPlaying ? controller.repeat() : controller.stop(),
              )
              .scale(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.3, 1.3),
              ),
        ],
      ),
    );
  }
}