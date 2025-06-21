import 'user.dart';
import 'comment.dart';

class Event {
  final String id;
  final String title;
  final User author;
  final DateTime start;
  final DateTime end;
  final String? data;
  final List<Comment> comments;
  final double latitude;
  final double longitude;
  final List<String> tag;

  final bool isClustered;
  final int? clusterSize;

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
    required this.tag,
    this.isClustered = false,
    this.clusterSize,
  });

  bool get hasComments => comments.isNotEmpty;
}

