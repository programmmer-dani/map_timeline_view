import 'package:flutter/material.dart';
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/entities/research_group.dart';

class EventRow extends StatelessWidget {
  final ResearchGroup group;
  final DateTime visibleStart;
  final DateTime visibleEnd;

  const EventRow({
    super.key,
    required this.group,
    required this.visibleStart,
    required this.visibleEnd,
  });

  @override
  Widget build(BuildContext context) {
    final lanes = _assignEventsToLanes(group.events);

    const laneHeight = 34.0;
    final totalHeight = laneHeight * lanes.length;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge, // This hides overflow
        children: [
          for (int laneIndex = 0; laneIndex < lanes.length; laneIndex++)
            ...lanes[laneIndex].map((event) {
              final left = _calculateOffset(
                event.start,
                visibleStart,
                visibleEnd,
              );
              final width = _calculateWidth(event, visibleStart, visibleEnd);

              return Positioned(
                top: laneIndex * laneHeight,
                left: left,
                child: Container(
                  width: width,
                  height: laneHeight - 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      event.type.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  double _calculateOffset(
    DateTime eventStart,
    DateTime visibleStart,
    DateTime visibleEnd,
  ) {
    final totalMs =
        visibleEnd.millisecondsSinceEpoch - visibleStart.millisecondsSinceEpoch;
    final offsetMs =
        eventStart.millisecondsSinceEpoch - visibleStart.millisecondsSinceEpoch;
    return (offsetMs / totalMs) * 300; // Adjust width as needed
  }

  double _calculateWidth(
    Event event,
    DateTime visibleStart,
    DateTime visibleEnd,
  ) {
    final totalMs =
        visibleEnd.millisecondsSinceEpoch - visibleStart.millisecondsSinceEpoch;
    final durationMs =
        event.end.millisecondsSinceEpoch - event.start.millisecondsSinceEpoch;
    return (durationMs / totalMs) * 300;
  }

  List<List<Event>> _assignEventsToLanes(List<Event> events) {
    final sorted = List<Event>.from(events)
      ..sort((a, b) => a.start.compareTo(b.start));
    final lanes = <List<Event>>[];

    for (final event in sorted) {
      bool placed = false;

      for (final lane in lanes) {
        if (lane.isEmpty || !event.start.isBefore(lane.last.end)) {
          lane.add(event);
          placed = true;
          break;
        }
      }

      if (!placed) {
        lanes.add([event]);
      }
    }

    return lanes;
  }
}
