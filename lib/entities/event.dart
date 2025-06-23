import 'package:map_timeline_view/entities/comment.dart';
import 'package:map_timeline_view/entities/event_type.dart';
import 'package:map_timeline_view/entities/user.dart';

class Event {
  final String id;
  final String title;
  final User author;
  final DateTime start;
  final DateTime end;
  final String data;
  final double latitude;
  final double longitude;
  final EventType type;
  final List<Comment> comments;

  Event({
    required this.id,
    required this.title,
    required this.author,
    required this.start,
    required this.end,
    required this.data,
    required this.latitude,
    required this.longitude,
    required this.type,
    List<Comment>? comments,
  }) : comments = comments ?? [];

  void addComment(Comment comment) {
    comments.add(comment);
  }
}
