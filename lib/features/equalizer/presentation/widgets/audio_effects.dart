import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AudioEffects extends ConsumerStatefulWidget {
  const AudioEffects({super.key});

  @override
  ConsumerState<AudioEffects> createState() => _AudioEffectsState();
}

class _AudioEffectsState extends ConsumerState<AudioEffects> {
  double bassBoost = 0.0;
  double virtualizer = 0.0;
  double reverb = 0.0;
  bool isLoudnessEnabled = false;

  @override
  Widget build(BuildContext context) {
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
            'Audio Effects',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          
          // Bass Boost
          _buildEffectSlider(
            title: 'Bass Boost',
            subtitle: 'Enhance low frequencies',
            icon: Icons.speaker,
            value: bassBoost,
            min: 0,
            max: 100,
            onChanged: (value) {
              setState(() {
                bassBoost = value;
              });
            },
            color: Colors.deepPurple,
          ),
          
          const SizedBox(height: 16),
          
          // Virtualizer
          _buildEffectSlider(
            title: 'Virtualizer',
            subtitle: 'Create spatial audio effect',
            icon: Icons.surround_sound,
            value: virtualizer,
            min: 0,
            max: 100,
            onChanged: (value) {
              setState(() {
                virtualizer = value;
              });
            },
            color: Colors.blue,
          ),
          
          const SizedBox(height: 16),
          
          // Reverb
          _buildEffectSlider(
            title: 'Reverb',
            subtitle: 'Add echo and depth',
            icon: Icons.echo,
            value: reverb,
            min: 0,
            max: 100,
            onChanged: (value) {
              setState(() {
                reverb = value;
              });
            },
            color: Colors.teal,
          ),
          
          const SizedBox(height: 20),
          
          // Loudness Enhancement
          _buildLoudnessEnhancement(),
        ],
      ),
    );
  }

  Widget _buildEffectSlider({
    required String title,
    required String subtitle,
    required IconData icon,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.2),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
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
            ),
            Text(
              '${value.toInt()}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
            activeTrackColor: color,
            inactiveTrackColor: Theme.of(context).colorScheme.surfaceVariant,
            thumbColor: color,
            overlayColor: color.withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: 20,
            label: '${value.toInt()}%',
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildLoudnessEnhancement() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.withOpacity(0.2),
                ),
                child: const Icon(Icons.volume_up, color: Colors.orange, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Loudness Enhancement',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    'Improve audio quality at low volumes',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: isLoudnessEnabled,
            onChanged: (value) {
              setState(() {
                isLoudnessEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}