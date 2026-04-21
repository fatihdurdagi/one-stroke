import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:tek_dokunus/preview_page.dart';
import 'package:tek_dokunus/splash_screen.dart';
import 'package:tek_dokunus/user_drawing_store.dart';
import 'package:tek_dokunus/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  final GlobalKey repaintKey = GlobalKey();

  List<Offset?> points = [];

  double strokeWidth = 4;
  Color selectedColor = Colors.white;

  late int startTime;

  Future<File> captureImage() async {
    final boundary =
        repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage(pixelRatio: 3);

    ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    Uint8List bytes = byteData!.buffer.asUint8List(); 

    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/drawing_${DateTime.now().millisecondsSinceEpoch}.png';

    File file = File(path);
    await file.writeAsBytes(bytes);

    return file;
  }

  void resetCanvas() {
    setState(() {
      points.clear();
    });
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

  double calculateScore(double strokeLength, int drawingTime) {
    if (drawingTime <= 0) return 0;

    double speed = strokeLength / drawingTime;
    double score = speed * 10;

    if (score > 100) score = 100;

    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (details) {
              startTime = DateTime.now().millisecondsSinceEpoch;

              resetCanvas();

              setState(() {
                points.add(details.localPosition);
              });
            },
            onPanUpdate: (details) {
              setState(() {
                points.add(details.localPosition);
              });
            },
            onPanEnd: (details) async {
              setState(() {
                points.add(null);
              });

              int endTime = DateTime.now().millisecondsSinceEpoch;

              int drawingTime = endTime - startTime;
              final navigator = Navigator.of(context);
              final previewPoints = List<Offset?>.from(points);
              final previewColor = selectedColor;
              final strokeLength = calculateStrokeLength(previewPoints);
              final score = calculateScore(strokeLength, drawingTime);
              final imageFile = await captureImage();

              UserDrawingStore.add(
                UserDrawing(
                  imageFile: imageFile,
                  points: previewPoints,
                  drawingTime: drawingTime,
                  color: previewColor,
                  createdAt: DateTime.now(),
                  strokeLength: strokeLength,
                  score: score,
                ),
              );

              if (!mounted) return;

              navigator.push(
                MaterialPageRoute(
                  builder: (context) => PreviewPage(
                    imageFile: imageFile,
                    points: previewPoints,
                    drawingTime: drawingTime,
                    color: previewColor,
                  ),
                ),
              );
            },
            child: RepaintBoundary(
              key: repaintKey,
              child: CustomPaint(
                painter: DrawingPainter(
                  points,
                  strokeWidth,
                  selectedColor,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomePage(initialTab: 2),
                      ),
                      (route) => false,
                    );
                  },
                  child: Ink(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.home_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedColor = Colors.white;
                            });
                          },
                          child: const Text('Beyaz'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedColor = Colors.red;
                            });
                          },
                          child: const Text('Kirmizi'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedColor = Colors.blue;
                            });
                          },
                          child: const Text('Mavi'),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: resetCanvas,
                      child: const Text('Temizle'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Slider(
                  value: strokeWidth,
                  min: 1,
                  max: 20,
                  onChanged: (value) {
                    setState(() {
                      strokeWidth = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final double strokeWidth;
  final Color color;

  DrawingPainter(this.points, this.strokeWidth, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

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
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
