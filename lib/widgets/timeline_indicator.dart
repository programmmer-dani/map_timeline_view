import 'package:flutter/material.dart';
import 'package:map_timeline_view/entities/event.dart';

class TimelineIndicator extends StatelessWidget {
  final Event event;
  final DateTime selectedTime;
  final Color groupColor;
  
  const TimelineIndicator({
    super.key,
    required this.event,
    required this.selectedTime,
    required this.groupColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: CustomPaint(
        painter: TimelineIndicatorPainter(
          event: event,
          selectedTime: selectedTime,
          groupColor: groupColor,
        ),
      ),
    );
  }
}

class TimelineIndicatorPainter extends CustomPainter {
  final Event event;
  final DateTime selectedTime;
  final Color groupColor;

  TimelineIndicatorPainter({
    required this.event,
    required this.selectedTime,
    required this.groupColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = groupColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final dottedPaint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    final totalDuration = event.end.difference(event.start).inMinutes;
    if (totalDuration <= 0) return;

    final timeBeforeSelected = selectedTime.difference(event.start).inMinutes;
    final timeAfterSelected = event.end.difference(selectedTime).inMinutes;

    final totalWidth = size.width - 4; 
    final centerX = size.width / 2;

    final eventStartX = centerX - (timeBeforeSelected / totalDuration) * totalWidth;
    final eventEndX = centerX + (timeAfterSelected / totalDuration) * totalWidth;
    
    final startX = eventStartX.clamp(2.0, size.width - 2.0);
    final endX = eventEndX.clamp(2.0, size.width - 2.0);
    
    canvas.drawLine(
      Offset(startX, size.height / 2),
      Offset(endX, size.height / 2),
      paint,
    );

    final dotLength = 2.0;
    final dotGap = 2.0;
    double currentY = 2;
    
    while (currentY < size.height - 2) {
      canvas.drawLine(
        Offset(centerX, currentY),
        Offset(centerX, currentY + dotLength),
        dottedPaint,
      );
      currentY += dotLength + dotGap;
    }

    if (selectedTime.isAfter(event.start) && selectedTime.isBefore(event.end)) {
      final circlePaint = Paint()
        ..color = groupColor
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(centerX, size.height / 2),
        3,
        circlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
} 