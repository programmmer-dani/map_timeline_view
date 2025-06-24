import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:map_timeline_view/desktop/widgets/event_preview_panel.dart';
import 'package:map_timeline_view/widgets/notifications.dart';
import 'package:map_timeline_view/widgets/researchgroup_selector.dart';
import 'package:map_timeline_view/widgets/start_and_end_selectors.dart';
import 'package:provider/provider.dart';
import 'package:map_timeline_view/providers/selected_event_provider.dart';
import '../../widgets/map_view.dart';
import '../../widgets/timeline_widget.dart';
import '../../widgets/split_view.dart';
import '../../widgets/control_panel.dart';

class DesktopMapLayout extends StatelessWidget {
  DesktopMapLayout({super.key});

  final GlobalKey _splitViewKey = GlobalKey();

  bool get isDesktop =>
      ![
        TargetPlatform.iOS,
        TargetPlatform.android,
        TargetPlatform.fuchsia,
      ].contains(defaultTargetPlatform);

  static const double controlPanelHeight = 88.0;
  static const double bottomPanelHeight = 225.0;

  @override
  Widget build(BuildContext context) {
    if (!isDesktop) {
      return const Center(child: Text('Desktop layout only'));
    }

    final selectedEvent = context.watch<SelectedEventProvider>().event;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        final mainHeight =
            availableHeight - controlPanelHeight - bottomPanelHeight;

        return Column(
          children: [
            SizedBox(height: controlPanelHeight, child: ControlPanel()),
            SizedBox(
              height: mainHeight,
              child: SplitView(
                key: _splitViewKey,
                initialSplitRatio: 1.0,
                minSplitRatio: 0.0,
                maxSplitRatio: 1.0,
                draggerHeight: 40,
                isMobile: false,
                topChild: const TimelineView(),
                bottomChild: const MapView(),
                startSelector: const TimelineStartDisplay(),
                endSelector: const TimelineEndDisplay(),
              ),
            ),
            SizedBox(
              height: bottomPanelHeight,
              child: Row(
                children: [
                  const Expanded(child: ResearchGroupSelectorGrid()),
                  Expanded(
                    child: const NotificationCenterWidget()
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.orange.shade50,
                      child:
                          selectedEvent != null
                              ? const EventPreviewPanel()
                              : const Center(
                                child: Text(
                                  'Select an event to preview',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
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
}
