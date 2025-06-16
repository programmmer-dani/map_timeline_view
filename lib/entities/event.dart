import 'user.dart';
import 'comment.dart';

class Event {
  final String id;
  final String title;
  final User author;
  final DateTime start;
  final DateTime end;
  final String? data; // Can be anything, for now a string placeholder
  final List<Comment> comments;
  final double latitude;
  final double longitude;

  Event({
    required this.id,
    required this.title,
    required this.author,
    required this.start,
    required this.end,
    this.data,
    this.comments = const [],
    required this.latitude,
    required this.longitude,
  });
}
