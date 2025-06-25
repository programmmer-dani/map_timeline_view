import 'package:flutter/foundation.dart';
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/entities/research_group.dart';
import 'package:map_timeline_view/entities/user.dart';

class ResearchGroupsProvider extends ChangeNotifier {
  final List<ResearchGroup> _groups = [];

  List<ResearchGroup> get groups => List.unmodifiable(_groups);

  void addGroup(ResearchGroup group) {
    _groups.add(group);
    notifyListeners();
  }

  void removeGroup(String groupId) {
    _groups.removeWhere((group) => group.id == groupId);
    notifyListeners();
  }

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

  void removeMember(String groupId, String memberId) {
    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index == -1) return;
    final group = _groups[index];
    final updatedMembers =
        group.members.where((m) => m.id != memberId).toList();
    _groups[index] = group.copyWith(members: updatedMembers);
    notifyListeners();
  }

  void addEventToGroup(String groupId, Event event) {
    print('Adding event "${event.title}" to group ID: $groupId');
    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index == -1) {
      print('ERROR: Group with ID $groupId not found!');
      return;
    }
    final group = _groups[index];
    print('Found group: ${group.name}');
    final updatedEvents = List<Event>.from(group.events)..add(event);
    _groups[index] = group.copyWith(events: updatedEvents);
    print('Group ${group.name} now has ${_groups[index].events.length} events');
    notifyListeners();
  }

  void removeEventFromGroup(String groupId, String eventId) {
    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index == -1) return;
    final group = _groups[index];
    final updatedEvents = group.events.where((e) => e.id != eventId).toList();
    _groups[index] = group.copyWith(events: updatedEvents);
    notifyListeners();
  }

  void toggleGroupSelection(String groupId) {
    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index == -1) return;

    final group = _groups[index];
    _groups[index] = group.copyWith(isSelected: !group.isSelected);
    notifyListeners();
  }

  void selectGroup(String groupId) {
    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index == -1) return;

    final group = _groups[index];
    if (!group.isSelected) {
      _groups[index] = group.copyWith(isSelected: true);
      notifyListeners();
    }
  }

  void deselectGroup(String groupId) {
    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index == -1) return;

    final group = _groups[index];
    if (group.isSelected) {
      _groups[index] = group.copyWith(isSelected: false);
      notifyListeners();
    }
  }

  void loadMockData() {
    final user1 = User(id: 'u1', name: 'Alice');
    final user2 = User(id: 'u2', name: 'Bob');
    final user3 = User(id: 'u3', name: 'Carla');
    final user4 = User(id: 'u4', name: 'David');
    final user5 = User(id: 'u5', name: 'Eva');

    _groups.addAll([
      ResearchGroup(id: 'rg1', name: 'Hydrology Team', members: [user1, user2]),
      ResearchGroup(id: 'rg2', name: 'Seismic Analysis', members: [user3]),
      ResearchGroup(id: 'rg3', name: 'Wildfire Watch', members: [user4]),
      ResearchGroup(id: 'rg4', name: 'Meteorology Unit', members: [user5]),
      ResearchGroup(
        id: 'rg5',
        name: 'Environmental Sensors',
        members: [user1, user5],
      ),
      ResearchGroup(
        id: 'rg6',
        name: 'Geology Experts',
        members: [user2, user3],
      ),
    ]);

    notifyListeners();
  }
}
