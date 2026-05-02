import 'package:flutter/material.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';
import 'package:one_stroke/drawing_page.dart';
import 'package:one_stroke/models/drawing_result.dart';

class PreviewPage extends StatefulWidget {
  final File imageFile;
  final List<Offset?> points;
  final int drawingTime;
  final Color color;
  final DrawingResult? result;

  const PreviewPage({
    super.key,
    required this.imageFile,
    required this.points,
    required this.drawingTime,
    required this.color,
    this.result,
  });

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {

  List<Offset?> replayPoints = [];
  double strokeLength = 0;

  bool isReplaying = false;
  double replaySpeed = 1.0;

  int replayToken = 0;

  double replayProgress = 0;

  @override
  void initState() {
    super.initState();
    strokeLength = calculateStrokeLength(widget.points);
    startReplay();
  }

  double calculateStrokeLength(List<Offset?> points) {

    double length = 0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        length += (points[i]! - points[i + 1]!).distance;
      }
    }

    return length;
  }

  double calculateScore() {

    double speed = strokeLength / widget.drawingTime;
    double score = speed * 10;

    if (score > 100) score = 100;

    return score;
  }

  Future<void> startReplay() async {

    replayToken++;
    int currentToken = replayToken;

    setState(() {
      isReplaying = true;
      replayPoints.clear();
      replayProgress = 0;
    });

    for (int i = 0; i < widget.points.length; i++) {

      if (currentToken != replayToken) return;

      if (!mounted) return;

      setState(() {
        replayPoints.add(widget.points[i]);
        replayProgress = i / widget.points.length;
      });

      int delay = (8 / replaySpeed).round();

      await Future.delayed(Duration(milliseconds: delay));
    }

    if (!mounted) return;

    setState(() {
      isReplaying = false;
      replayProgress = 1;
    });
  }

  Future<void> saveImage() async {
    await Gal.putImage(widget.imageFile.path);
  }

  Future<void> shareImage() async {
    await Share.shareXFiles([XFile(widget.imageFile.path)]);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      body: Column(
        children: [

          Expanded(
            child: CustomPaint(
              painter: DrawingPainter(replayPoints, widget.color),
              size: Size.infinite,
            ),
          ),

          const SizedBox(height: 10),

          /// REPLAY BUTONLARI
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              IconButton(
                icon: const Icon(Icons.replay, color: Colors.white, size: 32),
                onPressed: () {
                  replaySpeed = 1.0;
                  startReplay();
                },
              ),

              const SizedBox(width: 20),

              IconButton(
                icon: const Icon(Icons.fast_forward, color: Colors.white, size: 32),
                onPressed: () {
                  replaySpeed = 3.0;
                  startReplay();
                },
              ),

            ],
          ),

          const SizedBox(height: 10),

          /// PROGRESS BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: LinearProgressIndicator(
              value: replayProgress,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 6,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            "Stroke Length: ${strokeLength.toStringAsFixed(0)} px",
            style: const TextStyle(color: Colors.white),
          ),

          Text(
            "Drawing Time: ${widget.drawingTime} ms",
            style: const TextStyle(color: Colors.white),
          ),

          Text(
            "Gesture Score: ${calculateScore().toStringAsFixed(0)} / 100",
            style: const TextStyle(
              color: Colors.green,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DrawingPage(),
                    ),
                    (route) => false,
                  );
                },
                child: const Text("Tekrar Çiz"),
              ),

              ElevatedButton(
                onPressed: saveImage,
                child: const Text("Kaydet"),
              ),

              ElevatedButton(
                onPressed: shareImage,
                child: const Text("Paylaş"),
              ),

            ],
          ),

          const SizedBox(height: 40)

        ],
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {

  final List<Offset?> points;
  final Color color;

  DrawingPainter(this.points, this.color);

  @override
  void paint(Canvas canvas, Size size) {

    if (points.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
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
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}