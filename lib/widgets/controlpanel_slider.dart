import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/set_time_provider.dart';

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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Time: ${provider.selectedTime.toLocal().toIso8601String().substring(0, 16)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Slider(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Start: ${provider.startingPoint.toLocal().toIso8601String().substring(0, 16)}',
                ),
                Text(
                  'End: ${provider.endingPoint.toLocal().toIso8601String().substring(0, 16)}',
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
