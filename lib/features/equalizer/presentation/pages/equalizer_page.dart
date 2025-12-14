import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:music_player/features/equalizer/presentation/widgets/equalizer_bands.dart';
import 'package:music_player/features/equalizer/presentation/widgets/preset_selector.dart';
import 'package:music_player/features/equalizer/presentation/widgets/audio_effects.dart';

class EqualizerPage extends ConsumerStatefulWidget {
  const EqualizerPage({super.key});

  @override
  ConsumerState<EqualizerPage> createState() => _EqualizerPageState();
}

class _EqualizerPageState extends ConsumerState<EqualizerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equalizer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () => _resetEqualizer(),
            tooltip: 'Reset to default',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Equalizer Toggle
              _buildEqualizerToggle(),
              const SizedBox(height: 24),
              
              // Preset Selector
              const PresetSelector(),
              const SizedBox(height: 24),
              
              // Equalizer Bands
              const EqualizerBands(),
              const SizedBox(height: 24),
              
              // Audio Effects
              const AudioEffects(),
              const SizedBox(height: 24),
              
              // Advanced Settings
              _buildAdvancedSettings(),
            ]
                .animate(interval: const Duration(milliseconds: 100))
                .fadeIn(
                  duration: const Duration(milliseconds: 300),
                  delay: const Duration(milliseconds: 100),
                )
                .slideY(
                  duration: const Duration(milliseconds: 300),
                  delay: const Duration(milliseconds: 100),
                  begin: 0.3,
                  end: 0,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildEqualizerToggle() {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enable Equalizer',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Customize your audio experience',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
              ),
            ],
          ),
          Switch(
            value: true, // This would come from provider
            onChanged: (value) {
              // Toggle equalizer
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings() {
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
            'Advanced Settings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildAdvancedSettingItem(
            title: 'Limit Output',
            subtitle: 'Prevent audio clipping',
            value: true,
            onChanged: (value) {
              // Toggle limit output
            },
          ),
          _buildAdvancedSettingItem(
            title: 'Auto Gain Control',
            subtitle: 'Automatically adjust volume levels',
            value: false,
            onChanged: (value) {
              // Toggle auto gain control
            },
          ),
          _buildAdvancedSettingItem(
            title: 'Surround Sound',
            subtitle: 'Enable virtual surround effect',
            value: false,
            onChanged: (value) {
              // Toggle surround sound
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettingItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _resetEqualizer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Equalizer'),
        content: const Text('Are you sure you want to reset all equalizer settings to default?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Reset equalizer settings
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}