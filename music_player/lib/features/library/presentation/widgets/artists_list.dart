import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ArtistsList extends ConsumerWidget {
  const ArtistsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artists = [
      {'name': 'The Weeknd', 'songs': 45, 'albums': 6, 'genre': 'R&B/Pop'},
      {'name': 'Taylor Swift', 'songs': 89, 'albums': 10, 'genre': 'Pop/Country'},
      {'name': 'Ed Sheeran', 'songs': 67, 'albums': 5, 'genre': 'Pop/Folk'},
      {'name': 'Dua Lipa', 'songs': 34, 'albums': 2, 'genre': 'Pop'},
      {'name': 'Harry Styles', 'songs': 23, 'albums': 3, 'genre': 'Pop/Rock'},
      {'name': 'Olivia Rodrigo', 'songs': 15, 'albums': 1, 'genre': 'Pop/Rock'},
      {'name': 'Billie Eilish', 'songs': 28, 'albums': 2, 'genre': 'Alternative Pop'},
      {'name': 'Drake', 'songs': 156, 'albums': 13, 'genre': 'Hip Hop/R&B'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: artists.length,
      itemBuilder: (context, index) {
        return _buildArtistItem(context, artists[index], index);
      },
    );
  }

  Widget _buildArtistItem(BuildContext context, Map<String, dynamic> artist, int index) {
    return ListTile(
      leading: Hero(
        tag: 'artist_${artist['name']}',
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
          child: const Icon(Icons.person, size: 24),
        ),
      ),
      title: Text(
        artist['name'],
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${artist['albums']} albums • ${artist['songs']} songs',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          Text(
            artist['genre'],
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.play_arrow, size: 20),
            onPressed: () {
              _playArtistSongs(artist);
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 20),
            onPressed: () {
              _showArtistOptions(artist);
            },
          ),
        ],
      ),
      onTap: () {
        _navigateToArtist(context, artist);
      },
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

  void _playArtistSongs(Map<String, dynamic> artist) {
    // Play all songs by this artist
  }

  void _showArtistOptions(Map<String, dynamic> artist) {
    // Show artist options menu
  }

  void _navigateToArtist(BuildContext context, Map<String, dynamic> artist) {
    // Navigate to artist detail page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${artist['name']}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}