import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/entities/event_type.dart';
import 'package:map_timeline_view/entities/research_group.dart';
import 'package:map_timeline_view/entities/user.dart';
import 'package:map_timeline_view/providers/event_provider.dart';
import 'package:map_timeline_view/providers/researchgroup_provider.dart';
import 'package:map_timeline_view/providers/time_provider.dart';

/// Centralized service for managing mock data initialization
/// Follows OOP principles by centralizing the responsibility for mock data creation
class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  /// Initialize all mock data for the application
  /// This method coordinates the initialization of all providers with mock data
  void initializeAllMockData({
    required ResearchGroupsProvider researchGroupsProvider,
    required EventsProvider eventsProvider,
    required TimelineRangeProvider timeProvider,
  }) {
    // Step 1: Create users (shared across providers)
    final users = _createMockUsers();
    
    // Step 2: Initialize research groups
    _initializeResearchGroups(researchGroupsProvider, users);
    
    // Step 3: Initialize events
    _initializeEvents(eventsProvider, researchGroupsProvider, users);
    
    // Step 4: Initialize timeline
    _initializeTimeline(timeProvider);
  }

  /// Create mock users that will be shared across the application
  List<User> _createMockUsers() {
    return [
      User(id: 'u1', name: 'Alice'),
      User(id: 'u2', name: 'Bob'),
      User(id: 'u3', name: 'Carla'),
      User(id: 'u4', name: 'David'),
      User(id: 'u5', name: 'Eva'),
      User(id: 'u6', name: 'Luca'),
    ];
  }

  /// Create mock research groups
  List<ResearchGroup> _createMockResearchGroups(List<User> users) {
    return [
      ResearchGroup(
        id: 'rg1',
        name: 'Hydrology Team',
        members: [users[0], users[1]], // Alice, Bob
      ),
      ResearchGroup(
        id: 'rg2',
        name: 'Seismic Analysis',
        members: [users[2]], // Carla
      ),
      ResearchGroup(
        id: 'rg3',
        name: 'Wildfire Watch',
        members: [users[3]], // David
      ),
      ResearchGroup(
        id: 'rg4',
        name: 'Meteorology Unit',
        members: [users[4]], // Eva
      ),
    ];
  }

  /// Initialize research groups with mock data
  void _initializeResearchGroups(ResearchGroupsProvider groupsProvider, List<User> users) {
    final groups = _createMockResearchGroups(users);
    
    for (final group in groups) {
      groupsProvider.addGroup(group);
    }
  }

  /// Initialize events with mock data and assign them to groups
  void _initializeEvents(
    EventsProvider eventsProvider,
    ResearchGroupsProvider groupsProvider,
    List<User> users,
  ) {
    final events = _createMockEvents(users);
    
    // Add all events to the events provider
    for (final event in events) {
      eventsProvider.addEvent(event);
    }
    
    // Assign events to appropriate research groups
    _assignEventsToGroups(events, groupsProvider);
  }

  /// Create all mock events
  List<Event> _createMockEvents(List<User> users) {
    return [
      // Hydrology Team Events (Group 0)
      Event(
        id: 'event1',
        title: 'Early June Storm',
        author: users[0],
        start: DateTime(2025, 6, 3, 14, 0),
        end: DateTime(2025, 6, 3, 18, 0),
        data: 'Strong winds and heavy rain affecting northern regions.',
        latitude: 53.2194,
        longitude: 6.5665,
        type: EventType.storm,
      ),
      Event(
        id: 'event2',
        title: 'Mid-June Flood Warning',
        author: users[5], // Luca
        start: DateTime(2025, 6, 8, 9, 30),
        end: DateTime(2025, 6, 8, 15, 30),
        data: 'Heavy rainfall causing flood warnings in coastal areas.',
        latitude: 51.9225,
        longitude: 4.47917,
        type: EventType.flood,
      ),
      Event(
        id: 'event2b',
        title: 'June 9th Test Event',
        author: users[0],
        start: DateTime(2025, 6, 9, 8, 0),
        end: DateTime(2025, 6, 9, 22, 0),
        data: 'Test event spanning the current selected time for timeline indicator testing.',
        latitude: 52.3702,
        longitude: 4.8952,
        type: EventType.storm,
      ),
      Event(
        id: 'event4',
        title: 'Summer Solstice Storm',
        author: users[0],
        start: DateTime(2025, 6, 21, 16, 0),
        end: DateTime(2025, 6, 21, 22, 0),
        data: 'Severe weather on the longest day of the year.',
        latitude: 52.0907,
        longitude: 5.1214,
        type: EventType.storm,
      ),
      Event(
        id: 'event5',
        title: 'Amsterdam storm wojchek',
        author: users[0],
        start: DateTime(2025, 6, 22, 0, 0),
        end: DateTime(2025, 6, 22, 23, 59),
        data: 'A storm called wojchek appeared',
        latitude: 52.3702,
        longitude: 4.8952,
        type: EventType.storm,
      ),
      Event(
        id: 'event8',
        title: 'June Flooding',
        author: users[5],
        start: DateTime(2025, 6, 30, 6, 0),
        end: DateTime(2025, 6, 30, 14, 0),
        data: 'Heavy rainfall causing widespread flooding.',
        latitude: 52.1326,
        longitude: 5.2913,
        type: EventType.flood,
      ),
      Event(
        id: 'event9',
        title: 'Rotterdam Flood Alert',
        author: users[0],
        start: DateTime(2025, 7, 23, 10, 30),
        end: DateTime(2025, 7, 23, 12, 0),
        data: 'Heavy rainfall caused flood warnings near Rotterdam.',
        latitude: 51.9225,
        longitude: 4.47917,
        type: EventType.flood,
      ),
      Event(
        id: 'event10',
        title: 'Severe Storm in The Hague',
        author: users[0],
        start: DateTime(2025, 7, 24, 9, 0),
        end: DateTime(2025, 7, 24, 11, 30),
        data: 'Storm warnings issued due to strong winds.',
        latitude: 52.0705,
        longitude: 4.3007,
        type: EventType.storm,
      ),
      Event(
        id: 'event14',
        title: 'London Storm System',
        author: users[0],
        start: DateTime(2025, 6, 16, 12, 0),
        end: DateTime(2025, 6, 19, 6, 0),
        data: 'Major storm system moving through London and southern England.',
        latitude: 51.5074,
        longitude: -0.1278,
        type: EventType.storm,
      ),
      Event(
        id: 'event15',
        title: 'Berlin Flooding',
        author: users[5],
        start: DateTime(2025, 6, 17, 6, 0),
        end: DateTime(2025, 6, 20, 18, 0),
        data: 'Heavy rainfall causing widespread flooding in Berlin.',
        latitude: 52.5200,
        longitude: 13.4050,
        type: EventType.flood,
      ),
      Event(
        id: 'event18',
        title: 'Amsterdam Extended Storm',
        author: users[0],
        start: DateTime(2025, 6, 20, 0, 0),
        end: DateTime(2025, 6, 24, 12, 0),
        data: 'Prolonged storm system affecting Amsterdam and Netherlands.',
        latitude: 52.3676,
        longitude: 4.9041,
        type: EventType.storm,
      ),
      Event(
        id: 'event20',
        title: 'Prague Flood Warning',
        author: users[5],
        start: DateTime(2025, 6, 22, 4, 0),
        end: DateTime(2025, 6, 26, 14, 0),
        data: 'River levels rising rapidly in Prague region.',
        latitude: 50.0755,
        longitude: 14.4378,
        type: EventType.flood,
      ),
      Event(
        id: 'event21',
        title: 'Barcelona Storm',
        author: users[0],
        start: DateTime(2025, 6, 23, 16, 0),
        end: DateTime(2025, 6, 27, 10, 0),
        data: 'Severe storm system moving through Barcelona area.',
        latitude: 41.3851,
        longitude: 2.1734,
        type: EventType.storm,
      ),
      Event(
        id: 'event24',
        title: 'Warsaw Flooding',
        author: users[5],
        start: DateTime(2025, 6, 26, 8, 0),
        end: DateTime(2025, 6, 30, 16, 0),
        data: 'Heavy rainfall causing severe flooding in Warsaw.',
        latitude: 52.2297,
        longitude: 21.0122,
        type: EventType.flood,
      ),
      Event(
        id: 'event25',
        title: 'Central European Storm System',
        author: users[0],
        start: DateTime(2025, 6, 10, 6, 0),
        end: DateTime(2025, 6, 15, 18, 0),
        data: 'Large storm system affecting central Europe for nearly a week.',
        latitude: 50.0755,
        longitude: 14.4378,
        type: EventType.storm,
      ),
      Event(
        id: 'event27',
        title: 'Major Flood Event Rhine Valley',
        author: users[5],
        start: DateTime(2025, 6, 12, 4, 0),
        end: DateTime(2025, 6, 19, 12, 0),
        data: 'Severe flooding along the Rhine River affecting multiple cities.',
        latitude: 50.9375,
        longitude: 6.9603,
        type: EventType.flood,
      ),
      Event(
        id: 'event30',
        title: 'Coastal Storm Series',
        author: users[0],
        start: DateTime(2025, 6, 15, 0, 0),
        end: DateTime(2025, 6, 22, 0, 0),
        data: 'Series of storms affecting coastal regions of western Europe.',
        latitude: 51.5074,
        longitude: -0.1278,
        type: EventType.storm,
      ),
      Event(
        id: 'event31',
        title: 'Urban Flooding Crisis',
        author: users[5],
        start: DateTime(2025, 6, 16, 6, 0),
        end: DateTime(2025, 6, 23, 14, 0),
        data: 'Major urban flooding affecting multiple European capitals.',
        latitude: 52.5200,
        longitude: 13.4050,
        type: EventType.flood,
      ),
      Event(
        id: 'event33',
        title: 'Amsterdam Storm Analysis',
        author: users[3], // David
        start: DateTime(2025, 6, 22, 0, 0),
        end: DateTime(2025, 6, 22, 23, 59),
        data: 'Detailed analysis of the storm system affecting Amsterdam region.',
        latitude: 52.3702,
        longitude: 4.8952,
        type: EventType.storm,
      ),
      Event(
        id: 'event34',
        title: 'Berlin Storm Alert',
        author: users[0],
        start: DateTime(2025, 6, 22, 8, 0),
        end: DateTime(2025, 6, 22, 16, 0),
        data: 'Storm warning issued for Berlin metropolitan area.',
        latitude: 52.5200,
        longitude: 13.4050,
        type: EventType.storm,
      ),

      // Seismic Analysis Events (Group 1)
      Event(
        id: 'event6',
        title: 'Late June Earthquake',
        author: users[3], // David
        start: DateTime(2025, 6, 25, 8, 0),
        end: DateTime(2025, 6, 25, 10, 0),
        data: 'Minor seismic activity detected in southern regions.',
        latitude: 50.8503,
        longitude: 4.3517,
        type: EventType.earthquake,
      ),
      Event(
        id: 'event11',
        title: 'Earthquake Near Lake Como',
        author: users[5],
        start: DateTime(2025, 7, 25, 14, 0),
        end: DateTime(2025, 7, 25, 16, 0),
        data: 'Minor tremors detected near Lake Como.',
        latitude: 45.9870,
        longitude: 9.2572,
        type: EventType.earthquake,
      ),
      Event(
        id: 'event17',
        title: 'Rome Earthquake Swarm',
        author: users[3],
        start: DateTime(2025, 6, 19, 14, 0),
        end: DateTime(2025, 6, 23, 8, 0),
        data: 'Series of minor earthquakes affecting Rome area.',
        latitude: 41.9028,
        longitude: 12.4964,
        type: EventType.earthquake,
      ),
      Event(
        id: 'event22',
        title: 'Munich Earthquake',
        author: users[3],
        start: DateTime(2025, 6, 24, 2, 0),
        end: DateTime(2025, 6, 28, 20, 0),
        data: 'Moderate earthquake affecting Munich and southern Germany.',
        latitude: 48.1351,
        longitude: 11.5820,
        type: EventType.earthquake,
      ),
      Event(
        id: 'event28',
        title: 'Seismic Activity Alpine Region',
        author: users[3],
        start: DateTime(2025, 6, 13, 10, 0),
        end: DateTime(2025, 6, 20, 16, 0),
        data: 'Increased seismic activity in the Alpine region requiring monitoring.',
        latitude: 47.3769,
        longitude: 8.5417,
        type: EventType.earthquake,
      ),

      // Wildfire Watch Events (Group 2)
      Event(
        id: 'event3',
        title: 'June Heatwave',
        author: users[2], // Carla
        start: DateTime(2025, 6, 12, 10, 0),
        end: DateTime(2025, 6, 12, 20, 0),
        data: 'Unusually high temperatures causing fire risk.',
        latitude: 52.3676,
        longitude: 4.9041,
        type: EventType.fire,
      ),
      Event(
        id: 'event7',
        title: 'June Heatwave Peak',
        author: users[2],
        start: DateTime(2025, 6, 28, 12, 0),
        end: DateTime(2025, 6, 28, 18, 0),
        data: 'Peak temperatures causing multiple fire alerts.',
        latitude: 51.5074,
        longitude: 3.3887,
        type: EventType.fire,
      ),
      Event(
        id: 'event12',
        title: 'Wildfire Alert in Tuscany',
        author: users[5],
        start: DateTime(2025, 7, 26, 8, 30),
        end: DateTime(2025, 7, 26, 10, 0),
        data: 'High temperature and dry conditions causing wildfire risk.',
        latitude: 43.7696,
        longitude: 11.2558,
        type: EventType.fire,
      ),
      Event(
        id: 'event13',
        title: 'Paris Heatwave',
        author: users[2],
        start: DateTime(2025, 6, 15, 8, 0),
        end: DateTime(2025, 6, 18, 20, 0),
        data: 'Extended heatwave affecting Paris and surrounding regions.',
        latitude: 48.8566,
        longitude: 2.3522,
        type: EventType.fire,
      ),
      Event(
        id: 'event16',
        title: 'Madrid Wildfire',
        author: users[2],
        start: DateTime(2025, 6, 18, 10, 0),
        end: DateTime(2025, 6, 22, 16, 0),
        data: 'Large wildfire spreading through Madrid region.',
        latitude: 40.4168,
        longitude: -3.7038,
        type: EventType.fire,
      ),
      Event(
        id: 'event19',
        title: 'Vienna Heat Alert',
        author: users[2],
        start: DateTime(2025, 6, 21, 8, 0),
        end: DateTime(2025, 6, 25, 22, 0),
        data: 'Extreme heat conditions in Vienna and eastern Austria.',
        latitude: 48.2082,
        longitude: 16.3738,
        type: EventType.fire,
      ),
      Event(
        id: 'event23',
        title: 'Brussels Heatwave',
        author: users[2],
        start: DateTime(2025, 6, 25, 12, 0),
        end: DateTime(2025, 6, 29, 18, 0),
        data: 'Record-breaking heatwave in Brussels and Belgium.',
        latitude: 50.8503,
        longitude: 4.3517,
        type: EventType.fire,
      ),
      Event(
        id: 'event26',
        title: 'Extended Heatwave Central Europe',
        author: users[2],
        start: DateTime(2025, 6, 11, 8, 0),
        end: DateTime(2025, 6, 17, 22, 0),
        data: 'Prolonged heatwave affecting multiple central European countries.',
        latitude: 48.2082,
        longitude: 16.3738,
        type: EventType.fire,
      ),
      Event(
        id: 'event29',
        title: 'Wildfire Outbreak Southern Europe',
        author: users[2],
        start: DateTime(2025, 6, 14, 12, 0),
        end: DateTime(2025, 6, 21, 8, 0),
        data: 'Multiple wildfires breaking out across southern European regions.',
        latitude: 41.9028,
        longitude: 12.4964,
        type: EventType.fire,
      ),
      Event(
        id: 'event32',
        title: 'Heat Dome Formation',
        author: users[2],
        start: DateTime(2025, 6, 17, 8, 0),
        end: DateTime(2025, 6, 24, 20, 0),
        data: 'Formation of a heat dome causing extreme temperatures across Europe.',
        latitude: 48.8566,
        longitude: 2.3522,
        type: EventType.fire,
      ),
    ];
  }

  /// Assign events to appropriate research groups based on event type and content
  void _assignEventsToGroups(
    List<Event> events,
    ResearchGroupsProvider groupsProvider,
  ) {
    if (groupsProvider.groups.length < 4) {
      return;
    }

    // Group 0: Hydrology Team (storms and floods)
    final hydrologyEvents = events.where((event) =>
        event.type == EventType.storm || event.type == EventType.flood).toList();
    
    // Group 1: Seismic Analysis (earthquakes)
    final seismicEvents = events.where((event) =>
        event.type == EventType.earthquake).toList();
    
    // Group 2: Wildfire Watch (fires)
    final wildfireEvents = events.where((event) =>
        event.type == EventType.fire).toList();

    // Assign events to groups
    for (final event in hydrologyEvents) {
      groupsProvider.addEventToGroup(groupsProvider.groups[0].id, event);
    }
    
    for (final event in seismicEvents) {
      groupsProvider.addEventToGroup(groupsProvider.groups[1].id, event);
    }
    
    for (final event in wildfireEvents) {
      groupsProvider.addEventToGroup(groupsProvider.groups[2].id, event);
    }
  }

  /// Initialize timeline with default values
  void _initializeTimeline(TimelineRangeProvider timeProvider) {
    final defaultStart = DateTime(2025, 6, 1);
    final defaultEnd = DateTime(2025, 7, 31);
    final defaultSelected = DateTime(2025, 6, 9, 12, 0); // Middle of the test event
    
    timeProvider.updateAll(
      selectedTime: defaultSelected,
      startingPoint: defaultStart,
      endingPoint: defaultEnd,
    );
  }

  /// Get a singleton instance of the mock data service
  static MockDataService get instance => _instance;
}
