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
          child: ListView.builder(
            itemCount: researchGroups.length,
            itemBuilder: (context, index) {
              return _buildGroupRow(researchGroups[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGroupRow(String groupName) {
    return Row(
      children: [
        // Group Label
        Container(
          width: 100,
          color: Colors.grey.shade300,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        // Timeline (stub)
        Expanded(
          child: Container(
            height: 60,
            width: double.infinity, // Adjust width to fit the parent
            color: Colors.grey.shade100,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 30,
                  margin: const EdgeInsets.all(8),
                  color: Colors.blue.shade300,
                  child: const Center(child: Text('Event')),
                ),
                // Add more dummy bars or dynamic later
              ],
            ),
          ),
        ),
      ],
    );
  }
}
