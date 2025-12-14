import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:music_player/features/library/presentation/widgets/songs_list.dart';
import 'package:music_player/features/library/presentation/widgets/albums_grid.dart';
import 'package:music_player/features/library/presentation/widgets/artists_list.dart';
import 'package:music_player/features/library/presentation/widgets/playlists_list.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTab = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Library',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Navigate to search
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.sort),
                  onPressed: () => _showSortOptions(context),
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverPersistentHeader(
              delegate: LibraryTabBarDelegate(
                tabController: _tabController,
                currentTab: _currentTab,
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: const [
            SongsList(),
            AlbumsGrid(),
            ArtistsList(),
            PlaylistsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOptions(context),
        child: const Icon(Icons.add),
      )
          .animate()
          .scale(
            duration: const Duration(milliseconds: 300),
            delay: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          )
          .fadeIn(
            duration: const Duration(milliseconds: 300),
            delay: const Duration(milliseconds: 500),
          ),
    );
  }

  void _showSortOptions(BuildContext context) {
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
            const Text(
              'Sort By',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.title),
              title: const Text('Title'),
              onTap: () {
                Navigator.pop(context);
                // Implement sort
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Artist'),
              onTap: () {
                Navigator.pop(context);
                // Implement sort
              },
            ),
            ListTile(
              leading: const Icon(Icons.album),
              title: const Text('Album'),
              onTap: () {
                Navigator.pop(context);
                // Implement sort
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Recently Added'),
              onTap: () {
                Navigator.pop(context);
                // Implement sort
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
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
            const Text(
              'Add to Library',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Create Playlist'),
              onTap: () {
                Navigator.pop(context);
                _showCreatePlaylistDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: const Text('Import from Device'),
              onTap: () {
                Navigator.pop(context);
                // Implement import
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_download),
              title: const Text('Download Music'),
              onTap: () {
                Navigator.pop(context);
                // Implement download
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Playlist'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Playlist Name',
            hintText: 'My Awesome Playlist',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                // Create playlist
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class LibraryTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final int currentTab;

  LibraryTabBarDelegate({
    required this.tabController,
    required this.currentTab,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        tabs: const [
          Tab(text: 'Songs'),
          Tab(text: 'Albums'),
          Tab(text: 'Artists'),
          Tab(text: 'Playlists'),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}