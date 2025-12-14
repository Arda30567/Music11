import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:music_player/features/player/domain/entities/song.dart';

class SongsList extends ConsumerWidget {
  const SongsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock songs data
    final songs = [
      Song(
        id: '1',
        title: 'Blinding Lights',
        artist: 'The Weeknd',
        album: 'After Hours',
        duration: 200000,
        audioUrl: '',
        albumArtUrl: '',
        isFavorite: true,
        playCount: 156,
      ),
      Song(
        id: '2',
        title: 'Shape of You',
        artist: 'Ed Sheeran',
        album: '÷ (Divide)',
        duration: 233000,
        audioUrl: '',
        albumArtUrl: '',
        isFavorite: false,
        playCount: 89,
      ),
      Song(
        id: '3',
        title: 'Watermelon Sugar',
        artist: 'Harry Styles',
        album: 'Fine Line',
        duration: 174000,
        audioUrl: '',
        albumArtUrl: '',
        isFavorite: true,
        playCount: 234,
      ),
      Song(
        id: '4',
        title: 'Levitating',
        artist: 'Dua Lipa',
        album: 'Future Nostalgia',
        duration: 203000,
        audioUrl: '',
        albumArtUrl: '',
        isFavorite: false,
        playCount: 67,
      ),
      Song(
        id: '5',
        title: 'Good 4 U',
        artist: 'Olivia Rodrigo',
        album: 'SOUR',
        duration: 178000,
        audioUrl: '',
        albumArtUrl: '',
        isFavorite: true,
        playCount: 145,
      ),
    ];

    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return _buildSongItem(songs[index], index);
      },
    );
  }

  Widget _buildSongItem(Song song, int index) {
    return ListTile(
      leading: Hero(
        tag: 'song_art_${song.id}',
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.music_note),
        ),
      ),
      title: Text(
        song.title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${song.artist} • ${song.album}',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (song.isFavorite == true)
            const Icon(Icons.favorite, color: Colors.red, size: 20)
                .animate()
                .scale(
                  duration: const Duration(milliseconds: 200),
                  delay: Duration(milliseconds: 50 * index),
                ),
          const SizedBox(width: 8),
          Text(
            song.formattedDuration,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 20),
            onPressed: () => _showSongOptions(song),
          ),
        ],
      ),
      onTap: () {
        // Play song
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

  void _showSongOptions(Song song) {
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
              leading: const Icon(Icons.play_arrow),
              title: const Text('Play'),
              onTap: () {
                Navigator.pop(context);
                // Play song
              },
            ),
            ListTile(
              leading: const Icon(Icons.queue),
              title: const Text('Add to Queue'),
              onTap: () {
                Navigator.pop(context);
                // Add to queue
              },
            ),
            ListTile(
              leading: Icon(song.isFavorite == true ? Icons.favorite : Icons.favorite_border),
              title: Text(song.isFavorite == true ? 'Remove from Favorites' : 'Add to Favorites'),
              onTap: () {
                Navigator.pop(context);
                // Toggle favorite
              },
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Add to Playlist'),
              onTap: () {
                Navigator.pop(context);
                // Add to playlist
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                // Share song
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Song Info'),
              onTap: () {
                Navigator.pop(context);
                // Show song info
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AlbumsGrid extends ConsumerWidget {
  const AlbumsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albums = [
      {'title': 'After Hours', 'artist': 'The Weeknd', 'songs': 14},
      {'title': 'Future Nostalgia', 'artist': 'Dua Lipa', 'songs': 11},
      {'title': 'Fine Line', 'artist': 'Harry Styles', 'songs': 12},
      {'title': 'SOUR', 'artist': 'Olivia Rodrigo', 'songs': 11},
      {'title': '÷ (Divide)', 'artist': 'Ed Sheeran', 'songs': 16},
      {'title': 'Planet Her', 'artist': 'Doja Cat', 'songs': 14},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return _buildAlbumCard(album, index);
      },
    );
  }

  Widget _buildAlbumCard(Map<String, dynamic> album, int index) {
    return GestureDetector(
      onTap: () {
        // Navigate to album
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
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: const Center(
                child: Icon(Icons.album, size: 48),
              ),
            ),
            
            // Album Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    album['artist'],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${album['songs']} songs',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
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
          );
    );
  }
}

class ArtistsList extends ConsumerWidget {
  const ArtistsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artists = [
      {'name': 'The Weeknd', 'songs': 45, 'albums': 6},
      {'name': 'Taylor Swift', 'songs': 89, 'albums': 10},
      {'name': 'Ed Sheeran', 'songs': 67, 'albums': 5},
      {'name': 'Dua Lipa', 'songs': 34, 'albums': 2},
      {'name': 'Harry Styles', 'songs': 23, 'albums': 3},
      {'name': 'Olivia Rodrigo', 'songs': 15, 'albums': 1},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: artists.length,
      itemBuilder: (context, index) {
        return _buildArtistItem(artists[index], index);
      },
    );
  }

  Widget _buildArtistItem(Map<String, dynamic> artist, int index) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        child: const Icon(Icons.person),
      ),
      title: Text(
        artist['name'],
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        '${artist['albums']} albums • ${artist['songs']} songs',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          fontSize: 14,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          // Show artist options
        },
      ),
      onTap: () {
        // Navigate to artist
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
}

class PlaylistsList extends ConsumerWidget {
  const PlaylistsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = [
      {'name': 'Favorites', 'songs': 89, 'type': 'smart'},
      {'name': 'Workout Mix', 'songs': 45, 'type': 'custom'},
      {'name': 'Chill Vibes', 'songs': 67, 'type': 'custom'},
      {'name': 'Road Trip', 'songs': 123, 'type': 'custom'},
      {'name': 'Late Night', 'songs': 34, 'type': 'custom'},
      {'name': 'Recently Added', 'songs': 56, 'type': 'smart'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        return _buildPlaylistItem(playlists[index], index);
      },
    );
  }

  Widget _buildPlaylistItem(Map<String, dynamic> playlist, int index) {
    return ListTile(
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
              : null,
        ),
      ),
      title: Text(
        playlist['name'],
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        '${playlist['songs']} songs',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          fontSize: 14,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (playlist['type'] == 'smart')
            Icon(
              Icons.auto_awesome,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show playlist options
            },
          ),
        ],
      ),
      onTap: () {
        // Navigate to playlist
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
}