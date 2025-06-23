// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:map_timeline_view/providers/researchgroup_provider.dart';
// import 'package:map_timeline_view/providers/time_provider.dart';
// import 'package:map_timeline_view/services/map_drager.dart';
// import 'package:map_timeline_view/widgets/control_panel.dart';
// import 'package:map_timeline_view/widgets/start_and_end_selectors.dart';
// import 'package:map_timeline_view/widgets/timeline.dart';
// import 'package:map_timeline_view/widgets/map_view.dart';
// import 'package:map_timeline_view/services/marker_service.dart';
// import 'package:provider/provider.dart';

// class MapWithSplitView extends StatefulWidget {
//   const MapWithSplitView({super.key});

//   @override
//   State<MapWithSplitView> createState() => MapWithSplitViewState();
// }

// class MapWithSplitViewState extends State<MapWithSplitView> {
//   final double controlPanelHeight = 78.0;
//   double _splitRatio = 1.0;
//   final double _minSplit = 0.47;
//   final double _maxSplit = 0.7;

//   final MapController _mapController = MapController();
//   final MarkerService _markerService = MarkerService();

//   List<Marker> _markers = [];
//   Timer? _debounceTimer;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => recalculateMarkers());
//   }

//   void recalculateMarkers() {
//     final bounds = _mapController.camera.visibleBounds;
//     final groups = context.read<ResearchGroupsProvider>().groups;
//     final timeProvider = context.read<TimelineRangeProvider>();

//     final newMarkers = _markerService.buildMarkers(
//       groups: groups,
//       timeProvider: timeProvider,
//       bounds: bounds,
//     );

//     setState(() {
//       _markers = newMarkers;
//     });
//   }

//   void _onMapInteraction(MapEvent event) {
//     _debounceTimer?.cancel();
//     _debounceTimer = Timer(
//       const Duration(milliseconds: 200),
//       recalculateMarkers,
//     );
//   }

//   @override
//   void dispose() {
//     _debounceTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double draggerHeight = 40;
//     final double halfDraggerHeight = draggerHeight / 2;
//     final isMobile = ControlPanel().isMobile;

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final height = constraints.maxHeight;
//         final mapHeight = _splitRatio * height;
//         final topHeight = height - mapHeight - draggerHeight;

//         return Stack(
//           children: [
//             if (_splitRatio < 1.0)
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 height: topHeight,
//                 child: TimelineView(
//                   researchGroups: ['Group A', 'Group B'], // Update accordingly
//                   visibleStart: DateTime.now().subtract(
//                     const Duration(hours: 1),
//                   ),
//                   visibleEnd: DateTime.now().add(const Duration(hours: 1)),
//                 ),
//               ),

//             Positioned(
//               top: topHeight + draggerHeight,
//               left: 0,
//               right: 0,
//               height: mapHeight,
//               child: MapView(
//                 mapController: _mapController,
//                 markers: _markers,
//                 onMapEvent: _onMapInteraction,
//               ),
//             ),

//             Positioned(
//               top: topHeight + controlPanelHeight + halfDraggerHeight,
//               left: 0,
//               right: 0,
//               height: draggerHeight,
//               child: MapDragger(
//                 height: draggerHeight,
//                 onDragUpdate: (details) {
//                   setState(() {
//                     _splitRatio -= details.delta.dy / height;
//                     _splitRatio = _splitRatio.clamp(_minSplit, 1.0);
//                   });
//                 },
//                 onDragEnd: (details) {
//                   setState(() {
//                     if (_splitRatio < _minSplit) {
//                       _splitRatio = isMobile ? 0.20 : 0.11;
//                     } else if (_splitRatio > _maxSplit) {
//                       _splitRatio = 1.0;
//                     }
//                   });
//                 },
//               ),
//             ),

//             Positioned(
//               bottom: 16,
//               left: 16,
//               child: const TimelineStartDisplay(),
//             ),
//             Positioned(
//               bottom: 16,
//               right: 16,
//               child: const TimelineEndDisplay(),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
