import 'package:map_timeline_view/entities/user.dart';

class Comment {
  final User author;
  final String text;
  final DateTime timestamp;

  Comment({required this.author, required this.text, required this.timestamp});
}
