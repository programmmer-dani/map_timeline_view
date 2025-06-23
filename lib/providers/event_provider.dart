import 'package:flutter/foundation.dart';
import 'package:map_timeline_view/entities/comment.dart';
import 'package:map_timeline_view/entities/event.dart';

class EventsProvider extends ChangeNotifier {
  final List<Event> _events = [];

  List<Event> get events => List.unmodifiable(_events);

  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  void addCommentToEvent(String eventId, Comment comment) {
    final event = _events.firstWhere((e) => e.id == eventId, orElse: () => throw Exception("Event not found"));
    event.addComment(comment);
    notifyListeners();
  }

  void clearEvents() {
    _events.clear();
    notifyListeners();
  }
}
