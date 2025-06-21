import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'common/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const MainApp());
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
