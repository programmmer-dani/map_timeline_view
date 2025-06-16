import 'package:flutter/material.dart';
import '../widgets/map_view_widget.dart'; // Adjust the path if needed
import '../widgets/map_with_split_view.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //body: MapViewWidget(),
      body: MapWithSplitView(),
    );
  }
}
