import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:map_timeline_view/providers/selected_event_provider.dart';
import 'package:map_timeline_view/widgets/event_viewer.dart';

class EventPreviewPanel extends StatelessWidget {
  const EventPreviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final event = context.watch<SelectedEventProvider>().event;

    if (event == null) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'No event selected.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text('Author: ${event.author.name}'),
          Text('Start: ${_formatDateTime(event.start)}'),
          Text('End: ${_formatDateTime(event.end)}'),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
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
