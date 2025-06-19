import 'package:flutter/material.dart';
import '../widgets/map_with_split_view.dart';
import '../widgets/control_panel.dart'; // Import the control panel

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          MapWithSplitView(),
          ControlPanel(), // Floating UI on top of the map
        ],
      ),
    );
  }
}
