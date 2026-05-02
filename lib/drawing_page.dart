import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:one_stroke/models/drawing_result.dart';
import 'package:one_stroke/preview_page.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  final GlobalKey _canvasKey = GlobalKey();
  final List<Offset?> _points = [];

  Color _color = Colors.white;
  double _strokeWidth = 3.0;
  DateTime? _startTime;

  static const List<double> _strokeOptions = [2.0, 4.0, 8.0];
  static const List<Color> _colorOptions = [
    Colors.white,
    Color(0xFFF4E6A2),
    Color(0xFF7EB8F7),
    Color(0xFFE88E8E),
  ];

  Future<void> _finish() async {
    if (_points.isEmpty) return;
    final ms = _startTime != null
        ? DateTime.now().difference(_startTime!).inMilliseconds
        : 0;
    final result = DrawingResult.calculate(_points, ms);
    setState(() => _points.add(null));

    final bytes = await _capture();
    if (!mounted || bytes == null) return;

    final dir = await getTemporaryDirectory();
    final file = File(
        '${dir.path}/drip_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(bytes);
    if (!mounted) return;

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, anim, secondary) => PreviewPage(
          imageFile: file,
          points: List.from(_points),
          drawingTime: ms,
          color: _color,
          result: result,
        ),
        transitionsBuilder: (context, anim, secondary, child) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: child,
          ),
        ),
      ),
    );
  }

  Future<Uint8List?> _capture() async {
    try {
      final ctx = _canvasKey.currentContext;
      if (ctx == null) return null;
      final boundary = ctx.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          // Drawing canvas — SafeArea prevents strokes entering system gesture area
          SafeArea(
            child: RepaintBoundary(
              key: _canvasKey,
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: (e) => setState(() {
                  _points.clear();
                  _points.add(e.localPosition);
                  _startTime = DateTime.now();
                }),
                onPointerMove: (e) =>
                    setState(() => _points.add(e.localPosition)),
                onPointerUp: (_) => _finish(),
                child: CustomPaint(
                  painter:
                      _CanvasPainter(List.from(_points), _color, _strokeWidth),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                children: [
                  _NavBtn(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.maybePop(context),
                  ),
                  const Spacer(),
                  const Text(
                    'DRIP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3.5,
                    ),
                  ),
                  const Spacer(),
                  _NavBtn(
                    icon: Icons.replay_rounded,
                    onTap: () => setState(() => _points.clear()),
                  ),
                ],
              ),
            ),
          ),

          // Right toolbar
          Positioned(
            right: 14,
            top: 0,
            bottom: 0,
            child: SafeArea(
              child: Center(
                child: _Toolbar(
                  strokeOptions: _strokeOptions,
                  selectedStroke: _strokeWidth,
                  colorOptions: _colorOptions,
                  selectedColor: _color,
                  onStrokeChanged: (v) => setState(() => _strokeWidth = v),
                  onColorChanged: (v) => setState(() => _color = v),
                ),
              ),
            ),
          ),

          // Canvas hint
          if (_points.isEmpty)
            Positioned(
              bottom: 52,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'tek hamlede çiz',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.14),
                    fontSize: 12,
                    letterSpacing: 1.6,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Canvas painter ─────────────────────────────────────────────────────────────

class _CanvasPainter extends CustomPainter {
  _CanvasPainter(this.points, this.color, this.strokeWidth);

  final List<Offset?> points;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Offset.zero & size, Paint()..color = const Color(0xFF0D0D0D));

    final dot = Paint()..color = Colors.white.withValues(alpha: 0.07);
    const gap = 28.0;
    for (double x = gap; x < size.width; x += gap) {
      for (double y = gap; y < size.height; y += gap) {
        canvas.drawCircle(Offset(x, y), 0.85, dot);
      }
    }

    if (points.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    Offset? last;
    for (final p in points) {
      if (p == null) {
        last = null;
        continue;
      }
      if (last == null) {
        path.moveTo(p.dx, p.dy);
      } else {
        final mid = Offset((last.dx + p.dx) / 2, (last.dy + p.dy) / 2);
        path.quadraticBezierTo(last.dx, last.dy, mid.dx, mid.dy);
      }
      last = p;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CanvasPainter old) => true;
}

// ── Toolbar ───────────────────────────────────────────────────────────────────

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.strokeOptions,
    required this.selectedStroke,
    required this.colorOptions,
    required this.selectedColor,
    required this.onStrokeChanged,
    required this.onColorChanged,
  });

  final List<double> strokeOptions;
  final double selectedStroke;
  final List<Color> colorOptions;
  final Color selectedColor;
  final ValueChanged<double> onStrokeChanged;
  final ValueChanged<Color> onColorChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF242424)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final sw in strokeOptions) ...[
            GestureDetector(
              onTap: () => onStrokeChanged(sw),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: selectedStroke == sw
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: sw * 2.6,
                    height: sw * 2.6,
                    decoration: BoxDecoration(
                      color: selectedStroke == sw
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
          ],
          const SizedBox(height: 6),
          Container(height: 0.5, width: 20, color: const Color(0xFF2E2E2E)),
          const SizedBox(height: 6),
          for (final c in colorOptions) ...[
            GestureDetector(
              onTap: () => onColorChanged(c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: c,
                  border: Border.all(
                    color: selectedColor == c
                        ? Colors.white
                        : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: selectedColor == c
                      ? [
                          BoxShadow(
                              color: c.withValues(alpha: 0.45), blurRadius: 8)
                        ]
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}

// ── Nav button ────────────────────────────────────────────────────────────────

class _NavBtn extends StatelessWidget {
  const _NavBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF282828)),
        ),
        child: Icon(icon, size: 16, color: Colors.white70),
      ),
    );
  }
}
