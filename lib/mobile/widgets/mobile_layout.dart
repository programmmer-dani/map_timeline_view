import 'package:flutter/material.dart';
import 'package:map_timeline_view/widgets/control_panel.dart';
import 'package:map_timeline_view/widgets/split_view.dart';
import 'package:map_timeline_view/widgets/map_view.dart';
import 'package:map_timeline_view/widgets/timeline.dart';

class PhoneMapLayout extends StatefulWidget {
  const PhoneMapLayout({super.key});

  @override
  State<PhoneMapLayout> createState() => _PhoneMapLayoutState();
}

class _PhoneMapLayoutState extends State<PhoneMapLayout> {
  final GlobalKey<MapViewState> mapKey = GlobalKey<MapViewState>();

  void _onTimeSliderChanged(DateTime newTime) {
    mapKey.currentState?.recalculateMarkers();
  }

  static const double controlPanelHeight = 78.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: controlPanelHeight,
            child: ControlPanel(onTimeChanged: _onTimeSliderChanged),
          ),

          Expanded(
            child: SplitView(
              topChild: TimelineView(
                researchGroups: ['Group A', 'Group B'],
                visibleStart: DateTime.now().subtract(Duration(hours: 1)),
                visibleEnd: DateTime.now().add(Duration(hours: 1)),
              ),
              bottomChild: MapView(key: mapKey),
            ),
          ),
        ],
      ),
    );
  }
}
