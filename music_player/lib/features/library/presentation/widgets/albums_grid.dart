import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AlbumsGrid extends ConsumerWidget {
  const AlbumsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albums = [
      {'title': 'After Hours', 'artist': 'The Weeknd', 'songs': 14, 'year': '2020'},
      {'title': 'Future Nostalgia', 'artist': 'Dua Lipa', 'songs': 11, 'year': '2020'},
      {'title': 'Fine Line', 'artist': 'Harry Styles', 'songs': 12, 'year': '2019'},
      {'title': 'SOUR', 'artist': 'Olivia Rodrigo', 'songs': 11, 'year': '2021'},
      {'title': '÷ (Divide)', 'artist': 'Ed Sheeran', 'songs': 16, 'year': '2017'},
      {'title': 'Planet Her', 'artist': 'Doja Cat', 'songs': 14, 'year': '2021'},
      {'title': 'Happier Than Ever', 'artist': 'Billie Eilish', 'songs': 16, 'year': '2021'},
      {'title': 'Montero', 'artist': 'Lil Nas X', 'songs': 15, 'year': '2021'},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return _buildAlbumCard(context, album, index);
      },
    );
  }

  Widget _buildAlbumCard(BuildContext context, Map<String, dynamic> album, int index) {
    return GestureDetector(
      onTap: () {
        // Navigate to album details
        _navigateToAlbum(context, album);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album Art
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.album, size: 48, color: Colors.white54),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.play_circle_filled,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Album Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          album['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          album['artist'],
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${album['songs']} songs',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          album['year'],
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(
            duration: const Duration(milliseconds: 300),
            delay: Duration(milliseconds: 50 * index),
          )
          .scale(
            duration: const Duration(milliseconds: 300),
            delay: Duration(milliseconds: 50 * index),
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
    );
  }

  void _navigateToAlbum(BuildContext context, Map<String, dynamic> album) {
    // Navigate to album detail page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${album['title']}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}