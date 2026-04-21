import 'package:flutter/material.dart';
import 'package:tek_dokunus/app_colors.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, required this.username});

  final String username;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _isFollowing = false;

  static const List<List<Offset>> _dummyPaths = [
    [Offset(0.2,0.5),Offset(0.35,0.25),Offset(0.5,0.5),Offset(0.65,0.75),Offset(0.8,0.5)],
    [Offset(0.1,0.8),Offset(0.3,0.3),Offset(0.5,0.6),Offset(0.7,0.2),Offset(0.9,0.5)],
    [Offset(0.5,0.1),Offset(0.8,0.4),Offset(0.6,0.7),Offset(0.3,0.8),Offset(0.2,0.5)],
    [Offset(0.15,0.5),Offset(0.4,0.2),Offset(0.6,0.5),Offset(0.8,0.3),Offset(0.9,0.7)],
    [Offset(0.5,0.9),Offset(0.2,0.6),Offset(0.4,0.3),Offset(0.7,0.4),Offset(0.85,0.1)],
    [Offset(0.1,0.1),Offset(0.4,0.5),Offset(0.5,0.2),Offset(0.7,0.6),Offset(0.9,0.9)],
  ];

  static const List<Color> _pathColors = [
    Color(0xFFF4E6A2),
    Color(0xFF7EB8F7),
    Color(0xFFE88E8E),
    Colors.white,
    Color(0xFF4CC9A4),
    Color(0xFF9B8FFF),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context),
            _buildHeader(),
            const SizedBox(height: 16),
            Expanded(child: _buildGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF181818),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF282828)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 15, color: Colors.white70),
            ),
          ),
          const Spacer(),
          Text(
            widget.username,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withValues(alpha: 0.18),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.35), width: 1.5),
            ),
            child: Center(
              child: Text(
                widget.username.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@${widget.username}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '24 çizim  •  138 takipçi',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => setState(() => _isFollowing = !_isFollowing),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: _isFollowing
                    ? const Color(0xFF1E1E1E)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isFollowing
                      ? const Color(0xFF333333)
                      : Colors.white,
                ),
              ),
              child: Text(
                _isFollowing ? 'TAKİP EDİLİYOR' : 'TAKİP ET',
                style: TextStyle(
                  color: _isFollowing ? const Color(0xFF888888) : Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: _dummyPaths.length,
      itemBuilder: (context, i) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF1E1E1E)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomPaint(
              painter: _ProfileStrokePainter(
                path: _dummyPaths[i],
                color: _pathColors[i % _pathColors.length],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileStrokePainter extends CustomPainter {
  const _ProfileStrokePainter({required this.path, required this.color});

  final List<Offset> path;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size,
        Paint()..color = const Color(0xFF111111));

    if (path.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final p = Path();
    final first = path.first;
    p.moveTo(first.dx * size.width, first.dy * size.height);
    for (int i = 1; i < path.length; i++) {
      final prev = path[i - 1];
      final curr = path[i];
      final mid = Offset(
        (prev.dx + curr.dx) / 2 * size.width,
        (prev.dy + curr.dy) / 2 * size.height,
      );
      p.quadraticBezierTo(
        prev.dx * size.width, prev.dy * size.height,
        mid.dx, mid.dy,
      );
    }
    canvas.drawPath(p, paint);
  }

  @override
  bool shouldRepaint(covariant _ProfileStrokePainter old) =>
      old.path != path || old.color != color;
}
