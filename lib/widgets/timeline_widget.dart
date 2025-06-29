import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/providers/researchgroup_provider.dart';
import 'package:map_timeline_view/providers/map_bounds_provider.dart';
import 'package:map_timeline_view/providers/time_provider.dart';
import 'package:map_timeline_view/providers/selected_event_provider.dart';
import 'package:map_timeline_view/widgets/event_row.dart';

class TimelineWidget extends StatelessWidget {
  final void Function(Event)? onEventTap;
  final bool isMobile;

  const TimelineWidget({
    super.key,
    this.onEventTap,
    this.isMobile = false,
  });

  static const List<Color> selectedColors = [
    Color(0xFF2196F3), 
    Color(0xFF4CAF50), 
    Color(0xFFFF9800), 
    Color(0xFF9C27B0), 
    Color(0xFFF44336), 
    Color(0xFF00BCD4), 
    Color(0xFF795548), 
    Color(0xFF607D8B), 
  ];

  static const double laneHeight = 34.0;
  static const int maxVisibleGroupsMobile = 3;
  static const double minGroupHeightMobile = 80.0;

  @override
  Widget build(BuildContext context) {
    final groups = context.watch<ResearchGroupsProvider>().groups;
    context.watch<TimelineRangeProvider>();
    context.watch<SelectedEventProvider>();
    final mapBoundsProvider = context.watch<MapBoundsProvider>();

    final selectedGroups = groups.where((g) => g.isSelected == true).toList();

    if (selectedGroups.isEmpty) {
      return const Center(child: Text('No groups selected.'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight.clamp(0.0, double.infinity);
        final groupCount = selectedGroups.length;

        if (!isMobile || groupCount <= maxVisibleGroupsMobile) {
          final heightPerGroup = groupCount > 0 ? totalHeight / groupCount : 0;
          final maxLanes = heightPerGroup > 0 ? (heightPerGroup / laneHeight).floor() : 1;

          return Column(
            children: selectedGroups.asMap().entries.map((entry) {
              final index = entry.key;
              final group = entry.value;
              final baseColor = selectedColors[index % selectedColors.length];
              final textColor = Colors.white;
              final eventRowColor = baseColor.withOpacity(0.15);

              return SizedBox(
                height: heightPerGroup > 0 ? heightPerGroup.toDouble() : 60.0, 
                child: _buildGroupRow(
                  group: group,
                  baseColor: baseColor,
                  textColor: textColor,
                  eventRowColor: eventRowColor,
                  maxLanes: maxLanes > 0 ? maxLanes : 1, 
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
                onEventTap: onEventTap,
                maxLanes: maxLanes,
                groupColor: baseColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
