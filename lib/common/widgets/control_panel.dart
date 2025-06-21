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
    final double padding = isMobile ? 6.0 : 8.0;
    final double spacing = isMobile ? 6.0 : 8.0;
    final double fontSize = isMobile ? 12.0 : 14.0;
    final double iconSize = isMobile ? 20.0 : 24.0;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(padding),
        color: Colors.blueGrey.shade900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row 1: Search + Slider
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 36,
                    child: TextField(
                      style: TextStyle(fontSize: fontSize),
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(fontSize: fontSize),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: padding,
                          vertical: 6,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  flex: 3,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2.5,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(
                      value: 0.5,
                      onChanged: (v) {},
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: spacing),

            // Row 2: Icons
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white, size: iconSize),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {},
                ),
                if (isMobile)
                  IconButton(
                    icon: Icon(Icons.filter_alt, color: Colors.white, size: iconSize),
                    padding: EdgeInsets.only(left: spacing),
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                  ),
                if (isMobile)
                  IconButton(
                    icon: Icon(Icons.notifications, color: Colors.white, size: iconSize),
                    padding: EdgeInsets.only(left: spacing),
                    constraints: const BoxConstraints(),
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
