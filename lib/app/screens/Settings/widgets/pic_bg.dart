// This is the Painter class
import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.black.withOpacity(0.5);
    // Paint paint2 = Paint()..color = Colors.green.withOpacity(0.2);
    var center = Offset(size.height / 2, size.width / 2);
    var drawArc = Rect.fromCenter(
        center: center, height: size.height * 2, width: size.width * 2);
    // canvas.drawCircle(center, size.width, paint2);

    canvas.drawArc(drawArc, -math.pi * 5.9, math.pi * 0.8, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
