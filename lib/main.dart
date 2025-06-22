import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_timeline_view/providers/set_time_provider.dart';
import 'package:provider/provider.dart';

import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Define your pre-decided values
  final DateTime now = DateTime.now().subtract(const Duration(days: 1));
  final DateTime start = DateTime.now().subtract(const Duration(days: 2));
  final DateTime end = DateTime.now();
  final DateTime selected = now;

  runApp(
    ChangeNotifierProvider(
      create:
          (_) => TimelineRangeProvider(
            selectedTime: selected,
            visibleStart: start,
            visibleEnd: end,
          ),
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
