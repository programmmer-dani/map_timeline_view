import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import '../../common/widgets/map_with_split_view.dart';

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
      return const Center(child: Text('Desktop layout only'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final leftPanelWidth = width * 0.15;
        final bottomPanelHeight = height * 0.25;
        final mainHeight = height - bottomPanelHeight;

        return Row(
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
                        // Left half: Filter settings panel + Notification panel side-by-side
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              // Filter settings panel (left half)
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

                              // Notification panel (right half)
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
                            ],
                          ),
                        ),

                        // Right half: Event preview placeholder
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
