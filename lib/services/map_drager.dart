import 'package:flutter/material.dart';

class MapDragger extends StatelessWidget {
  final double height;
  final void Function(DragUpdateDetails) onDragUpdate;
  final void Function(DragEndDetails) onDragEnd;

  const MapDragger({
    super.key,
    required this.height,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: onDragUpdate,
      onVerticalDragEnd: onDragEnd,
      child: Center(
        child: Container(
          width: 30,
          height: height * 3.5,
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
    );
  }
}
