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
    final double fontSize = isMobile ? 11.0 : 14.0;
    final double iconSize = isMobile ? 18.0 : 24.0;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.blueGrey.shade900,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: spacing),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row 1: Search + Slider
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 40.0 : 0.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: isMobile ? 20 : 35,
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
                              vertical: 2,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      flex: 3,
                      // Replace this whole SliderTheme+Slider with your TimeSlider
                      child: const TimeSlider(),
                    ),
                  ],
                ),
              ),

              SizedBox(height: spacing / 1.5),

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
                      icon: Icon(
                        Icons.filter_alt,
                        color: Colors.white,
                        size: iconSize,
                      ),
                      padding: EdgeInsets.only(left: spacing),
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                    ),
                  if (isMobile)
                    IconButton(
                      icon: Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: iconSize,
                      ),
                      padding: EdgeInsets.only(left: spacing),
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
