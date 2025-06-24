import 'package:flutter/material.dart';
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/widgets/event_viewer.dart';

class EventPopUpWidget extends StatelessWidget {
  final Event event;

  const EventPopUpWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Author: ${event.author.name}'),
          Text('Start: ${_formatDateTime(event.start)}'),
          Text('End: ${_formatDateTime(event.end)}'),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FullScreenEventDetails(event: event),
                  ),
                );
              },
              child: const Text('View Full Details'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}