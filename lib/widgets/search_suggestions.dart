import 'package:flutter/material.dart';
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/entities/event_type.dart';
import 'package:map_timeline_view/providers/search_provider.dart';
import 'package:map_timeline_view/providers/time_provider.dart';
import 'package:map_timeline_view/widgets/timeline_indicator.dart';
import 'package:provider/provider.dart';

class SearchSuggestions extends StatelessWidget {
  final List<Event> suggestions;
  final Function(Event) onEventSelected;

  const SearchSuggestions({
    super.key,
    required this.suggestions,
    required this.onEventSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 300,
        minHeight: 50,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final event = suggestions[index];
          return ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            leading: SizedBox(
              width: 24,
              height: 24,
              child: TimelineIndicator(
                event: event,
                selectedTime: DateTime.now(), 
                groupColor: _getEventColor(event.type),
              ),
            ),
            title: Text(
              event.title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${_formatDate(event.start)} - ${event.author.name}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => onEventSelected(event),
          );
        },
      ),
    );
  }

  Color _getEventColor(EventType type) {
    switch (type) {
      case EventType.flood:
        return Colors.blue;
      case EventType.storm:
        return Colors.orange;
      case EventType.earthquake:
        return Colors.redAccent;
      case EventType.fire:
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
} 