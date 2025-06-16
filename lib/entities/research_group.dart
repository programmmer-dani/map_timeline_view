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
    this.members = const [],
    this.events = const [],
  });
}
