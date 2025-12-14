import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:debounce_throttle/debounce_throttle.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Debouncer _debouncer = Debouncer(const Duration(milliseconds: 300));
  
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            title: _buildSearchField(),
            actions: [
              if (_searchQuery.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                ),
            ],
          ),
          if (_searchQuery.isEmpty)
            _buildRecentSearches()
          else
            _buildSearchResults(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: 'Search songs, artists, albums...',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          prefixIcon: const Icon(Icons.search, size: 20),
        ),
        onChanged: (query) {
          _debouncer.run(() {
            setState(() {
              _searchQuery = query;
              _isSearching = query.isNotEmpty;
            });
            if (query.isNotEmpty) {
              _performSearch(query);
            }
          });
        },
        onSubmitted: (query) {
          if (query.isNotEmpty) {
            _performSearch(query);
          }
        },
      ),
    );
  }

  Widget _buildRecentSearches() {
    final recentSearches = [
      'Taylor Swift',
      'The Weeknd',
      'Billie Eilish',
      'Drake',
      'Ariana Grande',
    ];

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const Text(
            'Recent Searches',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )
              .animate()
              .fadeIn(
                duration: const Duration(milliseconds: 300),
                delay: const Duration(milliseconds: 100),
              )
              .slideX(
                duration: const Duration(milliseconds: 300),
                delay: const Duration(milliseconds: 100),
                begin: -0.3,
                end: 0,
              ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: recentSearches.map((search) => 
              _buildRecentSearchChip(search)
            ).toList(),
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
          const SizedBox(height: 32),
          const Text(
            'Browse Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )
              .animate()
              .fadeIn(
                duration: const Duration(milliseconds: 300),
                delay: const Duration(milliseconds: 300),
              )
              .slideX(
                duration: const Duration(milliseconds: 300),
                delay: const Duration(milliseconds: 300),
                begin: -0.3,
                end: 0,
              ),
          const SizedBox(height: 16),
          _buildCategoriesGrid(),
        ]),
      ),
    );
  }

  Widget _buildRecentSearchChip(String search) {
    return GestureDetector(
      onTap: () {
        _searchController.text = search;
        setState(() {
          _searchQuery = search;
          _isSearching = true;
        });
        _performSearch(search);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history, size: 16),
            const SizedBox(width: 8),
            Text(search),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                // Remove from recent searches
              },
              child: const Icon(Icons.close, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    final categories = [
      {'name': 'Pop', 'icon': Icons.music_note, 'color': Colors.pink},
      {'name': 'Rock', 'icon': Icons.guitar, 'color': Colors.red},
      {'name': 'Hip Hop', 'icon': Icons.mic, 'color': Colors.purple},
      {'name': 'Jazz', 'icon': Icons.piano, 'color': Colors.blue},
      {'name': 'Electronic', 'icon': Icons.headphones, 'color': Colors.green},
      {'name': 'Classical', 'icon': Icons.violin, 'color': Colors.brown},
      {'name': 'R&B', 'icon': Icons.music_video, 'color': Colors.orange},
      {'name': 'Country', 'icon': Icons.music_off, 'color': Colors.amber},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(
          name: category['name'] as String,
          icon: category['icon'] as IconData,
          color: category['color'] as Color,
        );
      },
    )
        .animate()
        .fadeIn(
          duration: const Duration(milliseconds: 400),
          delay: const Duration(milliseconds: 400),
        )
        .slideY(
          duration: const Duration(milliseconds: 400),
          delay: const Duration(milliseconds: 400),
          begin: 0.3,
          end: 0,
        );
  }

  Widget _buildCategoryCard({
    required String name,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        _searchController.text = name;
        setState(() {
          _searchQuery = name;
          _isSearching = true;
        });
        _performSearch(name);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.8),
              color.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    // Mock search results
    final results = [
      {'type': 'song', 'title': 'Blinding Lights', 'artist': 'The Weeknd'},
      {'type': 'song', 'title': 'Shape of You', 'artist': 'Ed Sheeran'},
      {'type': 'album', 'title': 'After Hours', 'artist': 'The Weeknd'},
      {'type': 'artist', 'title': 'The Weeknd', 'artist': 'Artist'},
      {'type': 'song', 'title': 'Watermelon Sugar', 'artist': 'Harry Styles'},
    ];

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final result = results[index];
            return _buildSearchResultItem(result);
          },
          childCount: results.length,
        ),
      ),
    );
  }

  Widget _buildSearchResultItem(Map<String, dynamic> result) {
    IconData icon;
    switch (result['type']) {
      case 'song':
        icon = Icons.music_note;
        break;
      case 'album':
        icon = Icons.album;
        break;
      case 'artist':
        icon = Icons.person;
        break;
      default:
        icon = Icons.music_note;
    }

    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon),
      ),
      title: Text(
        result['title'],
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(result['artist']),
      trailing: result['type'] == 'song'
          ? IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                // Play song
              },
            )
          : null,
      onTap: () {
        // Handle tap based on type
        switch (result['type']) {
          case 'song':
            // Play song
            break;
          case 'album':
            // Navigate to album
            break;
          case 'artist':
            // Navigate to artist
            break;
        }
      },
    )
        .animate()
        .fadeIn(
          duration: const Duration(milliseconds: 300),
          delay: Duration(milliseconds: 100 * (results.indexOf(result) % 5)),
        )
        .slideX(
          duration: const Duration(milliseconds: 300),
          delay: Duration(milliseconds: 100 * (results.indexOf(result) % 5)),
          begin: -0.3,
          end: 0,
        );
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _isSearching = false;
    });
    _focusNode.requestFocus();
  }

  void _performSearch(String query) {
    // Implement actual search logic here
    print('Searching for: $query');
  }
}