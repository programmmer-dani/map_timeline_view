import 'package:flutter/material.dart';

class TimelineView extends StatelessWidget {
  final List<String> researchGroups;
  final DateTime visibleStart;
  final DateTime visibleEnd;

  const TimelineView({
    Key? key,
    required this.researchGroups,
    required this.visibleStart,
    required this.visibleEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Timeline Area
        SizedBox(height: 80),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate the total number of rows based on the available height
              const double rowHeight = 60; // Fixed height for each row
              final int totalRows = (constraints.maxHeight / rowHeight).floor();

              // Divide rows equally among research groups
              final int rowsPerGroup = (totalRows / researchGroups.length).floor();

              return ListView.builder(
                itemCount: researchGroups.length,
                itemBuilder: (context, index) {
                  return _buildGroupRow(researchGroups[index], index, rowsPerGroup);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGroupRow(String groupName, int index, int rowsPerGroup) {
    // Define a list of colors for research groups
    final List<Color> groupColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
      Colors.teal,
      Colors.pink,
    ];

    // Assign a color based on the index of the group
    final Color groupColor = groupColors[index % groupColors.length];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group Label
        Container(
          width: 100,
          color: groupColor, // Use the assigned color
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            groupName,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        // Timeline with multiple rows
        Expanded(
          child: Column(
            children: List.generate(
              rowsPerGroup, // Dynamically calculated rows per research group
              (rowIndex) => Container(
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: groupColor.withOpacity(0.3), // Slightly transparent color for timeline
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    // Add events here for each row
                    Container(
                      width: 100,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: groupColor.withOpacity(0.6),
                      child: Center(
                        child: Text(
                          'Event $rowIndex',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
