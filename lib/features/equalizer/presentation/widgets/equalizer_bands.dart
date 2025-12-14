import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EqualizerBands extends ConsumerStatefulWidget {
  const EqualizerBands({super.key});

  @override
  ConsumerState<EqualizerBands> createState() => _EqualizerBandsState();
}

class _EqualizerBandsState extends ConsumerState<EqualizerBands> {
  final List<EqualizerBandData> bands = [
    EqualizerBandData(frequency: 60, gain: 0.0, color: Colors.red),
    EqualizerBandData(frequency: 230, gain: 0.0, color: Colors.orange),
    EqualizerBandData(frequency: 910, gain: 0.0, color: Colors.yellow),
    EqualizerBandData(frequency: 3600, gain: 0.0, color: Colors.green),
    EqualizerBandData(frequency: 14000, gain: 0.0, color: Colors.blue),
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
            'Equalizer Bands',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          
          // Equalizer Visualization
          Container(
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomPaint(
              painter: EqualizerPainter(bands: bands),
              size: Size.infinite,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Band Controls
          ...bands.map((band) => _buildBandControl(band)).toList(),
        ],
      ),
    );
  }

  Widget _buildBandControl(EqualizerBandData band) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Frequency Label
          SizedBox(
            width: 60,
            child: Text(
              '${band.frequency}Hz',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          
          // Slider
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
                activeTrackColor: band.color,
                inactiveTrackColor: Theme.of(context).colorScheme.surfaceVariant,
                thumbColor: band.color,
                overlayColor: band.color.withOpacity(0.2),
              ),
              child: Slider(
                value: band.gain,
                min: -12,
                max: 12,
                divisions: 24,
                label: '${band.gain.toStringAsFixed(1)}dB',
                onChanged: (value) {
                  setState(() {
                    band.gain = value;
                  });
                },
              ),
            ),
          ),
          
          // Gain Value
          SizedBox(
            width: 50,
            child: Text(
              '${band.gain.toStringAsFixed(1)}dB',
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: band.color,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class EqualizerBandData {
  final double frequency;
  double gain;
  final Color color;

  EqualizerBandData({
    required this.frequency,
    required this.gain,
    required this.color,
  });
}

class EqualizerPainter extends CustomPainter {
  final List<EqualizerBandData> bands;

  EqualizerPainter({required this.bands});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final barWidth = size.width / bands.length * 0.6;
    final spacing = size.width / bands.length * 0.4;
    
    for (int i = 0; i < bands.length; i++) {
      final band = bands[i];
      final x = i * (barWidth + spacing) + spacing / 2;
      final normalizedGain = (band.gain + 12) / 24; // Normalize from -12 to 12 to 0 to 1
      final barHeight = normalizedGain * size.height;
      final y = size.height - barHeight;
      
      // Create gradient for each bar
      final gradient = LinearGradient(
        colors: [
          band.color.withOpacity(0.8),
          band.color.withOpacity(0.4),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
      
      final rect = Rect.fromLTWH(x, y, barWidth, barHeight);
      paint.shader = gradient.createShader(rect);
      
      // Draw bar
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        paint,
      );
      
      // Draw frequency label
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${band.frequency}Hz',
          style: TextStyle(
            color: band.color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + (barWidth - textPainter.width) / 2, size.height + 5),
      );
    }
    
    // Draw center line
    final centerLinePaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1;
    
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      centerLinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}