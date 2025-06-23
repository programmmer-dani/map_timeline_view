import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_timeline_view/providers/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:map_timeline_view/providers/time_provider.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  final DateTime now = DateTime.now().subtract(const Duration(days: 1));
  final DateTime start = DateTime.now().subtract(const Duration(days: 2));
  final DateTime end = DateTime.now();
  final DateTime selected = now;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => TimelineRangeProvider(
                selectedTime: selected,
                visibleStart: start,
                visibleEnd: end,
              ),
        ),
        ChangeNotifierProvider(create: (_) => EventsProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'final concept POC',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
