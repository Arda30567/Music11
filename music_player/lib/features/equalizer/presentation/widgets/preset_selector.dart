import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PresetSelector extends ConsumerStatefulWidget {
  const PresetSelector({super.key});

  @override
  ConsumerState<PresetSelector> createState() => _PresetSelectorState();
}

class _PresetSelectorState extends ConsumerState<PresetSelector> {
  String selectedPreset = 'Flat';
  
  final List<EqualizerPreset> presets = [
    EqualizerPreset('Flat', [0.0, 0.0, 0.0, 0.0, 0.0]),
    EqualizerPreset('Rock', [4.0, 2.0, -2.0, 3.0, 6.0]),
    EqualizerPreset('Jazz', [3.0, 2.0, 1.0, 2.0, 1.0]),
    EqualizerPreset('Pop', [-1.0, 3.0, 4.0, 3.0, -1.0]),
    EqualizerPreset('Classical', [2.0, 1.0, 0.0, 1.0, 2.0]),
    EqualizerPreset('Electronic', [6.0, 4.0, 0.0, 2.0, 4.0]),
    EqualizerPreset('Hip Hop', [4.0, 2.0, 0.0, -2.0, 3.0]),
    EqualizerPreset('Acoustic', [2.0, 3.0, 2.0, 1.0, 0.0]),
  ];

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
            'Presets',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          
          // Preset Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemCount: presets.length,
            itemBuilder: (context, index) {
              return _buildPresetCard(presets[index], index);
            },
          ),
          
          const SizedBox(height: 16),
          
          // Custom Preset Button
          ElevatedButton.icon(
            onPressed: () => _saveCustomPreset(),
            icon: const Icon(Icons.save),
            label: const Text('Save as Custom Preset'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetCard(EqualizerPreset preset, int index) {
    final isSelected = selectedPreset == preset.name;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPreset = preset.name;
        });
        _applyPreset(preset);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              preset.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            _buildPresetVisualization(preset),
          ],
        ),
      )
          .animate()
          .scale(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          )
          .fadeIn(
            duration: const Duration(milliseconds: 200),
            delay: Duration(milliseconds: 50 * index),
          );
    );
  }

  Widget _buildPresetVisualization(EqualizerPreset preset) {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: preset.gains.map((gain) {
          final height = ((gain + 12) / 24 * 16).clamp(2.0, 16.0);
          return Container(
            width: 3,
            height: height,
            decoration: BoxDecoration(
              color: gain > 0
                  ? Colors.green.withOpacity(0.8)
                  : gain < 0
                      ? Colors.red.withOpacity(0.8)
                      : Colors.grey.withOpacity(0.8),
              borderRadius: BorderRadius.circular(1.5),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _applyPreset(EqualizerPreset preset) {
    // Apply preset gains to equalizer
    // This would update the equalizer bands
  }

  void _saveCustomPreset() {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Custom Preset'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter a name for your custom preset:'),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Preset Name',
                hintText: 'My Custom Preset',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                // Save custom preset
                Navigator.pop(context);
                _showSaveSuccess();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSaveSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Custom preset saved successfully!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      )
          .animate()
          .slideY(
            duration: const Duration(milliseconds: 300),
            begin: 1,
            end: 0,
          )
          .fadeIn(
            duration: const Duration(milliseconds: 300),
          ),
    );
  }
}

class EqualizerPreset {
  final String name;
  final List<double> gains;

  EqualizerPreset(this.name, this.gains);
}