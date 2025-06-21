import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import '../../common/widgets/map_with_split_view.dart';
import '../../common/widgets/control_panel.dart'; // import ControlPanel

class DesktopMapLayout extends StatelessWidget {
  const DesktopMapLayout({super.key});

  bool get isDesktop =>
      ![
        TargetPlatform.iOS,
        TargetPlatform.android,
        TargetPlatform.fuchsia,
      ].contains(defaultTargetPlatform);

  @override
  Widget build(BuildContext context) {
    if (!isDesktop) {
      // Fallback if someone uses this on mobile
      return const Center(child: Text('Desktop layout only'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final leftPanelWidth = width * 0.15;
        final bottomPanelHeight = height * 0.25;
        final mainHeight = height - bottomPanelHeight;

        return Stack(
          children: [
            Row(
              children: [
                // Left sidebar with research groups
                Container(
                  width: leftPanelWidth,
                  color: Colors.grey.shade200,
                  child: _buildResearchGroups(),
                ),

                // Main content: Map + bottom panels
                Expanded(
                  child: Column(
                    children: [
                      // Map area takes top 75%
                      SizedBox(
                        height: mainHeight,
                        child: const MapWithSplitView(),
                      ),

                      // Bottom 25% panel split horizontally
                      SizedBox(
                        height: bottomPanelHeight,
                        child: Row(
                          children: [
                            // Left half: Filter settings panel + Notification panel
                            
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
                                  
                                  // Notification panel (left half of left side)
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

                            // Right half: Notification panel + Event preview
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  // Event preview placeholder (right half of right side)
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

            // Floating ControlPanel on top
            const Positioned(top: 0, left: 0, right: 0, child: ControlPanel()),
          ],
        );
      },
    );
  }

  Widget _buildResearchGroups() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: List.generate(
        10,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ElevatedButton(
            onPressed: () {
              // TODO: implement group select/deselect logic
            },
            child: Text('Research Group ${index + 1}'),
          ),
        ),
      ),
    );
  }
}
