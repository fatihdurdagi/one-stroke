import 'package:flutter/material.dart';
import 'package:one_stroke/app_colors.dart';
import 'package:one_stroke/models/comment_model.dart';
import 'package:one_stroke/models/drawing_result.dart';
import 'package:one_stroke/user_profile_page.dart';

// ── Local data model ──────────────────────────────────────────────────────────

class _AkisEntry {
  _AkisEntry({
    required this.id,
    required this.username,
    required this.result,
    required this.likeCount,
    required this.commentCount,
    required this.pathIndex,
    required this.comments,
  });

  final String        id;
  final String        username;
  final DrawingResult result;
  int                 likeCount;
  final int           commentCount;
  final int           pathIndex;
  final List<CommentModel> comments;
}

// ── Dummy paths (relative 0–1 coords, scaled in painter) ─────────────────────

const List<List<Offset>> _dummyPaths = [
  [Offset(.10,.50),Offset(.25,.25),Offset(.45,.70),Offset(.65,.25),Offset(.85,.55),Offset(.95,.45)],
  [Offset(.50,.08),Offset(.85,.30),Offset(.92,.65),Offset(.70,.88),Offset(.35,.92),Offset(.12,.70),Offset(.08,.38),Offset(.28,.12),Offset(.50,.08)],
  [Offset(.15,.80),Offset(.35,.55),Offset(.50,.50),Offset(.65,.45),Offset(.85,.20)],
  [Offset(.20,.20),Offset(.20,.80),Offset(.50,.95),Offset(.80,.80),Offset(.80,.20)],
  [Offset(.10,.10),Offset(.50,.50),Offset(.90,.10)],
  [Offset(.10,.50),Offset(.30,.20),Offset(.50,.50),Offset(.70,.80),Offset(.90,.50)],
  [Offset(.50,.10),Offset(.80,.40),Offset(.65,.80),Offset(.35,.80),Offset(.20,.40),Offset(.50,.10)],
  [Offset(.20,.60),Offset(.40,.20),Offset(.60,.20),Offset(.80,.60),Offset(.60,.90),Offset(.40,.90),Offset(.20,.60)],
];

// ── Dummy data ────────────────────────────────────────────────────────────────

List<_AkisEntry> _buildDummyFeed() => [
  _AkisEntry(id:'1', username:'deniz.c',   result:const DrawingResult(strokeLength:1240,drawingTimeMs:3200,fluency:82,score:8), likeCount:341, commentCount:12, pathIndex:0, comments:[
    CommentModel(id:'c1',userId:'u2',username:'meryem.art', text:'Harika bir çizim!',    createdAt:DateTime(2024,1,1)),
    CommentModel(id:'c2',userId:'u3',username:'koray.sk',   text:'Çok akıcı görünüyor.', createdAt:DateTime(2024,1,2)),
  ]),
  _AkisEntry(id:'2', username:'meryem.art',result:const DrawingResult(strokeLength:890, drawingTimeMs:4100,fluency:74,score:6), likeCount:287, commentCount:8,  pathIndex:1, comments:[
    CommentModel(id:'c3',userId:'u1',username:'deniz.c',    text:'Güzel daire!',          createdAt:DateTime(2024,1,3)),
  ]),
  _AkisEntry(id:'3', username:'koray.sk',  result:const DrawingResult(strokeLength:560, drawingTimeMs:2800,fluency:91,score:9), likeCount:195, commentCount:5,  pathIndex:2, comments:[]),
  _AkisEntry(id:'4', username:'selin.cz',  result:const DrawingResult(strokeLength:1580,drawingTimeMs:5200,fluency:66,score:7), likeCount:512, commentCount:23, pathIndex:3, comments:[
    CommentModel(id:'c4',userId:'u5',username:'baris.dr',   text:'Renk seçimi mükemmel.',createdAt:DateTime(2024,1,4)),
    CommentModel(id:'c5',userId:'u6',username:'arda.m',     text:'Takip ettim!',          createdAt:DateTime(2024,1,5)),
  ]),
  _AkisEntry(id:'5', username:'baris.dr',  result:const DrawingResult(strokeLength:320, drawingTimeMs:1900,fluency:88,score:8), likeCount:88,  commentCount:3,  pathIndex:4, comments:[]),
  _AkisEntry(id:'6', username:'arda.m',    result:const DrawingResult(strokeLength:1100,drawingTimeMs:3900,fluency:77,score:7), likeCount:403, commentCount:17, pathIndex:5, comments:[
    CommentModel(id:'c6',userId:'u7',username:'zeynep.y',   text:'Bir his ifade ediyor.', createdAt:DateTime(2024,1,6)),
  ]),
  _AkisEntry(id:'7', username:'zeynep.y',  result:const DrawingResult(strokeLength:740, drawingTimeMs:3300,fluency:80,score:7), likeCount:156, commentCount:7,  pathIndex:6, comments:[]),
  _AkisEntry(id:'8', username:'emre.n',    result:const DrawingResult(strokeLength:980, drawingTimeMs:4400,fluency:71,score:6), likeCount:229, commentCount:11, pathIndex:7, comments:[
    CommentModel(id:'c7',userId:'u1',username:'deniz.c',    text:'Geometrik ve saf.',     createdAt:DateTime(2024,1,7)),
  ]),
];

