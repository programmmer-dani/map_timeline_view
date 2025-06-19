import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  bool get isMobile {
    return defaultTargetPlatform == TargetPlatform.iOS ||
           defaultTargetPlatform == TargetPlatform.android;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(12),
        color: isMobile ? Colors.blue.shade600 : Colors.blueGrey.shade900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row 1: Search + Timeline Slider
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Slider(
                    value: 0.5,
                    onChanged: (v) {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Row 2: Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {},
                ),
                if (isMobile)
                  IconButton(
                    icon: const Icon(Icons.filter_alt, color: Colors.white),
                    onPressed: () {},
                  ),
                if (isMobile)
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {},
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
