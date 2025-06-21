import 'package:flutter/material.dart';
import 'package:map_timeline_view/universal_widgets/control_panel.dart';
import 'package:map_timeline_view/universal_widgets/map_and_timeline.dart';

class PhoneMapLayout extends StatelessWidget {
  const PhoneMapLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        MapWithSplitView(),
        ControlPanel(),
      ],
    );
  }
}
