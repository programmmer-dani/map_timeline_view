import 'package:flutter/material.dart';
import 'package:map_timeline_view/widgets/control_panel.dart';
import 'package:map_timeline_view/widgets/split_view.dart';
import 'package:map_timeline_view/widgets/map_view.dart';
import 'package:map_timeline_view/widgets/start_and_end_selectors.dart';
import 'package:map_timeline_view/widgets/timeline_widget.dart';

class PhoneMapLayout extends StatefulWidget {
  const PhoneMapLayout({super.key});

  @override
  State<PhoneMapLayout> createState() => _PhoneMapLayoutState();
}

class _PhoneMapLayoutState extends State<PhoneMapLayout> {
  static const double controlPanelHeight = 78.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: controlPanelHeight, child: ControlPanel()),

          Expanded(
            child: SplitView(
              initialSplitRatio: 1.0,
              minSplitRatio: 0.0,
              maxSplitRatio: 1.0,
              isMobile: true,
              draggerHeight: 40,
              topChild: const TimelineView(),
              bottomChild: const MapView(),
              startSelector: const TimelineStartDisplay(),
              endSelector: const TimelineEndDisplay(),
            ),
          ),
        ],
      ),
    );
  }
}
