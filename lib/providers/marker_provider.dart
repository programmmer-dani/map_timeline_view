import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_timeline_view/entities/event_type.dart';
import 'package:map_timeline_view/providers/researchgroup_provider.dart';
import 'package:map_timeline_view/providers/selected_event_provider.dart';
import 'package:map_timeline_view/providers/time_provider.dart';
import 'package:map_timeline_view/widgets/event_pop_up.dart';
import 'package:provider/provider.dart';

class MapMarkerProvider extends ChangeNotifier {
  final MapController mapController;
  List<Marker> _markers = [];

  MapMarkerProvider({required this.mapController});

  List<Marker> get markers => _markers;

  void recalculateMarkers(BuildContext context) {
    print('=== Recalculating Markers ===');
    try {
      final bounds = mapController.bounds;
      if (bounds == null) {
        print('Map bounds are null, skipping marker calculation');
        return;
      }
      print('Map bounds: ${bounds.southWest} to ${bounds.northEast}');

      final timeProvider = Provider.of<TimelineRangeProvider>(
        context,
        listen: false,
      );
      final selectedTime = timeProvider.selectedTime;
      print('Selected time: $selectedTime');

      final researchGroupsProvider = Provider.of<ResearchGroupsProvider>(
        context,
        listen: false,
      );
      final selectedGroups = researchGroupsProvider.groups.where(
        (g) => g.isSelected,
      );
      print('Selected groups: ${selectedGroups.length}');

      final newMarkers = <Marker>[];

      for (final group in selectedGroups) {
        print('Processing group: ${group.name} with ${group.events.length} events');
        for (final event in group.events) {
          // Normalize the selected time to remove seconds and milliseconds for comparison
          final normalizedSelectedTime = DateTime(
            selectedTime.year,
            selectedTime.month,
            selectedTime.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          
          final isInTime =
              !normalizedSelectedTime.isBefore(event.start) &&
              !normalizedSelectedTime.isAfter(event.end);
          final isInBounds = bounds.contains(
            LatLng(event.latitude, event.longitude),
          );

          print('Event: ${event.title} - Start: ${event.start}, End: ${event.end}');
          print('Normalized selected time: $normalizedSelectedTime');
          print('Event: ${event.title} - In time: $isInTime, In bounds: $isInBounds');

          if (isInTime && isInBounds) {
            newMarkers.add(
              Marker(
                width: 40,
                height: 40,
                point: LatLng(event.latitude, event.longitude),
                child: GestureDetector(
                  onTap: () {
                    final selectedEventProvider =
                        Provider.of<SelectedEventProvider>(
                          context,
                          listen: false,
                        );
                    selectedEventProvider.select(event);

                    if (_isMobile()) {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (_) => const EventPopUpWidget(),
                      );
                    }
                  },
                  child: _getEventIcon(event.type),
                ),
              ),
            );
            print('Added marker for event: ${event.title}');
          }
        }
      }

      _markers = newMarkers;
      print('Total markers created: ${_markers.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('MapController not ready yet: $e');
    }
  }

  Widget _getEventIcon(EventType type) {
    switch (type) {
      case EventType.flood:
        return const Icon(Icons.water, color: Colors.blue, size: 28);
      case EventType.storm:
        return const Icon(Icons.bolt, color: Colors.orange, size: 28);
      case EventType.earthquake:
        return const Icon(Icons.waves, color: Colors.redAccent, size: 28);
      case EventType.fire:
        return const Icon(
          Icons.local_fire_department,
          color: Colors.deepOrange,
          size: 28,
        );
      default:
        return const Icon(Icons.location_on, color: Colors.black, size: 28);
    }
  }

  bool _isMobile() {
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }
}
