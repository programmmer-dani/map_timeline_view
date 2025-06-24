import 'package:flutter/material.dart';
import 'package:map_timeline_view/widgets/timeline_widget.dart';
import 'package:map_timeline_view/widgets/map_view.dart';
import 'package:map_timeline_view/widgets/control_panel.dart';
import 'package:map_timeline_view/widgets/event_viewer.dart';
import 'package:map_timeline_view/providers/selected_event_provider.dart';
import 'package:provider/provider.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top section with timeline and map
          Expanded(
            flex: 2,
            child: Row(
              children: [
                // Timeline section
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    child: const TimelineWidget(),
                  ),
                ),
                // Map section
                Expanded(
                  flex: 1,
                  child: const MapView(),
                ),
              ],
            ),
          ),
          // Bottom section with control panel and event viewer
          Expanded(
            flex: 1,
            child: Row(
              children: [
                // Control panel
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    child: const ControlPanel(),
                  ),
                ),
                // Event viewer
                Expanded(
                  flex: 1,
                  child: Consumer<SelectedEventProvider>(
                    builder: (context, selectedEventProvider, child) {
                      return selectedEventProvider.event != null
                          ? FullScreenEventDetails(event: selectedEventProvider.event!)
                          : const Center(
                              child: Text('No event selected'),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
