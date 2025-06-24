import 'package:flutter/material.dart';

class SplitView extends StatefulWidget {
  final Widget topChild;
  final Widget bottomChild;
  final double initialSplitRatio;
  final double minSplitRatio;
  final double maxSplitRatio;
  final double draggerHeight;
  final bool isMobile;

  final Widget startSelector;
  final Widget endSelector;

  const SplitView({
    Key? key,
    required this.topChild,
    required this.bottomChild,
    this.initialSplitRatio = 0.5,
    this.minSplitRatio = 0.3,
    this.maxSplitRatio = 0.7,
    this.draggerHeight = 40,
    this.isMobile = false,
    required this.startSelector,
    required this.endSelector,
  }) : super(key: key);

  @override
  State<SplitView> createState() => _SplitViewState();
}

class _SplitViewState extends State<SplitView> {
  late double _splitRatio;

  @override
  void initState() {
    super.initState();
    _splitRatio = widget.initialSplitRatio; // ✅ respects passed value
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final draggerHeight = widget.draggerHeight;
        final halfDraggerHeight = draggerHeight / 2;

        final mapHeight = _splitRatio * height;
        final topHeight = height - mapHeight - draggerHeight;

        return Stack(
          children: [
            // Top child
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: topHeight > 0 ? topHeight : 0,
              child: widget.topChild,
            ),

            // Bottom child
            Positioned(
              top: topHeight + draggerHeight,
              left: 0,
              right: 0,
              height: mapHeight,
              child: widget.bottomChild,
            ),

            // Dragger handle
            Positioned(
              top: topHeight + halfDraggerHeight,
              left: 0,
              right: 0,
              height: draggerHeight,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    _splitRatio -= details.delta.dy / height;
                    _splitRatio = _splitRatio.clamp(
                      widget.minSplitRatio,
                      widget.maxSplitRatio,
                    );
                  });
                },
                onVerticalDragEnd: (_) {
                  setState(() {
                    // Snap behavior (optional)
                    if ((1.0 - _splitRatio) < 0.25) {
                      _splitRatio = 1.0;
                    } else if (_splitRatio < 0.25) {
                      _splitRatio = 0.0;
                    }
                  });
                },
                child: Center(
                  child: Container(
                    width: 30,
                    height: draggerHeight * 3.5,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(40),
                        bottom: Radius.circular(40),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.drag_handle,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Start time overlay
            Positioned(
              bottom: 0,
              left: 0,
              child: SafeArea(
                minimum: const EdgeInsets.only(left: 16, bottom: 16),
                child: widget.startSelector,
              ),
            ),

            // End time overlay
            Positioned(
              bottom: 0,
              right: 0,
              child: SafeArea(
                minimum: const EdgeInsets.only(right: 16, bottom: 16),
                child: widget.endSelector,
              ),
            ),
          ],
        );
      },
    );
  }
}
