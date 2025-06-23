import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:map_timeline_view/widgets/start_and_end_selectors.dart';

import '../../widgets/map_view.dart';
import '../../widgets/timeline.dart';
import '../../widgets/split_view.dart';
import '../../widgets/control_panel.dart';

class DesktopMapLayout extends StatefulWidget {
  const DesktopMapLayout({super.key});

  @override
  State<DesktopMapLayout> createState() => _DesktopMapLayoutState();
}

class _DesktopMapLayoutState extends State<DesktopMapLayout> {
  final GlobalKey<MapViewState> mapKey = GlobalKey<MapViewState>();

  bool get isDesktop =>
      ![
        TargetPlatform.iOS,
        TargetPlatform.android,
        TargetPlatform.fuchsia,
      ].contains(defaultTargetPlatform);

  void _onTimeSliderChanged(DateTime newTime) {
    mapKey.currentState?.recalculateMarkers();
  }

  static const double controlPanelHeight = 88.0;
  static const double bottomPanelHeight = 225.0; // 1.5 times bigger than before

  @override
  Widget build(BuildContext context) {
    if (!isDesktop) {
      return const Center(child: Text('Desktop layout only'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;

        // Calculate the height for the SplitView area by subtracting control panel and bottom panels
        final mainHeight =
            availableHeight - controlPanelHeight - bottomPanelHeight;

        return Column(
          children: [
            // Control Panel on top
            SizedBox(
              height: controlPanelHeight,
              child: ControlPanel(onTimeChanged: _onTimeSliderChanged),
            ),

            SizedBox(
              height: mainHeight,
              child: SplitView(
                key: mapKey,
                initialSplitRatio: 0.85,
                minSplitRatio: 0.4,
                maxSplitRatio: 0.9,
                draggerHeight: 40,
                isMobile: false,
                topChild: TimelineView(
                  researchGroups: const ['Group A', 'Group B'],
                  visibleStart: DateTime.now().subtract(
                    const Duration(hours: 1),
                  ),
                  visibleEnd: DateTime.now().add(const Duration(hours: 1)),
                ),
                bottomChild: MapView(
                  onMapEvent: (_) => mapKey.currentState?.recalculateMarkers(),
                ),
                startSelector: const TimelineStartDisplay(),
                endSelector: const TimelineEndDisplay(),
              ),
            ),

            // Bottom panels arranged horizontally with expanded space
            SizedBox(
              height: bottomPanelHeight,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.blue.shade50,
                      child: const Center(
                        child: Text(
                          'Filter Settings Panel',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.green.shade50,
                      child: const Center(
                        child: Text(
                          'Notification Panel',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.orange.shade50,
                      child: const Center(
                        child: Text(
                          'Event Preview Placeholder',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
