import 'entities/user.dart';
import 'entities/comment.dart';
import 'entities/event.dart';
import 'entities/research_group.dart';

final List<User> mockUsers = [
  User(id: 'u1', name: 'Wojtek'),
  User(id: 'u2', name: 'Vasilia'),
  User(id: 'u3', name: 'Charlie'),
];

final List<Comment> mockComments = [
  Comment(
    author: mockUsers[1],
    text: 'Looks good!',
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  Comment(
    author: mockUsers[2],
    text: 'Need to review',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
  ),
];

final List<Event> mockEvents = [
  Event(
    id: 'e1',
    title: 'Event One',
    author: mockUsers[0],
    start: DateTime.now().subtract(const Duration(hours: 5)),
    end: DateTime.now().add(const Duration(hours: 3)),
    data: 'Sample event data',
    comments: [mockComments[0]],
    latitude: 37.7749,
    longitude: -122.4194,
  ),
  Event(
    id: 'e2',
    title: 'Event Two',
    author: mockUsers[1],
    start: DateTime.now().subtract(const Duration(days: 1)),
    end: DateTime.now().add(const Duration(days: 1)),
    data: 'Another event info',
    comments: [mockComments[1]],
    latitude: 34.0522,
    longitude: -118.2437,
  ),
];

final List<ResearchGroup> mockResearchGroups = [
  ResearchGroup(
    id: 'rg1',
    name: 'Research Group A',
    members: [mockUsers[0], mockUsers[1]],
    events: [mockEvents[0]],
  ),
  ResearchGroup(
    id: 'rg2',
    name: 'Research Group B',
    members: [mockUsers[1], mockUsers[2]],
    events: [mockEvents[1]],
  ),
];
