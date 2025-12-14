import 'package:flutter/material.dart';

class LibraryTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final int currentTab;

  const LibraryTabBar({
    super.key,
    required this.tabController,
    required this.currentTab,
  });

  @override
  Widget build(BuildContext context) {
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
  Size get preferredSize => const Size.fromHeight(48);
}