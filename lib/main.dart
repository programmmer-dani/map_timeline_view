import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_timeline_view/mock_data.dart';
import 'package:map_timeline_view/providers/event_provider.dart';
import 'package:map_timeline_view/providers/marker_provider.dart';
import 'package:map_timeline_view/providers/researchgroup_provider.dart';
import 'package:map_timeline_view/providers/search_provider.dart';
import 'package:map_timeline_view/providers/selected_event_provider.dart';
import 'package:map_timeline_view/providers/time_provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

import 'pages/login_page.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container();
  };

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  final DateTime start = DateTime(2025, 6, 1);
  final DateTime end = DateTime(2025, 8, 1);
  final DateTime selected = DateTime(2025, 7, 24);

  final timelineProvider = TimelineRangeProvider(
    selectedTime: selected,
    visibleStart: start,
    visibleEnd: end,
  );

  final researchGroupsProvider = ResearchGroupsProvider();
  final eventsProvider = EventsProvider();
  final mapController = MapController();

  // Initialize all mock data using the centralized service
  MockDataService.instance.initializeAllMockData(
    researchGroupsProvider: researchGroupsProvider,
    eventsProvider: eventsProvider,
    timeProvider: timelineProvider,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TimelineRangeProvider>.value(
          value: timelineProvider,
        ),
        ChangeNotifierProvider<EventsProvider>.value(value: eventsProvider),
        ChangeNotifierProvider<ResearchGroupsProvider>.value(
          value: researchGroupsProvider,
        ),
        ChangeNotifierProvider<MapMarkerProvider>(
          create: (_) => MapMarkerProvider(
            mapController: mapController,
          ),
        ),
        ChangeNotifierProvider<SelectedEventProvider>(
          create: (_) => SelectedEventProvider(),
        ),
        ChangeNotifierProvider<SearchProvider>(
          create: (_) => SearchProvider(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'final concept POC',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: const LoginPage(),
    );
  }
}
