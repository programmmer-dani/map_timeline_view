import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/providers/researchgroup_provider.dart';
import 'package:map_timeline_view/providers/selected_event_provider.dart';
import 'package:map_timeline_view/providers/marker_provider.dart';
import 'package:map_timeline_view/providers/time_provider.dart';
import 'package:provider/provider.dart';

class SearchProvider extends ChangeNotifier {
  String _searchQuery = '';
  List<Event> _suggestions = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  String get searchQuery => _searchQuery;
  List<Event> get suggestions => _suggestions;
  bool get isSearching => _isSearching;
  TextEditingController get searchController => _searchController;

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _isSearching = query.isNotEmpty;
    
    if (query.isEmpty) {
      _suggestions.clear();
    } else {
      _generateSuggestions(query);
    }
    
    notifyListeners();
  }

  void _generateSuggestions(String query) {
    final researchGroupsProvider = Provider.of<ResearchGroupsProvider>(
      navigatorKey.currentContext!,
      listen: false,
    );

    final allEvents = <Event>[];
    for (final group in researchGroupsProvider.groups) {
      allEvents.addAll(group.events);
    }

    // Filter events by title (case-insensitive)
    _suggestions = allEvents
        .where((event) => event.title.toLowerCase().contains(query.toLowerCase()))
        .take(10) // Limit to 10 suggestions
        .toList();
  }

  void selectEvent(Event event, BuildContext context) {
    // Clear search
    _searchQuery = '';
    _suggestions.clear();
    _isSearching = false;
    _searchController.clear();
    notifyListeners();

    // Select the event
    final selectedEventProvider = Provider.of<SelectedEventProvider>(
      context,
      listen: false,
    );
    selectedEventProvider.select(event);

    // Update time range to include the selected event
    final timeProvider = Provider.of<TimelineRangeProvider>(
      context,
      listen: false,
    );
    
    // Calculate a time range that includes the event with some buffer
    final eventDuration = event.end.difference(event.start);
    final buffer = Duration(hours: 2); // 2 hours buffer before and after
    
    final newStart = event.start.subtract(buffer);
    final newEnd = event.end.add(buffer);
    final newSelectedTime = event.start.add(eventDuration ~/ 2); // Middle of event
    
    // Update the time provider
    timeProvider.updateAll(
      selectedTime: newSelectedTime,
      startingPoint: newStart,
      endingPoint: newEnd,
    );

    // Navigate to event location on map
    final markerProvider = Provider.of<MapMarkerProvider>(
      context,
      listen: false,
    );
    
    // Move map to event location and zoom in
    markerProvider.mapController.move(
      LatLng(event.latitude, event.longitude),
      12.0, // Zoom level
    );

    // Recalculate markers to ensure the selected event is visible
    markerProvider.recalculateMarkers(context);
  }

  void clearSearch() {
    _searchQuery = '';
    _suggestions.clear();
    _isSearching = false;
    _searchController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Global navigator key to access context from provider
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); 