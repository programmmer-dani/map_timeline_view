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
        // Time Labels
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text("Start: ${visibleStart.toIso8601String().substring(0, 16)}"),
              const Spacer(),
              Text("End: ${visibleEnd.toIso8601String().substring(0, 16)}"),
            ],
          ),
        ),

        // Timeline Area
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
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          // Group Label
          Container(
            width: 100,
            color: Colors.grey.shade300,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(groupName, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),

          // Scrollable timeline (stub)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: 60,
                width: 1000, // Temporary fixed width
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
          ),
        ],
      ),
    );
  }
}
