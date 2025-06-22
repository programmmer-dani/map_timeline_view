import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:map_timeline_view/widgets/controlpanel_slider.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  bool get isMobile {
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }

  @override
  Widget build(BuildContext context) {
    final double spacing = isMobile ? 4.0 : 8.0;
    final double fontSize = isMobile ? 13.0 : 16.0;
    final double iconSize = isMobile ? 18.0 : 22.0;

    final double panelHeight = isMobile ? 70 : 72; // <-- ADJUSTED HERE

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.blueGrey.shade900,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: spacing),
          child: SizedBox(
            height: panelHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left side: Search + Buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
                  child: SizedBox(
                    width: isMobile ? 160 : 200,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: isMobile ? 28 : 32,
                          child: TextField(
                            style: TextStyle(fontSize: fontSize),
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: TextStyle(fontSize: fontSize),
                              filled: true,
                              fillColor: Colors.white,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: spacing / 2),

                        // Buttons row
                        SizedBox(
                          height: isMobile ? 26 : 28,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.white, size: iconSize),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {},
                              ),
                              if (isMobile)
                                Padding(
                                  padding: EdgeInsets.only(left: spacing),
                                  child: IconButton(
                                    icon: Icon(Icons.filter_alt, color: Colors.white, size: iconSize),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {},
                                  ),
                                ),
                              if (isMobile)
                                Padding(
                                  padding: EdgeInsets.only(left: spacing),
                                  child: IconButton(
                                    icon: Icon(Icons.notifications, color: Colors.white, size: iconSize),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {},
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right side: Time slider
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: isMobile ? 16 : 24),
                    child: const TimeSlider(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
