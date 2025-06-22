import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:map_timeline_view/providers/set_time_provider.dart';
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
            final double estimatedLabelWidth =
                100; // Estimate label width in pixels
            final double margin = 4;

            // Calculate desired label position (centered under thumb)
            double desiredLeft =
                (thumbRelativeX * sliderWidth) - estimatedLabelWidth / 2;

            // Clamp so it doesn’t overflow left or right
            double clampedLeft = math.max(
              margin,
              math.min(sliderWidth - estimatedLabelWidth - margin, desiredLeft),
            );

            return SizedBox(
              height: 70,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Slider track
                  Positioned.fill(
                    top: 0,
                    bottom: 25,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 5,
                        ),
                        overlayShape: SliderComponentShape.noOverlay,
                        inactiveTrackColor: Colors.grey.shade400,
                        activeTrackColor: Colors.white,
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

                  // Label below thumb
                  Positioned(
                    left: clampedLeft,
                    bottom: 0,
                    child: Container(
                      width: estimatedLabelWidth,
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatDate(provider.selectedTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            _formatTime(provider.selectedTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
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
