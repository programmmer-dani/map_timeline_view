import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:provider/provider.dart';
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/providers/researchgroup_provider.dart';
import 'package:map_timeline_view/providers/time_provider.dart';
import 'package:map_timeline_view/widgets/event_row.dart';

class TimelineView extends StatelessWidget {
  final void Function(Event)? onEventTap;

  const TimelineView({super.key, this.onEventTap});

  static const List<Color> selectedColors = [
    Colors.blueAccent,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.redAccent,
  ];

  static const double laneHeight = 40;
  static const double minGroupHeightMobile = 120;
  static const int maxVisibleGroupsMobile = 5;

  bool get isMobile =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;

  @override
  Widget build(BuildContext context) {
    final groups = context.watch<ResearchGroupsProvider>().groups;
    final timeProvider = context.watch<TimelineRangeProvider>();
    final visibleStart = timeProvider.startingPoint;
    final visibleEnd = timeProvider.endingPoint;

    final selectedGroups = groups.where((g) => g.isSelected).toList();

    if (selectedGroups.isEmpty) {
      return const Center(child: Text('No groups selected.'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight;
        final groupCount = selectedGroups.length;

        if (!isMobile || groupCount <= maxVisibleGroupsMobile) {
          final heightPerGroup = totalHeight / groupCount;
          final maxLanes = heightPerGroup ~/ laneHeight;

          return Column(
            children:
                selectedGroups.asMap().entries.map((entry) {
                  final index = entry.key;
                  final group = entry.value;
                  final baseColor =
                      selectedColors[index % selectedColors.length];
                  final textColor = Colors.white;
                  final eventRowColor = baseColor.withOpacity(0.15);

                  return SizedBox(
                    height: heightPerGroup,
                    child: _buildGroupRow(
                      group: group,
                      baseColor: baseColor,
                      textColor: textColor,
                      eventRowColor: eventRowColor,
                      visibleStart: visibleStart,
                      visibleEnd: visibleEnd,
                      maxLanes: maxLanes,
                      context: context,
                    ),
                  );
                }).toList(),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: selectedGroups.length,
          itemBuilder: (context, index) {
            final group = selectedGroups[index];
            final baseColor = selectedColors[index % selectedColors.length];
            final textColor = Colors.white;
            final eventRowColor = baseColor.withOpacity(0.15);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: SizedBox(
                height: minGroupHeightMobile,
                child: _buildGroupRow(
                  group: group,
                  baseColor: baseColor,
                  textColor: textColor,
                  eventRowColor: eventRowColor,
                  visibleStart: visibleStart,
                  visibleEnd: visibleEnd,
                  maxLanes: 2,
                  context: context,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGroupRow({
    required group,
    required Color baseColor,
    required Color textColor,
    required Color eventRowColor,
    required DateTime visibleStart,
    required DateTime visibleEnd,
    required int maxLanes,
    required BuildContext context,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            context.read<ResearchGroupsProvider>().deselectGroup(group.id);
          },
          child: Container(
            width: 150,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              group.name,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: eventRowColor,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: SizedBox.expand(
              child: EventRow(
                group: group,
                visibleStart: visibleStart,
                visibleEnd: visibleEnd,
                onEventTap: onEventTap,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
