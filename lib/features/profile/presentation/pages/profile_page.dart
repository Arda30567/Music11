import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:music_player/core/theme/app_theme.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeaderBackground(),
              title: const Text('Profile'),
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildProfileCard(),
                const SizedBox(height: 24),
                _buildStatsSection(),
                const SizedBox(height: 24),
                _buildListeningStats(),
                const SizedBox(height: 24),
                _buildSettingsSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
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
        children: [
          // Profile Picture
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
            ),
            child: const Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          )
              .animate()
              .scale(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
              )
              .fadeIn(
                duration: const Duration(milliseconds: 400),
              ),
          
          const SizedBox(height: 16),
          
          // User Name
          Text(
            'Music Lover',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          )
              .animate()
              .fadeIn(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 100),
              )
              .slideY(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 100),
                begin: 0.3,
                end: 0,
              ),
          
          const SizedBox(height: 8),
          
          // Member Since
          Text(
            'Member since 2024',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
          
          const SizedBox(height: 24),
          
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.edit,
                label: 'Edit Profile',
                onTap: () => _editProfile(),
              ),
              _buildActionButton(
                icon: Icons.share,
                label: 'Share Profile',
                onTap: () => _shareProfile(),
              ),
            ],
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
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            child: Icon(
              icon,
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Text(
            'Your Stats',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('1,234', 'Songs Played'),
              _buildStatItem('56', 'Hours'),
              _buildStatItem('89', 'Playlists'),
              _buildStatItem('12', 'Favorites'),
            ],
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
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
      ],
    );
  }

  Widget _buildListeningStats() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Text(
            'Listening Habits',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          )
              .animate()
              .fadeIn(
                duration: const Duration(milliseconds: 300),
                delay: const Duration(milliseconds: 200),
              )
              .slideX(
                duration: const Duration(milliseconds: 300),
                delay: const Duration(milliseconds: 200),
                begin: -0.3,
                end: 0,
              ),
          const SizedBox(height: 20),
          _buildHabitItem('Top Genre', 'Pop Rock', Icons.music_note),
          const SizedBox(height: 16),
          _buildHabitItem('Most Played Artist', 'Taylor Swift', Icons.person),
          const SizedBox(height: 16),
          _buildHabitItem('Favorite Time', 'Evening', Icons.access_time),
          const SizedBox(height: 16),
          _buildHabitItem('Listening Streak', '12 days', Icons.local_fire_department),
        ]
            .animate(interval: const Duration(milliseconds: 100))
            .fadeIn(
              duration: const Duration(milliseconds: 300),
              delay: const Duration(milliseconds: 300),
            )
            .slideY(
              duration: const Duration(milliseconds: 300),
              delay: const Duration(milliseconds: 300),
              begin: 0.3,
              end: 0,
            ),
      ),
    );
  }

  Widget _buildHabitItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Text(
            'Settings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
          _buildSettingItem(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () => _navigateToNotifications(),
          ),
          _buildSettingItem(
            icon: Icons.privacy_tip,
            title: 'Privacy',
            onTap: () => _navigateToPrivacy(),
          ),
          _buildSettingItem(
            icon: Icons.storage,
            title: 'Storage',
            onTap: () => _navigateToStorage(),
          ),
          _buildSettingItem(
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () => _navigateToHelp(),
          ),
          _buildSettingItem(
            icon: Icons.info,
            title: 'About',
            onTap: () => _navigateToAbout(),
          ),
        ]
            .animate(interval: const Duration(milliseconds: 50))
            .fadeIn(
              duration: const Duration(milliseconds: 300),
              delay: const Duration(milliseconds: 400),
            )
            .slideY(
              duration: const Duration(milliseconds: 300),
              delay: const Duration(milliseconds: 400),
              begin: 0.3,
              end: 0,
            ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _editProfile() {
    // Implement edit profile
  }

  void _shareProfile() {
    // Implement share profile
  }

  void _navigateToNotifications() {
    // Implement notifications settings
  }

  void _navigateToPrivacy() {
    // Implement privacy settings
  }

  void _navigateToStorage() {
    // Implement storage settings
  }

  void _navigateToHelp() {
    // Implement help & support
  }

  void _navigateToAbout() {
    // Implement about page
  }
}