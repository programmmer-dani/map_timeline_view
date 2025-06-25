import 'package:flutter/material.dart';
import 'package:map_timeline_view/widgets/timeline_widget.dart';
import 'package:map_timeline_view/widgets/map_view.dart';
import 'package:map_timeline_view/widgets/control_panel.dart';
import 'package:map_timeline_view/widgets/split_view.dart';
import 'package:map_timeline_view/widgets/start_and_end_selectors.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ControlPanel(),
          Expanded(
            child: SplitView(
              topChild: const TimelineWidget(),
              bottomChild: const MapView(),
              initialSplitRatio: 1.0,
              minSplitRatio: 0.0,
              maxSplitRatio: 1.0,
              draggerHeight: 40,
              isMobile: true,
              startSelector: const TimelineStartDisplay(),
              endSelector: const TimelineEndDisplay(),
            ),
          ),
        ],
      ),
    );
  }
}
