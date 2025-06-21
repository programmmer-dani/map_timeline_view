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
    final double padding = isMobile ? 4.0 : 6.0;
    final double spacing = isMobile ? 4.0 : 6.0;
    final double fontSize = isMobile ? 11.0 : 13.0;
    final double iconSize = isMobile ? 18.0 : 22.0;

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
                padding: const EdgeInsets.symmetric(horizontal: 40.0), // <- inset left/right more
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 20, // <- shorter height
                        child: TextField(
                          style: TextStyle(fontSize: fontSize),
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(fontSize: fontSize),
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 2,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.0),
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
      ),
    );
  }
}
