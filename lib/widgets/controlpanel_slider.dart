import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:map_timeline_view/providers/time_provider.dart';
import 'package:provider/provider.dart';

class TimeSlider extends StatelessWidget {
  const TimeSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineRangeProvider>(
      builder: (context, provider, child) {
        final double start =
            provider.startingPoint.millisecondsSinceEpoch.toDouble();
        final double end =
            provider.endingPoint.millisecondsSinceEpoch.toDouble();
        final double selected =
            provider.selectedTime.millisecondsSinceEpoch.toDouble();

        return LayoutBuilder(
          builder: (context, constraints) {
            final double sliderWidth = constraints.maxWidth;
            final double thumbRelativeX = ((selected - start) / (end - start))
                .clamp(0.0, 1.0);
            final double estimatedLabelWidth = 90; // Slightly smaller label
            final double margin = 4;

            double desiredLeft =
                (thumbRelativeX * sliderWidth) - estimatedLabelWidth / 2;
            double clampedLeft = math.max(
              margin,
              math.min(sliderWidth - estimatedLabelWidth - margin, desiredLeft),
            );

            return SizedBox(
              height: 50, // Reduced height
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Slider
                  Positioned.fill(
                    top: 0,
                    bottom: 18,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 4,
                        ),
                        overlayShape: SliderComponentShape.noOverlay,
                        activeTrackColor:
                            Colors.grey.shade400, // Unified track color
                        inactiveTrackColor: Colors.grey.shade400,
                        thumbColor: Colors.white,
                      ),
                      child: Slider(
                        min: start,
                        max: end,
                        value: selected.clamp(start, end),
                        onChanged: (value) {
                          final newTime = DateTime.fromMillisecondsSinceEpoch(
                            value.toInt(),
                          );
                          provider.setSelectedTime(newTime);
                        },
                      ),
                    ),
                  ),

                  // Label under thumb
                  Positioned(
                    left: clampedLeft,
                    bottom: 0,
                    child: Container(
                      width: estimatedLabelWidth,
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatDate(provider.selectedTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                          ),
                          Text(
                            _formatTime(provider.selectedTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime time) {
    return "${time.year.toString().padLeft(4, '0')}-"
        "${time.month.toString().padLeft(2, '0')}-"
        "${time.day.toString().padLeft(2, '0')}";
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:"
        "${time.minute.toString().padLeft(2, '0')}";
  }
}
