import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PlaylistsList extends ConsumerWidget {
  const PlaylistsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = [
      {'name': 'Favorites', 'songs': 89, 'type': 'smart', 'description': 'Your favorite songs'},
      {'name': 'Workout Mix', 'songs': 45, 'type': 'custom', 'description': 'High energy workout tracks'},
      {'name': 'Chill Vibes', 'songs': 67, 'type': 'custom', 'description': 'Relaxing and calm music'},
      {'name': 'Road Trip', 'songs': 123, 'type': 'custom', 'description': 'Perfect for long drives'},
      {'name': 'Late Night', 'songs': 34, 'type': 'custom', 'description': 'Night time listening'},
      {'name': 'Recently Added', 'songs': 56, 'type': 'smart', 'description': 'Recently added to library'},
      {'name': 'Top 2024', 'songs': 78, 'type': 'custom', 'description': 'Best songs of 2024'},
      {'name': 'Throwback', 'songs': 92, 'type': 'custom', 'description': 'Classic hits'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        return _buildPlaylistItem(context, playlists[index], index);
      },
    );
  }

  Widget _buildPlaylistItem(BuildContext context, Map<String, dynamic> playlist, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: playlist['type'] == 'smart'
                ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                : Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            playlist['type'] == 'smart' ? Icons.auto_awesome : Icons.playlist_play,
            color: playlist['type'] == 'smart'
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            size: 24,
          ),
        ),
        title: Text(
          playlist['name'],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${playlist['songs']} songs',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            Text(
              playlist['description'],
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.shuffle, size: 20),
              onPressed: () {
                _shufflePlaylist(playlist);
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, size: 20),
              onPressed: () {
                _showPlaylistOptions(playlist);
              },
            ),
          ],
        ),
        onTap: () {
          _openPlaylist(context, playlist);
        },
      ),
    )
        .animate()
        .fadeIn(
          duration: const Duration(milliseconds: 300),
          delay: Duration(milliseconds: 50 * index),
        )
        .slideX(
          duration: const Duration(milliseconds: 300),
          delay: Duration(milliseconds: 50 * index),
          begin: -0.3,
          end: 0,
        );
  }

  void _shufflePlaylist(Map<String, dynamic> playlist) {
    // Shuffle and play playlist
  }

  void _showPlaylistOptions(Map<String, dynamic> playlist) {
    // Show playlist options menu
  }

  void _openPlaylist(BuildContext context, Map<String, dynamic> playlist) {
    // Open playlist
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${playlist['name']}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}