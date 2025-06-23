import 'user.dart';
import 'event.dart';

class ResearchGroup {
  final String id;
  final String name;
  final List<User> members;
  final List<Event> events;

  ResearchGroup({
    required this.id,
    required this.name,
    List<User>? members,
    List<Event>? events,
  })  : members = members ?? [],
        events = events ?? [];

  ResearchGroup copyWith({
    String? id,
    String? name,
    List<User>? members,
    List<Event>? events,
  }) {
    return ResearchGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? List<User>.from(this.members),
      events: events ?? List<Event>.from(this.events),
    );
  }
}
