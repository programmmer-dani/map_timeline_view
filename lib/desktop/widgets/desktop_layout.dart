import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import '../../widgets/map_and_timeline.dart';
import '../../widgets/control_panel.dart';

class DesktopMapLayout extends StatefulWidget {
  const DesktopMapLayout({super.key});

  @override
  State<DesktopMapLayout> createState() => _DesktopMapLayoutState();
}

class _DesktopMapLayoutState extends State<DesktopMapLayout> {
  final GlobalKey<MapWithSplitViewState> mapKey = GlobalKey<MapWithSplitViewState>();

  bool get isDesktop =>
      ![
        TargetPlatform.iOS,
        TargetPlatform.android,
        TargetPlatform.fuchsia,
      ].contains(defaultTargetPlatform);

  void _onTimeSliderChanged(DateTime newTime) {
    mapKey.currentState?.recalculateMarkers();
  }

  @override
  Widget build(BuildContext context) {
    if (!isDesktop) {
      // Fallback if not desktop
      return const Center(child: Text('Desktop layout only'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final bottomPanelHeight = height * 0.25;
        final mainHeight = height - bottomPanelHeight;

        return Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: mainHeight,
                        child: MapWithSplitView(key: mapKey),
                      ),

                      SizedBox(
                        height: bottomPanelHeight,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
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
                                    flex: 1,
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
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
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
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Floating control panel
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ControlPanel(onTimeChanged: _onTimeSliderChanged),
            ),
          ],
        );
      },
    );
  }
}
