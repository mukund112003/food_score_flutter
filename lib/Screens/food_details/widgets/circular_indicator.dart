import 'package:flutter/material.dart';
import 'dart:math';

class CircularIndicator extends StatelessWidget {
  final double progress; // Value from 0 to 100

  const CircularIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: CustomPaint(
        painter: ExactCircularIndicatorPainter(progress),
        child: Center(
          child: Text(
            '${progress.toInt()}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Inner text color
            ),
          ),
        ),
      ),
    );
  }
}

class ExactCircularIndicatorPainter extends CustomPainter {
  final double progress;

  ExactCircularIndicatorPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
   const  double lineWidth = 16; // Width of the circular stroke
    final double radius = size.width / 2;

    // Draw the outer background circle (lighter shade)
    final Paint backgroundPaint = Paint()
      ..color = const Color(0xFFFFE8A0) // Background circle color
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      radius - lineWidth / 2,
      backgroundPaint,
    );

    // Draw the progress arc (darker shade)
    final Paint progressPaint = Paint()
      ..color = const Color(0xFF688B36) // Progress arc color
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;

    const double startAngle = -90 * pi / 180; // Start angle in radians
    final double sweepAngle = 2 * pi * (progress / 100); // Sweep angle in radians

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: radius - lineWidth / 2,
      ),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );

    // Draw the knob (small circular dot at the end of the progress arc)
    final double knobAngle = startAngle + sweepAngle;
    final double knobX =
        size.width / 2 + (radius - lineWidth / 2) * cos(knobAngle);
    final double knobY =
        size.height / 2 + (radius - lineWidth / 2) * sin(knobAngle);

    final Paint knobPaint = Paint()
      ..color = const Color(0xFF688B36); // Knob color (same as progress)
    canvas.drawCircle(Offset(knobX, knobY), 8, knobPaint);

    // Inner circular fill
    final Paint innerCirclePaint = Paint()
      ..color = const Color(0xFFFFF4E1) // Inner circle color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      radius - lineWidth - 4, // Slight padding to ensure it fits
      innerCirclePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


