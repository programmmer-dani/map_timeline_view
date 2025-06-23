import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:map_timeline_view/entities/comment.dart';
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/entities/event_type.dart';
import 'package:map_timeline_view/entities/user.dart';

class EventsProvider extends ChangeNotifier {
  final List<Event> _events = [];

  List<Event> get events => List.unmodifiable(_events);

  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  void addCommentToEvent(String eventId, Comment comment) {
    final event = _events.firstWhere(
      (e) => e.id == eventId,
      orElse: () => throw Exception("Event not found"),
    );
    event.addComment(comment);
    notifyListeners();
  }

  void clearEvents() {
    _events.clear();
    notifyListeners();
  }

  void loadMockData() {
    final user1 = User(id: 'u1', name: 'Alice');
    final user2 = User(id: 'u2', name: 'Luca');

    _events.addAll([
      Event(
        id: 'event1',
        title: 'Rotterdam Flood Alert',
        author: user1,
        start: DateTime(2025, 7, 23, 10, 30),
        end: DateTime(2025, 7, 23, 12, 0),
        data: 'Heavy rainfall caused flood warnings near Rotterdam.',
        latitude: 51.9225,
        longitude: 4.47917,
        type: EventType.flood,
      ),
      Event(
        id: 'event2',
        title: 'Severe Storm in The Hague',
        author: user1,
        start: DateTime(2025, 7, 24, 9, 0),
        end: DateTime(2025, 7, 24, 11, 30),
        data: 'Storm warnings issued due to strong winds.',
        latitude: 52.0705,
        longitude: 4.3007,
        type: EventType.storm,
      ),
      Event(
        id: 'event3',
        title: 'Earthquake Near Lake Como',
        author: user2,
        start: DateTime(2025, 7, 25, 14, 0),
        end: DateTime(2025, 7, 25, 16, 0),
        data: 'Minor tremors detected near Lake Como.',
        latitude: 45.9870,
        longitude: 9.2572,
        type: EventType.earthquake,
      ),
      Event(
        id: 'event4',
        title: 'Wildfire Alert in Tuscany',
        author: user2,
        start: DateTime(2025, 7, 26, 8, 30),
        end: DateTime(2025, 7, 26, 10, 0),
        data: 'High temperature and dry conditions causing wildfire risk.',
        latitude: 43.7696,
        longitude: 11.2558,
        type: EventType.fire,
      ),
    ]);

    notifyListeners();
  }
}