// ── Page ──────────────────────────────────────────────────────────────────────

class AkisPage extends StatefulWidget {
  const AkisPage({super.key});

  @override
  State<AkisPage> createState() => _AkisPageState();
}

class _AkisPageState extends State<AkisPage> {
  late final List<_AkisEntry> _entries;

  @override
  void initState() {
    super.initState();
    _entries = _buildDummyFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Row(
                children: [
                  const Text(
                    'SOSYAL AKIŞ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFF181818),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF282828)),
                    ),
                    child: const Icon(Icons.tune_rounded,
                        size: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            // Feed
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
                itemCount: _entries.length,
                separatorBuilder: (context, i) => const SizedBox(height: 20),
                itemBuilder: (context, i) => _FeedCard(
                  entry: _entries[i],
                  onLikeToggled: () => setState(() {}),
                  onCommentTap: () => _showComments(context, _entries[i]),
                  onUserTap: () => _openProfile(context, _entries[i].username),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComments(BuildContext ctx, _AkisEntry entry) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) => _CommentSheet(entry: entry),
    );
  }

  void _openProfile(BuildContext ctx, String username) {
    Navigator.of(ctx).push(PageRouteBuilder(
      pageBuilder: (context, anim, secondary) =>
          UserProfilePage(username: username),
      transitionsBuilder: (context, anim, secondary, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
        child: child,
      ),
    ));
  }
}

// ── Feed card ─────────────────────────────────────────────────────────────────

class _FeedCard extends StatefulWidget {
  const _FeedCard({
    required this.entry,
    required this.onLikeToggled,
    required this.onCommentTap,
    required this.onUserTap,
  });

  final _AkisEntry  entry;
  final VoidCallback onLikeToggled;
  final VoidCallback onCommentTap;
  final VoidCallback onUserTap;

  @override
  State<_FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<_FeedCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _likeCtrl;
  late final Animation<double>   _likeScale;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    _likeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _likeScale = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.4)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween(begin: 1.4, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50),
    ]).animate(_likeCtrl);
  }

  @override
  void dispose() {
    _likeCtrl.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      widget.entry.likeCount += _liked ? 1 : -1;
    });
    _likeCtrl.forward(from: 0);
    widget.onLikeToggled();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF222222)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── User row ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: GestureDetector(
              onTap: widget.onUserTap,
              child: Row(
                children: [
                  _Avatar(username: e.username),
                  const SizedBox(width: 10),
                  Text(
                    '@${e.username}',
                    style: const TextStyle(
                      color: Color(0xFFD0D0D0),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.more_horiz,
                      color: Color(0xFF555555), size: 18),
                ],
              ),
            ),
          ),

          // ── Drawing preview ───────────────────────────────────────────────
          Container(
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.background,
            ),
            child: CustomPaint(
              painter: _StrokePainter(
                path: _dummyPaths[e.pathIndex % _dummyPaths.length],
                color: Colors.white,
              ),
            ),
          ),

          // ── Analysis badges ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _AnalysisBadge('${e.result.score} puan', AppColors.accent),
                  const SizedBox(width: 6),
                  _AnalysisBadge(
                      '${e.result.strokeLength.toStringAsFixed(0)} px',
                      AppColors.teal),
                  const SizedBox(width: 6),
                  _AnalysisBadge('${e.result.drawingTimeMs} ms', AppColors.coral),
                ],
              ),
            ),
          ),

          // ── Action row ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
            child: Row(
              children: [
                // Like
                GestureDetector(
                  onTap: _toggleLike,
                  child: Row(
                    children: [
                      ScaleTransition(
                        scale: _likeScale,
                        child: Icon(
                          _liked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: _liked
                              ? const Color(0xFFE88E8E)
                              : Colors.white60,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${e.likeCount}',
                        style: TextStyle(
                          color: _liked
                              ? const Color(0xFFE88E8E)
                              : Colors.white60,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                // Comment
                GestureDetector(
                  onTap: widget.onCommentTap,
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline_rounded,
                          color: Colors.white60, size: 18),
                      const SizedBox(width: 5),
                      Text(
                        '${e.commentCount}',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Comment bottom sheet ──────────────────────────────────────────────────────

class _CommentSheet extends StatefulWidget {
  const _CommentSheet({required this.entry});
  final _AkisEntry entry;

  @override
  State<_CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<_CommentSheet> {
  final TextEditingController _ctrl = TextEditingController();
  final List<CommentModel>    _comments = [];

  @override
  void initState() {
    super.initState();
    _comments.addAll(widget.entry.comments);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.add(CommentModel(
        id:        DateTime.now().millisecondsSinceEpoch.toString(),
        userId:    'me',
        username:  'sen',
        text:      text,
        createdAt: DateTime.now(),
      ));
    });
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(2),
                )),
            const SizedBox(height: 14),
            const Text('Yorumlar',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Flexible(
              child: _comments.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Henüz yorum yok.',
                          style: TextStyle(color: Color(0xFF666666))),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      itemCount: _comments.length,
                      itemBuilder: (_, i) {
                        final c = _comments[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _Avatar(username: c.username, size: 30),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('@${c.username}',
                                        style: const TextStyle(
                                            color: Color(0xFF9A9A9A),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 2),
                                    Text(c.text,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const Divider(color: Color(0xFF222222), height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Yorum yaz...',
                        hintStyle:
                            const TextStyle(color: Color(0xFF555555)),
                        filled: true,
                        fillColor: const Color(0xFF1A1A1A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  const _Avatar({required this.username, this.size = 36});
  final String username;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initials = username.isNotEmpty
        ? username[0].toUpperCase()
        : '?';
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.22),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(initials,
            style: TextStyle(
                color: AppColors.accent,
                fontSize: size * 0.42,
                fontWeight: FontWeight.w800)),
      ),
    );
  }
}

class _AnalysisBadge extends StatelessWidget {
  const _AnalysisBadge(this.label, this.color);
  final String label;
  final Color  color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }
}

// ── Custom painter for dummy paths ────────────────────────────────────────────

class _StrokePainter extends CustomPainter {
  const _StrokePainter({required this.path, required this.color});
  final List<Offset> path;
  final Color        color;

  @override
  void paint(Canvas canvas, Size size) {
    if (path.length < 2) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final p = Path();
    // Scale relative (0–1) coords to canvas size
    final scaled = path
        .map((o) => Offset(o.dx * size.width, o.dy * size.height))
        .toList();

    p.moveTo(scaled[0].dx, scaled[0].dy);
    for (var i = 1; i < scaled.length - 1; i++) {
      final mid = Offset(
        (scaled[i].dx + scaled[i + 1].dx) / 2,
        (scaled[i].dy + scaled[i + 1].dy) / 2,
      );
      p.quadraticBezierTo(scaled[i].dx, scaled[i].dy, mid.dx, mid.dy);
    }
    p.lineTo(scaled.last.dx, scaled.last.dy);
    canvas.drawPath(p, paint);
  }

  @override
  bool shouldRepaint(covariant _StrokePainter old) =>
      old.path != path || old.color != color;
}
