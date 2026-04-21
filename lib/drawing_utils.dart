import 'package:flutter/material.dart';

double calculateStrokeLength(List<Offset?> points) {
  var length = 0.0;
  for (var i = 0; i < points.length - 1; i++) {
    if (points[i] != null && points[i + 1] != null) {
      length += (points[i]! - points[i + 1]!).distance;
    }
  }
  return length;
}

double calculateScore(double strokeLength, int drawingTime) {
  if (drawingTime <= 0) {
    return 0;
  }

  var score = (strokeLength / drawingTime) * 10;
  if (score > 100) {
    score = 100;
  }
  return score;
}

class DrawingStrokePainter extends CustomPainter {
  DrawingStrokePainter({
    required this.points,
    required this.strokeWidth,
    required this.color,
  });

  final List<Offset?> points;
  final double strokeWidth;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) {
      return;
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    Offset? lastPoint;

    for (final point in points) {
      if (point == null) {
        lastPoint = null;
        continue;
      }

      if (lastPoint == null) {
        path.moveTo(point.dx, point.dy);
      } else {
        final midPoint = Offset(
          (lastPoint.dx + point.dx) / 2,
          (lastPoint.dy + point.dy) / 2,
        );
        path.quadraticBezierTo(
          lastPoint.dx,
          lastPoint.dy,
          midPoint.dx,
          midPoint.dy,
        );
      }

      lastPoint = point;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant DrawingStrokePainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.color != color;
  }
}
