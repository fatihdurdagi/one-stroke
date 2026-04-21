import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tek_dokunus/akis_page.dart';
import 'package:tek_dokunus/challenge_page.dart';
import 'package:tek_dokunus/drawing_page.dart';
import 'package:tek_dokunus/user_drawing_store.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late int _selectedIndex;

  static const List<_FeedPostData> _posts = [
    _FeedPostData(
      author: 'shu.aether',
      likes: '1.3K',
      comments: '48',
      style: _ArtworkStyle.mountain,
    ),
    _FeedPostData(
      author: 'drip.by.zen',
      likes: '402',
      comments: '19',
      style: _ArtworkStyle.wave,
    ),
    _FeedPostData(
      author: 'void.sketches',
      likes: '2K',
      comments: '124',
      style: _ArtworkStyle.heart,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildFeedTab(),
            const AkisPage(),
            _buildProfileTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const DrawingPage()),
          );
        },
        child: const Icon(Icons.edit_outlined),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 62,
          decoration: const BoxDecoration(
            color: Color(0xFF111111),
            border: Border(top: BorderSide(color: Color(0xFF232323))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BottomNavIcon(
                icon: Icons.home_filled,
                active: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              _BottomNavIcon(
                icon: Icons.explore_rounded,
                active: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              _BottomNavIcon(
                icon: Icons.person_rounded,
                active: _selectedIndex == 2,
                onTap: () => setState(() => _selectedIndex = 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedTab() {
    return ValueListenableBuilder<List<UserDrawing>>(
      valueListenable: UserDrawingStore.drawings,
      builder: (context, drawings, child) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
          children: [
            const _TopBar(),
            const SizedBox(height: 18),
            const WeeklyChallengeBanner(),
            if (drawings.isNotEmpty) ...[
              const _SectionTitle(
                title: 'GÖNDERİLERİNİZ',
                subtitle: 'Stüdyonuzdaki son tek darbe çizimleriniz.',
              ),
              const SizedBox(height: 14),
              for (final drawing in drawings) ...[
                _UserPostCard(drawing: drawing),
                const SizedBox(height: 18),
              ],
            ],
            const _SectionTitle(
              title: 'AKIŞ',
              subtitle: 'Topluluktan minimal monokrom ilham.',
            ),
            const SizedBox(height: 14),
            for (final post in _posts) ...[
              _FeedCard(post: post),
              const SizedBox(height: 18),
            ],
          ],
        );
      },
    );
  }

  Widget _buildProfileTab() {
    return ValueListenableBuilder<List<UserDrawing>>(
      valueListenable: UserDrawingStore.drawings,
      builder: (context, drawings, child) {
        final totalDrawings = drawings.length;
        final totalLikes = drawings.fold<int>(
          3200,
          (sum, drawing) => sum + drawing.score.round() * 2,
        );

        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _TopBar()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                child: Column(
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.2),
                        color: const Color(0xFF131313),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      '@artist_name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'DİJİTAL MİNİMALİST  ·  İSTANBUL',
                      style: TextStyle(
                        color: Color(0xFFA0A0A0),
                        fontSize: 11,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF151515),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xFF2A2A2A)),
                      ),
                      child: const Text(
                        'SEVİYE 2',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: _ProfileStat(
                            value: '$totalDrawings',
                            label: 'ÇİZİM',
                          ),
                        ),
                        Expanded(
                          child: _ProfileStat(
                            value: '${(totalLikes / 1000).toStringAsFixed(1)}B',
                            label: 'TAKİPÇİ',
                          ),
                        ),
                        const Expanded(
                          child: _ProfileStat(
                            value: '42',
                            label: 'TAKİP',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ProfileTabLabel(label: 'AKIŞ', active: true),
                        _ProfileTabLabel(label: 'ARŞİV'),
                        _ProfileTabLabel(label: 'BEĞENDİKLERİM'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
              sliver: drawings.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Center(
                          child: Text(
                            'Henüz çizim yok',
                            style: TextStyle(
                              color: Color(0xFF6A6A6A),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SliverGrid.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        childAspectRatio: 0.92,
                      ),
                      itemCount: drawings.length,
                      itemBuilder: (context, index) => _ProfileUserTile(
                        imageFile: drawings[index].imageFile,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _ChromeIcon(icon: Icons.menu_rounded),
        const Spacer(),
        const Text(
          'OneStroke',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.0,
          ),
        ),
        const Spacer(),
        const _ChromeIcon(icon: Icons.account_circle_outlined),
      ],
    );
  }
}

class _ChromeIcon extends StatelessWidget {
  const _ChromeIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF292929)),
      ),
      child: Icon(icon, color: Colors.white, size: 17),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF8F8F8F),
            fontSize: 13,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _FeedCard extends StatelessWidget {
  const _FeedCard({required this.post});

  final _FeedPostData post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            post.author,
            style: const TextStyle(
              color: Color(0xFFB0B0B0),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 260,
          decoration: BoxDecoration(
            color: const Color(0xFF070707),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: const Color(0xFF191919)),
          ),
          child: CustomPaint(
            painter: _ArtworkPainter(post.style),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.favorite_border_rounded,
                color: Colors.white, size: 16),
            const SizedBox(width: 5),
            Text(
              post.likes,
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
            const SizedBox(width: 14),
            const Icon(Icons.chat_bubble_outline_rounded,
                color: Colors.white, size: 14),
            const SizedBox(width: 5),
            Text(
              post.comments,
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
            const Spacer(),
            const Icon(Icons.bookmark_border_rounded,
                color: Colors.white, size: 16),
          ],
        ),
      ],
    );
  }
}

