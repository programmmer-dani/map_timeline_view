import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

import '../desktop/widgets/desktop_layout.dart';
import '../mobile/widgets/mobile_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  bool get isDesktop =>
      ![
        TargetPlatform.iOS,
        TargetPlatform.android,
        TargetPlatform.fuchsia,
      ].contains(defaultTargetPlatform);

@override
Widget build(BuildContext context) {
  if (isDesktop) {
    return Scaffold(
      body: SafeArea(child: DesktopMapLayout()),
    );
  } else {
    return Scaffold(
      body: SafeArea(child: MobileLayout()),
    );
  }
}
}
