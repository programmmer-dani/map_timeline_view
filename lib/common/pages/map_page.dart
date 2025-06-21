import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

import '../../desktop/widgets/desktop_layout.dart'; // desktop layout
import '../../mobile/widgets/mobile_layout.dart'; // desktop layout

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  bool get isDesktop =>
      ![
        TargetPlatform.iOS,
        TargetPlatform.android,
        TargetPlatform.fuchsia,
      ].contains(defaultTargetPlatform);

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return const Scaffold(body: DesktopMapLayout());
    } else {
      return const Scaffold(body: PhoneMapLayout());
    }
  }
}