class _UserPostCard extends StatelessWidget {
  const _UserPostCard({required this.drawing});

  final UserDrawing drawing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF242424)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'you',
              style: TextStyle(
                color: Color(0xFFB0B0B0),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                height: 260,
                width: double.infinity,
                child: Image.file(
                  drawing.imageFile,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: const Color(0xFF1A1A1A));
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _MetaText(value: '${drawing.score.toStringAsFixed(0)} puan'),
                const SizedBox(width: 14),
                _MetaText(value: '${drawing.strokeLength.toStringAsFixed(0)} px'),
                const SizedBox(width: 14),
                _MetaText(value: '${drawing.drawingTime} ms'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class _MetaText extends StatelessWidget {
  const _MetaText({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF2B2B2B)),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProfileUserTile extends StatelessWidget {
  const _ProfileUserTile({required this.imageFile});

  final File imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF141414),
      child: Image.file(
        imageFile,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox.expand();
        },
      ),
    );
  }
}


class _BottomNavIcon extends StatelessWidget {
  const _BottomNavIcon({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 18,
          color: active ? Colors.black : Colors.white70,
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9A9A9A),
            fontSize: 10,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}

class _ProfileTabLabel extends StatelessWidget {
  const _ProfileTabLabel({
    required this.label,
    this.active = false,
  });

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: active ? Colors.white : const Color(0xFF838383),
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.1,
      ),
    );
  }
}

class _FeedPostData {
  const _FeedPostData({
    required this.author,
    required this.likes,
    required this.comments,
    required this.style,
  });

  final String author;
  final String likes;
  final String comments;
  final _ArtworkStyle style;
}

enum _ArtworkStyle {
  mountain,
  wave,
  heart,
  portraitLeft,
  portraitCenter,
  portraitRight,
  portraitFemale,
  portraitShadow,
  portraitSoft,
  letterB,
  numberSeven,
  numberNine,
}

class _ArtworkPainter extends CustomPainter {
  const _ArtworkPainter(this.style);

  final _ArtworkStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = const Color(0xFF050505);
    canvas.drawRect(Offset.zero & size, background);

