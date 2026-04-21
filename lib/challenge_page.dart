import 'package:flutter/material.dart';
import 'package:tek_dokunus/drawing_page.dart';

// ── Entry banner (shown in feed tab) ─────────────────────────────────────────

class WeeklyChallengeBanner extends StatelessWidget {
  const WeeklyChallengeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, anim, secondary) => const ChallengePage(),
          transitionsBuilder: (context, anim, secondary, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: child,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F1A),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.45),
          ),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0F1A), Color(0xFF13122A)],
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('🏆', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bu Haftanın Görevi',
                    style: TextStyle(
                      color: Color(0xFF6C63FF),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Bir his ifade et',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Katıl →',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Challenge page ─────────────────────────────────────────────────────────────

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _selectedChallenge = 0;

  static const List<_WeeklyChallenge> _challenges = [
    _WeeklyChallenge(
      title: 'Bir His İfade Et',
      subtitle: '"Yalnızlık" hissini tek bir darbe ile çiz.',
      daysLeft: 3,
    ),
    _WeeklyChallenge(
      title: 'Doğadan Bir Detay',
      subtitle: 'Doğadan ilham al, minimalist bir detayı yakala.',
      daysLeft: 5,
    ),
    _WeeklyChallenge(
      title: 'Şehir Silueti',
      subtitle: 'Şehrin ruhunu tek çizgiyle yansıt.',
      daysLeft: 7,
    ),
    _WeeklyChallenge(
      title: 'Hayvan Portresi',
      subtitle: 'Bir hayvanın özünü tek darbede yakala.',
      daysLeft: 6,
    ),
  ];

  static final List<_ChallengeEntry> _haftalikEntries = [
    _ChallengeEntry(username: 'deniz.c', likes: 341),
    _ChallengeEntry(username: 'meryem.art', likes: 287),
    _ChallengeEntry(username: 'koray.sk', likes: 195),
    _ChallengeEntry(username: 'selin.cz', likes: 512),
    _ChallengeEntry(username: 'baris.dr', likes: 88),
    _ChallengeEntry(username: 'arda.m', likes: 403),
    _ChallengeEntry(username: 'zeynep.y', likes: 156),
    _ChallengeEntry(username: 'emre.n', likes: 229),
    _ChallengeEntry(username: 'ece.ks', likes: 74),
  ];

  static final List<_ChallengeEntry> _gunlukEntries = [
    _ChallengeEntry(username: 'can.t', likes: 42),
    _ChallengeEntry(username: 'pelin.as', likes: 67),
    _ChallengeEntry(username: 'murat.dr', likes: 31),
    _ChallengeEntry(username: 'irem.b', likes: 89),
    _ChallengeEntry(username: 'oguz.k', likes: 15),
    _ChallengeEntry(username: 'naz.cz', likes: 54),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DrawingPage()),
        ),
        icon: const Text('🎨', style: TextStyle(fontSize: 18)),
        label: const Text(
          'Çizime Başla',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF181818),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF282828)),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 15,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'YARIŞMA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3.5,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 36),
                ],
              ),
            ),

            // Challenge selector
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: _challenges.length,
                separatorBuilder: (context, i) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final selected = _selectedChallenge == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedChallenge = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF6C63FF)
                            : const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF6C63FF)
                              : const Color(0xFF2A2A2A),
                        ),
                      ),
                      child: Text(
                        _challenges[i].title,
                        style: TextStyle(
                          color: selected ? Colors.white : const Color(0xFF888888),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Challenge description
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BU HAFTANIN GÖREVİ',
                    style: TextStyle(
                      color: Color(0xFF6C63FF),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _challenges[_selectedChallenge].title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _challenges[_selectedChallenge].subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      '⏳  ${_challenges[_selectedChallenge].daysLeft} gün kaldı',
                      style: const TextStyle(
                        color: Color(0xFF9D98FF),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFF6C63FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF6A6A6A),
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                tabs: const [
                  Tab(text: 'Haftalık'),
                  Tab(text: 'Günlük'),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Grid
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _EntryGrid(entries: _haftalikEntries),
                  _EntryGrid(entries: _gunlukEntries),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Entry grid ─────────────────────────────────────────────────────────────────

class _EntryGrid extends StatelessWidget {
  const _EntryGrid({required this.entries});

  final List<_ChallengeEntry> entries;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) => _EntryCard(entry: entries[index]),
    );
  }
}

// ── Entry card with like animation ────────────────────────────────────────────

class _EntryCard extends StatefulWidget {
  const _EntryCard({required this.entry});

  final _ChallengeEntry entry;

  @override
  State<_EntryCard> createState() => _EntryCardState();
}

class _EntryCardState extends State<_EntryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _likeAnim;
  late final Animation<double> _scale;
  late int _likes;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.entry.likes;
    _likeAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _scale = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.35)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween(begin: 1.35, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50),
    ]).animate(_likeAnim);
  }

  @override
  void dispose() {
    _likeAnim.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      _likes += _liked ? 1 : -1;
    });
    _likeAnim.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF222222)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder preview
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: Container(
                color: const Color(0xFF0D0D0D),
                child: Center(
                  child: Icon(
                    Icons.gesture_rounded,
                    size: 36,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '@${widget.entry.username}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: _toggleLike,
                  child: Row(
                    children: [
                      ScaleTransition(
                        scale: _scale,
                        child: Text(
                          _liked ? '❤️' : '🤍',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$_likes',
                        style: TextStyle(
                          color: _liked
                              ? const Color(0xFFE88E8E)
                              : Colors.white.withValues(alpha: 0.5),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
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

// ── Data models ───────────────────────────────────────────────────────────────

class _WeeklyChallenge {
  const _WeeklyChallenge({
    required this.title,
    required this.subtitle,
    required this.daysLeft,
  });

  final String title;
  final String subtitle;
  final int daysLeft;
}

class _ChallengeEntry {
  _ChallengeEntry({required this.username, required this.likes});

  final String username;
  final int likes;
}
