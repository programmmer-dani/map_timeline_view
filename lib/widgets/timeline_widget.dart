import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:map_timeline_view/providers/researchgroup_provider.dart';
import 'package:map_timeline_view/providers/time_provider.dart';
import 'package:map_timeline_view/widgets/event_row.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({super.key});

  static const List<Color> selectedColors = [
    Colors.blueAccent,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.redAccent,
  ];

  static const double laneHeight = 40; // Fixed height per event lane

  @override
  Widget build(BuildContext context) {
    final groups = context.watch<ResearchGroupsProvider>().groups;
    final timeProvider = context.watch<TimelineRangeProvider>();
    final visibleStart = timeProvider.startingPoint;
    final visibleEnd = timeProvider.endingPoint;

    final selectedGroups = groups.where((g) => g.isSelected).toList();
    final unselectedGroups = groups.where((g) => !g.isSelected).toList();

    // Calculate total height available for selected groups
    // We'll assign lanes per group so they fit in Expanded vertical space

    return Column(
      children: [
        if (selectedGroups.isNotEmpty)
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalHeight = constraints.maxHeight;
                final groupCount = selectedGroups.length;

                // Calculate height per group (divide total height evenly)
                final heightPerGroup = totalHeight / groupCount;

                return Column(
                  children:
                      selectedGroups.asMap().entries.map((entry) {
                        final groupIndex = entry.key;
                        final group = entry.value;
                        final baseColor =
                            selectedColors[groupIndex % selectedColors.length];
                        final textColor = Colors.white;
                        final eventRowColor = baseColor.withOpacity(0.15);

                        // Calculate how many lanes fit in heightPerGroup
                        final maxLanes = heightPerGroup ~/ laneHeight;

                        return SizedBox(
                          height: heightPerGroup,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 8,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Group tile
                                GestureDetector(
                                  onTap: () {
                                    group.isSelected = false;
                                    context
                                        .read<ResearchGroupsProvider>()
                                        .notifyListeners();
                                  },
                                  child: Container(
                                    width: 150,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 10,
                                    ),
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
                                // Event timeline rows stacked vertically
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: eventRowColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 4,
                                    ),
                                    child: Column(
                                      children: List.generate(maxLanes, (
                                        laneIndex,
                                      ) {
                                        return SingleChildScrollView(
                                          child: EventRow(
                                            group: group,
                                            visibleStart: visibleStart,
                                            visibleEnd: visibleEnd,
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                );
              },
            ),
          ),

        if (selectedGroups.isNotEmpty && unselectedGroups.isNotEmpty)
          const Divider(height: 1),

        if (unselectedGroups.isNotEmpty)
          SizedBox(
            height: 150,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: unselectedGroups.length,
              itemBuilder: (context, index) {
                final group = unselectedGroups[index];
                final baseColor = Colors.grey.shade300;
                final textColor = Colors.black87;
                final eventRowColor = Colors.grey.shade100;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          group.isSelected = true;
                          context
                              .read<ResearchGroupsProvider>()
                              .notifyListeners();
                        },
                        child: Container(
                          width: 150,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 10,
                          ),
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
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: EventRow(
                            group: group,
                            visibleStart: visibleStart,
                            visibleEnd: visibleEnd,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
