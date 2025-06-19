import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

import '../widgets/map_with_split_view.dart';
import '../widgets/control_panel.dart';
import '../../desktop/widgets/desktop_layout.dart'; // Import the new desktop layout widget

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  bool get isDesktop =>
      ![
        TargetPlatform.iOS,
        TargetPlatform.android,
        TargetPlatform.fuchsia,
      ].contains(defaultTargetPlatform);

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      // Show the desktop layout (map + sidebars + bottom panels)
      return const Scaffold(
        body: DesktopMapLayout(),
      );
    } else {
      // Show map with split view and floating control panel on mobile/tablet
      return const Scaffold(
        body: Stack(
          children: [
            MapWithSplitView(),
            ControlPanel(),
          ],
        ),
      );
    }
  }
}
