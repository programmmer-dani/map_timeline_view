import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/providers/researchgroup_provider.dart';
import 'package:map_timeline_view/providers/selected_event_provider.dart';
import 'package:map_timeline_view/providers/marker_provider.dart';
import 'package:map_timeline_view/providers/time_provider.dart';
import 'package:map_timeline_view/providers/map_bounds_provider.dart';
import 'package:map_timeline_view/services/visible_events_service.dart';
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
    final context = navigatorKey.currentContext!;
    final visibleEventsService = VisibleEventsService.instance;
    final mapBoundsProvider = Provider.of<MapBoundsProvider>(context, listen: false);
    
    // Get only the currently visible events (those shown on timeline and map)
    final visibleEvents = visibleEventsService.getAllVisibleEvents(
      context: context,
      mapBounds: mapBoundsProvider.currentBounds,
      includeMapBoundsFilter: mapBoundsProvider.isInitialized,
    );

    _suggestions = visibleEvents
        .where((event) => event.title.toLowerCase().contains(query.toLowerCase()))
        .take(10)
        .toList();
  }

  void selectEvent(Event event, BuildContext context) {
    _searchQuery = '';
    _suggestions.clear();
    _isSearching = false;
    _searchController.clear();
    notifyListeners();

    final selectedEventProvider = Provider.of<SelectedEventProvider>(
      context,
      listen: false,
    );
    selectedEventProvider.select(event);

    final timeProvider = Provider.of<TimelineRangeProvider>(
      context,
      listen: false,
    );

    final eventDuration = event.end.difference(event.start);
    final buffer = Duration(hours: 2);

    final newStart = event.start.subtract(buffer);
    final newEnd = event.end.add(buffer);
    final newSelectedTime = event.start.add(eventDuration ~/ 2);

    timeProvider.updateAll(
      selectedTime: newSelectedTime,
      startingPoint: newStart,
      endingPoint: newEnd,
    );

    final markerProvider = Provider.of<MapMarkerProvider>(
      context,
      listen: false,
    );

    markerProvider.mapController.move(
      LatLng(event.latitude, event.longitude),
      12.0,
    );

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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
