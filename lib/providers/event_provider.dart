import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:map_timeline_view/entities/comment.dart';
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/entities/event_type.dart';
import 'package:map_timeline_view/entities/user.dart';
import 'package:map_timeline_view/providers/researchgroup_provider.dart';

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

  void loadMockData(ResearchGroupsProvider groupsProvider) {
    print('=== Loading mock events ===');
    print('Groups available: ${groupsProvider.groups.length}');
    for (int i = 0; i < groupsProvider.groups.length; i++) {
      print('Group $i: ${groupsProvider.groups[i].name} (ID: ${groupsProvider.groups[i].id})');
    }

    final user1 = User(id: 'u1', name: 'Alice');
    final user2 = User(id: 'u2', name: 'Luca');
    final user3 = User(id: 'u3', name: 'Bob');
    final user4 = User(id: 'u4', name: 'Carla');

    // June 2025 Events
    final event1 = Event(
      id: 'event1',
      title: 'Early June Storm',
      author: user1,
      start: DateTime(2025, 6, 3, 14, 0),
      end: DateTime(2025, 6, 3, 18, 0),
      data: 'Strong winds and heavy rain affecting northern regions.',
      latitude: 53.2194,
      longitude: 6.5665,
      type: EventType.storm,
    );

    final event2 = Event(
      id: 'event2',
      title: 'Mid-June Flood Warning',
      author: user2,
      start: DateTime(2025, 6, 8, 9, 30),
      end: DateTime(2025, 6, 8, 15, 30),
      data: 'Heavy rainfall causing flood warnings in coastal areas.',
      latitude: 51.9225,
      longitude: 4.47917,
      type: EventType.flood,
    );

    final event2b = Event(
      id: 'event2b',
      title: 'June 9th Test Event',
      author: user1,
      start: DateTime(2025, 6, 9, 8, 0),
      end: DateTime(2025, 6, 9, 22, 0),
      data: 'Test event spanning the current selected time for timeline indicator testing.',
      latitude: 52.3702,
      longitude: 4.8952,
      type: EventType.storm,
    );

    final event3 = Event(
      id: 'event3',
      title: 'June Heatwave',
      author: user3,
      start: DateTime(2025, 6, 12, 10, 0),
      end: DateTime(2025, 6, 12, 20, 0),
      data: 'Unusually high temperatures causing fire risk.',
      latitude: 52.3676,
      longitude: 4.9041,
      type: EventType.fire,
    );

    final event4 = Event(
      id: 'event4',
      title: 'Summer Solstice Storm',
      author: user1,
      start: DateTime(2025, 6, 21, 16, 0),
      end: DateTime(2025, 6, 21, 22, 0),
      data: 'Severe weather on the longest day of the year.',
      latitude: 52.0907,
      longitude: 5.1214,
      type: EventType.storm,
    );

    final event5 = Event(
      id: 'event5',
      title: 'Amsterdam storm wojchek',
      author: user1,
      start: DateTime(2025, 6, 22, 0, 0),
      end: DateTime(2025, 6, 22, 23, 59),
      data: 'A storm called wojchek appeared',
      latitude: 52.3702,
      longitude: 4.8952,
      type: EventType.storm,
    );

    final event6 = Event(
      id: 'event6',
      title: 'Late June Earthquake',
      author: user4,
      start: DateTime(2025, 6, 25, 8, 0),
      end: DateTime(2025, 6, 25, 10, 0),
      data: 'Minor seismic activity detected in southern regions.',
      latitude: 50.8503,
      longitude: 4.3517,
      type: EventType.earthquake,
    );

    final event7 = Event(
      id: 'event7',
      title: 'June Heatwave Peak',
      author: user3,
      start: DateTime(2025, 6, 28, 12, 0),
      end: DateTime(2025, 6, 28, 18, 0),
      data: 'Peak temperatures causing multiple fire alerts.',
      latitude: 51.5074,
      longitude: 3.3887,
      type: EventType.fire,
    );

    final event8 = Event(
      id: 'event8',
      title: 'June Flooding',
      author: user2,
      start: DateTime(2025, 6, 30, 6, 0),
      end: DateTime(2025, 6, 30, 14, 0),
      data: 'Heavy rainfall causing widespread flooding.',
      latitude: 52.1326,
      longitude: 5.2913,
      type: EventType.flood,
    );

    // July 2025 Events (keeping some for later testing)
    final event9 = Event(
      id: 'event9',
      title: 'Rotterdam Flood Alert',
      author: user1,
      start: DateTime(2025, 7, 23, 10, 30),
      end: DateTime(2025, 7, 23, 12, 0),
      data: 'Heavy rainfall caused flood warnings near Rotterdam.',
      latitude: 51.9225,
      longitude: 4.47917,
      type: EventType.flood,
    );

    final event10 = Event(
      id: 'event10',
      title: 'Severe Storm in The Hague',
      author: user1,
      start: DateTime(2025, 7, 24, 9, 0),
      end: DateTime(2025, 7, 24, 11, 30),
      data: 'Storm warnings issued due to strong winds.',
      latitude: 52.0705,
      longitude: 4.3007,
      type: EventType.storm,
    );

    final event11 = Event(
      id: 'event11',
      title: 'Earthquake Near Lake Como',
      author: user2,
      start: DateTime(2025, 7, 25, 14, 0),
      end: DateTime(2025, 7, 25, 16, 0),
      data: 'Minor tremors detected near Lake Como.',
      latitude: 45.9870,
      longitude: 9.2572,
      type: EventType.earthquake,
    );

    final event12 = Event(
      id: 'event12',
      title: 'Wildfire Alert in Tuscany',
      author: user2,
      start: DateTime(2025, 7, 26, 8, 30),
      end: DateTime(2025, 7, 26, 10, 0),
      data: 'High temperature and dry conditions causing wildfire risk.',
      latitude: 43.7696,
      longitude: 11.2558,
      type: EventType.fire,
    );

    // European Events around June 15-23 with overlaps
    final event13 = Event(
      id: 'event13',
      title: 'Paris Heatwave',
      author: user3,
      start: DateTime(2025, 6, 15, 8, 0),
      end: DateTime(2025, 6, 18, 20, 0),
      data: 'Extended heatwave affecting Paris and surrounding regions.',
      latitude: 48.8566,
      longitude: 2.3522,
      type: EventType.fire,
    );

    final event14 = Event(
      id: 'event14',
      title: 'London Storm System',
      author: user1,
      start: DateTime(2025, 6, 16, 12, 0),
      end: DateTime(2025, 6, 19, 6, 0),
      data: 'Major storm system moving through London and southern England.',
      latitude: 51.5074,
      longitude: -0.1278,
      type: EventType.storm,
    );

    final event15 = Event(
      id: 'event15',
      title: 'Berlin Flooding',
      author: user2,
      start: DateTime(2025, 6, 17, 6, 0),
      end: DateTime(2025, 6, 20, 18, 0),
      data: 'Heavy rainfall causing widespread flooding in Berlin.',
      latitude: 52.5200,
      longitude: 13.4050,
      type: EventType.flood,
    );

    final event16 = Event(
      id: 'event16',
      title: 'Madrid Wildfire',
      author: user3,
      start: DateTime(2025, 6, 18, 10, 0),
      end: DateTime(2025, 6, 22, 16, 0),
      data: 'Large wildfire spreading through Madrid region.',
      latitude: 40.4168,
      longitude: -3.7038,
      type: EventType.fire,
    );

    final event17 = Event(
      id: 'event17',
      title: 'Rome Earthquake Swarm',
      author: user4,
      start: DateTime(2025, 6, 19, 14, 0),
      end: DateTime(2025, 6, 23, 8, 0),
      data: 'Series of minor earthquakes affecting Rome area.',
      latitude: 41.9028,
      longitude: 12.4964,
      type: EventType.earthquake,
    );

    final event18 = Event(
      id: 'event18',
      title: 'Amsterdam Extended Storm',
      author: user1,
      start: DateTime(2025, 6, 20, 0, 0),
      end: DateTime(2025, 6, 24, 12, 0),
      data: 'Prolonged storm system affecting Amsterdam and Netherlands.',
      latitude: 52.3676,
      longitude: 4.9041,
      type: EventType.storm,
    );

    final event19 = Event(
      id: 'event19',
      title: 'Vienna Heat Alert',
      author: user3,
      start: DateTime(2025, 6, 21, 8, 0),
      end: DateTime(2025, 6, 25, 22, 0),
      data: 'Extreme heat conditions in Vienna and eastern Austria.',
      latitude: 48.2082,
      longitude: 16.3738,
      type: EventType.fire,
    );

    final event20 = Event(
      id: 'event20',
      title: 'Prague Flood Warning',
      author: user2,
      start: DateTime(2025, 6, 22, 4, 0),
      end: DateTime(2025, 6, 26, 14, 0),
      data: 'River levels rising rapidly in Prague region.',
      latitude: 50.0755,
      longitude: 14.4378,
      type: EventType.flood,
    );

    final event21 = Event(
      id: 'event21',
      title: 'Barcelona Storm',
      author: user1,
      start: DateTime(2025, 6, 23, 16, 0),
      end: DateTime(2025, 6, 27, 10, 0),
      data: 'Severe storm system moving through Barcelona area.',
      latitude: 41.3851,
      longitude: 2.1734,
      type: EventType.storm,
    );

    final event22 = Event(
      id: 'event22',
      title: 'Munich Earthquake',
      author: user4,
      start: DateTime(2025, 6, 24, 2, 0),
      end: DateTime(2025, 6, 28, 20, 0),
      data: 'Moderate earthquake affecting Munich and southern Germany.',
      latitude: 48.1351,
      longitude: 11.5820,
      type: EventType.earthquake,
    );

    final event23 = Event(
      id: 'event23',
      title: 'Brussels Heatwave',
      author: user3,
      start: DateTime(2025, 6, 25, 12, 0),
      end: DateTime(2025, 6, 29, 18, 0),
      data: 'Record-breaking heatwave in Brussels and Belgium.',
      latitude: 50.8503,
      longitude: 4.3517,
      type: EventType.fire,
    );

    final event24 = Event(
      id: 'event24',
      title: 'Warsaw Flooding',
      author: user2,
      start: DateTime(2025, 6, 26, 8, 0),
      end: DateTime(2025, 6, 30, 16, 0),
      data: 'Heavy rainfall causing severe flooding in Warsaw.',
      latitude: 52.2297,
      longitude: 21.0122,
      type: EventType.flood,
    );

    // Additional long events in middle of June for clustering testing
    final event25 = Event(
      id: 'event25',
      title: 'Central European Storm System',
      author: user1,
      start: DateTime(2025, 6, 10, 6, 0),
      end: DateTime(2025, 6, 15, 18, 0),
      data: 'Large storm system affecting central Europe for nearly a week.',
      latitude: 50.0755,
      longitude: 14.4378,
      type: EventType.storm,
    );

    final event26 = Event(
      id: 'event26',
      title: 'Extended Heatwave Central Europe',
      author: user3,
      start: DateTime(2025, 6, 11, 8, 0),
      end: DateTime(2025, 6, 17, 22, 0),
      data: 'Prolonged heatwave affecting multiple central European countries.',
      latitude: 48.2082,
      longitude: 16.3738,
      type: EventType.fire,
    );

    final event27 = Event(
      id: 'event27',
      title: 'Major Flood Event Rhine Valley',
      author: user2,
      start: DateTime(2025, 6, 12, 4, 0),
      end: DateTime(2025, 6, 19, 12, 0),
      data: 'Severe flooding along the Rhine River affecting multiple cities.',
      latitude: 50.9375,
      longitude: 6.9603,
      type: EventType.flood,
    );

    final event28 = Event(
      id: 'event28',
      title: 'Seismic Activity Alpine Region',
      author: user4,
      start: DateTime(2025, 6, 13, 10, 0),
      end: DateTime(2025, 6, 20, 16, 0),
      data: 'Increased seismic activity in the Alpine region requiring monitoring.',
      latitude: 47.3769,
      longitude: 8.5417,
      type: EventType.earthquake,
    );

    final event29 = Event(
      id: 'event29',
      title: 'Wildfire Outbreak Southern Europe',
      author: user3,
      start: DateTime(2025, 6, 14, 12, 0),
      end: DateTime(2025, 6, 21, 8, 0),
      data: 'Multiple wildfires breaking out across southern European regions.',
      latitude: 41.9028,
      longitude: 12.4964,
      type: EventType.fire,
    );

    final event30 = Event(
      id: 'event30',
      title: 'Coastal Storm Series',
      author: user1,
      start: DateTime(2025, 6, 15, 0, 0),
      end: DateTime(2025, 6, 22, 0, 0),
      data: 'Series of storms affecting coastal regions of western Europe.',
      latitude: 51.5074,
      longitude: -0.1278,
      type: EventType.storm,
    );

    final event31 = Event(
      id: 'event31',
      title: 'Urban Flooding Crisis',
      author: user2,
      start: DateTime(2025, 6, 16, 6, 0),
      end: DateTime(2025, 6, 23, 14, 0),
      data: 'Major urban flooding affecting multiple European capitals.',
      latitude: 52.5200,
      longitude: 13.4050,
      type: EventType.flood,
    );

    final event32 = Event(
      id: 'event32',
      title: 'Heat Dome Formation',
      author: user3,
      start: DateTime(2025, 6, 17, 8, 0),
      end: DateTime(2025, 6, 24, 20, 0),
      data: 'Formation of a heat dome causing extreme temperatures across Europe.',
      latitude: 48.8566,
      longitude: 2.3522,
      type: EventType.fire,
    );

    final event33 = Event(
      id: 'event33',
      title: 'Amsterdam Storm Analysis',
      author: user4,
      start: DateTime(2025, 6, 22, 0, 0),
      end: DateTime(2025, 6, 22, 23, 59),
      data: 'Detailed analysis of the storm system affecting Amsterdam region.',
      latitude: 52.3702,
      longitude: 4.8952,
      type: EventType.storm,
    );

    final event34 = Event(
      id: 'event34',
      title: 'Berlin Storm Alert',
      author: user1,
      start: DateTime(2025, 6, 22, 8, 0),
      end: DateTime(2025, 6, 22, 16, 0),
      data: 'Storm warning issued for Berlin metropolitan area.',
      latitude: 52.5200,
      longitude: 13.4050,
      type: EventType.storm,
    );

    _events.addAll([event1, event2, event2b, event3, event4, event5, event6, event7, event8, event9, event10, event11, event12, event13, event14, event15, event16, event17, event18, event19, event20, event21, event22, event23, event24, event25, event26, event27, event28, event29, event30, event31, event32, event33, event34]);
    print('Added ${_events.length} events to EventsProvider');

    // Assign events to groups
    if (groupsProvider.groups.length >= 4) {
      print('Assigning events to groups...');
      
      // Hydrology Team gets flood and storm events
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event1); // Early June Storm
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event2); // Mid-June Flood Warning
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event2b); // June 9th Test Event
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event4); // Summer Solstice Storm
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event5); // Amsterdam storm wojchek
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event8); // June Flooding
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event9); // Rotterdam Flood Alert
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event10); // Severe Storm in The Hague
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event14); // London Storm System
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event15); // Berlin Flooding
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event18); // Amsterdam Extended Storm
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event20); // Prague Flood Warning
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event21); // Barcelona Storm
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event24); // Warsaw Flooding
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event25); // Central European Storm System
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event27); // Major Flood Event Rhine Valley
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event30); // Coastal Storm Series
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event31); // Urban Flooding Crisis
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event33); // Amsterdam Storm Analysis
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event34); // Berlin Storm Alert
      
      // Seismic Analysis gets earthquake events
      groupsProvider.addEventToGroup(groupsProvider.groups[1].id, event6); // Late June Earthquake
      groupsProvider.addEventToGroup(groupsProvider.groups[1].id, event11); // Earthquake Near Lake Como
      groupsProvider.addEventToGroup(groupsProvider.groups[1].id, event17); // Rome Earthquake Swarm
      groupsProvider.addEventToGroup(groupsProvider.groups[1].id, event22); // Munich Earthquake
      groupsProvider.addEventToGroup(groupsProvider.groups[1].id, event28); // Seismic Activity Alpine Region
      
      // Wildfire Watch gets fire events
      groupsProvider.addEventToGroup(groupsProvider.groups[2].id, event3); // June Heatwave
      groupsProvider.addEventToGroup(groupsProvider.groups[2].id, event7); // June Heatwave Peak
      groupsProvider.addEventToGroup(groupsProvider.groups[2].id, event12); // Wildfire Alert in Tuscany
      groupsProvider.addEventToGroup(groupsProvider.groups[2].id, event13); // Paris Heatwave
      groupsProvider.addEventToGroup(groupsProvider.groups[2].id, event16); // Madrid Wildfire
      groupsProvider.addEventToGroup(groupsProvider.groups[2].id, event19); // Vienna Heat Alert
      groupsProvider.addEventToGroup(groupsProvider.groups[2].id, event23); // Brussels Heatwave
      groupsProvider.addEventToGroup(groupsProvider.groups[2].id, event26); // Extended Heatwave Central Europe
      groupsProvider.addEventToGroup(groupsProvider.groups[2].id, event29); // Wildfire Outbreak Southern Europe
      groupsProvider.addEventToGroup(groupsProvider.groups[2].id, event32); // Heat Dome Formation
      
      print('Added events to groups');
      
      // Print final group states
      for (int i = 0; i < groupsProvider.groups.length; i++) {
        print('Group ${groupsProvider.groups[i].name} now has ${groupsProvider.groups[i].events.length} events');
      }
    } else {
      print('ERROR: Not enough groups available!');
    }

    notifyListeners();
    print('=== Finished loading mock events ===');
  }
}