    switch (style) {
      case _ArtworkStyle.mountain:
        _paintMountain(canvas, size);
        break;
      case _ArtworkStyle.wave:
        _paintWave(canvas, size);
        break;
      case _ArtworkStyle.heart:
        _paintHeart(canvas, size);
        break;
      case _ArtworkStyle.portraitLeft:
      case _ArtworkStyle.portraitCenter:
      case _ArtworkStyle.portraitRight:
      case _ArtworkStyle.portraitFemale:
      case _ArtworkStyle.portraitShadow:
      case _ArtworkStyle.portraitSoft:
        _paintPortrait(canvas, size, style);
        break;
      case _ArtworkStyle.letterB:
        _paintGlyph(canvas, size, 'b');
        break;
      case _ArtworkStyle.numberSeven:
        _paintGlyph(canvas, size, '7');
        break;
      case _ArtworkStyle.numberNine:
        _paintGlyph(canvas, size, '9');
        break;
    }
  }

  void _paintMountain(Canvas canvas, Size size) {
    final glow = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x0FFFFFFF), Color(0x00000000)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, glow);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.withValues(alpha: 0.78);

    final path = Path()
      ..moveTo(size.width * 0.08, size.height * 0.65)
      ..quadraticBezierTo(
        size.width * 0.28,
        size.height * 0.64,
        size.width * 0.44,
        size.height * 0.40,
      )
      ..quadraticBezierTo(
        size.width * 0.48,
        size.height * 0.30,
        size.width * 0.58,
        size.height * 0.15,
      )
      ..quadraticBezierTo(
        size.width * 0.65,
        size.height * 0.34,
        size.width * 0.82,
        size.height * 0.62,
      );
    canvas.drawPath(path, paint);

    final echo = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = Colors.white.withValues(alpha: 0.18);

    for (var i = 0; i < 2; i++) {
      final shift = (i + 1) * 8.0;
      final p = Path()
        ..moveTo(size.width * 0.08, size.height * 0.65 + shift)
        ..quadraticBezierTo(
          size.width * 0.28,
          size.height * 0.64 + shift,
          size.width * 0.44,
          size.height * 0.40 + shift,
        )
        ..quadraticBezierTo(
          size.width * 0.48,
          size.height * 0.30 + shift,
          size.width * 0.58,
          size.height * 0.15 + shift,
        )
        ..quadraticBezierTo(
          size.width * 0.65,
          size.height * 0.34 + shift,
          size.width * 0.82,
          size.height * 0.62 + shift,
        );
      canvas.drawPath(p, echo);
    }
  }

  void _paintWave(Canvas canvas, Size size) {
    final path = Path();
    const segments = 48;
    for (var i = 0; i <= segments; i++) {
      final x = size.width * i / segments;
      final y = size.height * 0.60 +
          math.sin(i / segments * math.pi * 2.2) * size.height * 0.11;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    for (var i = 0; i < 12; i++) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2 + (i * 0.26)
        ..color = Colors.white.withValues(alpha: 0.03 + i * 0.015)
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path.shift(Offset(0, i * 0.8)), paint);
    }
  }

  void _paintHeart(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 12);
    final base = Path();
    base.moveTo(center.dx, center.dy + 54);
    base.cubicTo(
      center.dx - 96,
      center.dy - 18,
      center.dx - 82,
      center.dy - 120,
      center.dx,
      center.dy - 42,
    );
    base.cubicTo(
      center.dx + 82,
      center.dy - 120,
      center.dx + 96,
      center.dy - 18,
      center.dx,
      center.dy + 54,
    );

    for (var i = 0; i < 10; i++) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 + i * 0.45
        ..color = Colors.white.withValues(alpha: 0.05 + i * 0.03)
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(base.shift(Offset(i * 0.4, i * 0.9)), paint);
    }
  }

  void _paintPortrait(Canvas canvas, Size size, _ArtworkStyle style) {
    final base = Paint()..color = const Color(0xFFE7E4DC);
    canvas.drawRect(Offset.zero & size, base);

    final shadow = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withValues(alpha: 0.02),
          Colors.black.withValues(alpha: 0.18),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, shadow);

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = const Color(0xFF4B4B4B);

    final fill = Paint()..color = const Color(0xFFB5B2AA);
    final head = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.38),
      width: size.width * 0.38,
      height: size.height * 0.46,
    );
    canvas.drawOval(head, fill);
    canvas.drawOval(head, stroke);

    final body = Path()
      ..moveTo(size.width * 0.28, size.height * 0.98)
      ..quadraticBezierTo(
        size.width * 0.50,
        size.height * 0.70,
        size.width * 0.72,
        size.height * 0.98,
      );
    canvas.drawPath(body, stroke);

    final eyeY = size.height * 0.36;
    canvas.drawLine(
      Offset(size.width * 0.40, eyeY),
      Offset(size.width * 0.47, eyeY),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.53, eyeY),
      Offset(size.width * 0.60, eyeY),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.47, size.height * 0.53),
      Offset(size.width * 0.53, size.height * 0.53),
      stroke,
    );

    if (style == _ArtworkStyle.portraitShadow ||
        style == _ArtworkStyle.portraitCenter) {
      final beard = Paint()..color = const Color(0xFF68645E);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(size.width * 0.5, size.height * 0.50),
          width: size.width * 0.24,
          height: size.height * 0.17,
        ),
        beard,
      );
    }

    if (style == _ArtworkStyle.portraitFemale ||
        style == _ArtworkStyle.portraitSoft) {
      final hair = Paint()..color = const Color(0xFF7C766E);
      final hairPath = Path()
        ..moveTo(size.width * 0.30, size.height * 0.18)
        ..quadraticBezierTo(
          size.width * 0.20,
          size.height * 0.45,
          size.width * 0.30,
          size.height * 0.74,
        )
        ..lineTo(size.width * 0.70, size.height * 0.74)
        ..quadraticBezierTo(
          size.width * 0.80,
          size.height * 0.45,
          size.width * 0.70,
          size.height * 0.18,
        )
        ..close();
      canvas.drawPath(hairPath, hair);
      canvas.drawPath(hairPath, stroke);
    }
  }

  void _paintGlyph(Canvas canvas, Size size, String char) {
    if (size.isEmpty) return;
    final paint = TextPainter(
      text: TextSpan(
        text: char,
        style: TextStyle(
          color: Colors.black.withValues(alpha: 0.72),
          fontSize: size.height * 0.82,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFE8E5DE),
    );
    paint.paint(
      canvas,
      Offset(
        (size.width - paint.width) / 2,
        (size.height - paint.height) / 2 - 4,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
