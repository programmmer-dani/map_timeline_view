import 'package:flutter/foundation.dart';
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/entities/research_group.dart';
import 'package:map_timeline_view/entities/user.dart';

class ResearchGroupsProvider extends ChangeNotifier {
  final List<ResearchGroup> _groups = [];

  List<ResearchGroup> get groups => List.unmodifiable(_groups);

  // Add new group
  void addGroup(ResearchGroup group) {
    _groups.add(group);
    notifyListeners();
  }

  // Remove group by id
  void removeGroup(String groupId) {
    _groups.removeWhere((group) => group.id == groupId);
    notifyListeners();
  }

  // Add member to a group
  void addMember(String groupId, User member) {
    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index == -1) return;
    final group = _groups[index];
    if (!group.members.any((m) => m.id == member.id)) {
      final updatedMembers = List<User>.from(group.members)..add(member);
      _groups[index] = group.copyWith(members: updatedMembers);
      notifyListeners();
    }
  }

  // Remove member from group
  void removeMember(String groupId, String memberId) {
    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index == -1) return;
    final group = _groups[index];
    final updatedMembers =
        group.members.where((m) => m.id != memberId).toList();
    _groups[index] = group.copyWith(members: updatedMembers);
    notifyListeners();
  }

  // Add event to group
  void addEventToGroup(String groupId, Event event) {
    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index == -1) return;
    final group = _groups[index];
    final updatedEvents = List<Event>.from(group.events)..add(event);
    _groups[index] = group.copyWith(events: updatedEvents);
    notifyListeners();
  }

  // Remove event from group
  void removeEventFromGroup(String groupId, String eventId) {
    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index == -1) return;
    final group = _groups[index];
    final updatedEvents = group.events.where((e) => e.id != eventId).toList();
    _groups[index] = group.copyWith(events: updatedEvents);
    notifyListeners();
  }

  // Toggle isSelected status for a group
  void toggleGroupSelection(String groupId) {
    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index == -1) return;

    final group = _groups[index];
    _groups[index] = group.copyWith(isSelected: !group.isSelected);
    notifyListeners();
  }

  // Load some initial mock data
  void loadMockData() {
    final user1 = User(id: 'u1', name: 'Alice');
    final user2 = User(id: 'u2', name: 'Bob');
    final user3 = User(id: 'u3', name: 'Carla');

    final mockEvents = <Event>[];

    _groups.addAll([
      ResearchGroup(
        id: 'rg1',
        name: 'Hydrology Team',
        members: [user1, user2],
        events: mockEvents,
      ),
      ResearchGroup(
        id: 'rg2',
        name: 'Seismic Analysis',
        members: [user3],
        events: mockEvents,
      ),
    ]);

    notifyListeners();
  }
}
