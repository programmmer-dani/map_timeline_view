import 'package:flutter/material.dart';
import 'package:map_timeline_view/widgets/control_panel.dart';
import 'package:map_timeline_view/widgets/map_and_timeline.dart';

class PhoneMapLayout extends StatefulWidget {
  const PhoneMapLayout({super.key});

  @override
  State<PhoneMapLayout> createState() => _PhoneMapLayoutState();
}

class _PhoneMapLayoutState extends State<PhoneMapLayout> {
  // GlobalKey to access MapWithSplitView state
  final GlobalKey<MapWithSplitViewState> mapKey = GlobalKey<MapWithSplitViewState>();

  void _onTimeSliderChanged(DateTime newTime) {
    // Trigger marker recalculation on map when time changes
    mapKey.currentState?.recalculateMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapWithSplitView(key: mapKey),
        ControlPanel(onTimeChanged: _onTimeSliderChanged),
      ],
    );
  }
}
