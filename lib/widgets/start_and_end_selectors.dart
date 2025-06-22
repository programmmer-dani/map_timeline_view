import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:map_timeline_view/providers/set_time_provider.dart';

class TimelineStartDisplay extends StatelessWidget {
  const TimelineStartDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimelineRangeProvider>(context);
    final start = provider.startingPoint;

    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await _pickDateTime(context, start);
        if (picked != null && picked.isBefore(provider.endingPoint)) {
          provider.setRange(picked, provider.endingPoint);
        } else {
          _showInvalidSelectionDialog(
            context,
            'Start time must be before end time and not in the future.',
          );
        }
      },
      child: _TimeDisplayBox(
        label: 'Start',
        date: start,
      ),
    );
  }
}

class TimelineEndDisplay extends StatelessWidget {
  const TimelineEndDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimelineRangeProvider>(context);
    final end = provider.endingPoint;

    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await _pickDateTime(context, end);
        if (picked != null && picked.isAfter(provider.startingPoint)) {
          provider.setRange(provider.startingPoint, picked);
        } else {
          _showInvalidSelectionDialog(
            context,
            'End time must be after start time and not in the future.',
          );
        }
      },
      child: _TimeDisplayBox(
        label: 'End',
        date: end,
      ),
    );
  }
}

class _TimeDisplayBox extends StatelessWidget {
  final String label;
  final DateTime date;

  const _TimeDisplayBox({
    required this.label,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final String dateStr = "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
    final String timeStr = "${date.hour.toString().padLeft(2, '0')}:"
        "${date.minute.toString().padLeft(2, '0')}";

    return Container(
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(dateStr, style: const TextStyle(fontSize: 12)),
          Text(timeStr, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

Future<DateTime?> _pickDateTime(BuildContext context, DateTime initial) async {
  final DateTime now = DateTime.now();

  final DateTime? date = await showDatePicker(
    context: context,
    initialDate: initial.isAfter(now) ? now : initial,
    firstDate: DateTime(2000),
    lastDate: now,
  );

  if (date == null) return null;

  final TimeOfDay? time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initial),
  );

  if (time == null) return DateTime(date.year, date.month, date.day);

  final picked = DateTime(date.year, date.month, date.day, time.hour, time.minute);
  return picked.isAfter(now) ? null : picked;
}

void _showInvalidSelectionDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Invalid Selection'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
