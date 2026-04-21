
import 'package:flutter/material.dart';
import 'package:tek_dokunus/main.dart';
import 'package:tek_dokunus/user_drawing_store.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key, this.initialTab = 0});

  final int initialTab;

  static const Color bg = Color(0xFF050505);
  static const Color surface = Color(0xFF111111);
  static const Color surfaceSoft = Color(0xFF1B1B1B);
  static const Color surfaceCard = Color(0xFF2A2A2A);
  static const Color soft = Color(0xFF9C9C9C);
  static const Color text = Color(0xFFF2F2F2);
  static const Color line = Color(0xFF303030);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
  }

  static const List<_InsightItem> _insights = [
    _InsightItem(label: 'Bugun', value: '18 cizim'),
    _InsightItem(label: 'En iyi skor', value: '96/100'),
    _InsightItem(label: 'Ortalama sure', value: '1.3 sn'),
  ];

  static const List<_ChallengeCardData> _cards = [
    _ChallengeCardData(
      category: 'Editor secimi',
      title: 'Tek hamlede dengeli hareket',
      description: 'Kavis, hiz ve bitis dogrulugunu ayni akista test eden gunun ana calismasi.',
      metric: 'Zorluk orta',
      duration: '45 sn',
      color: Color(0xFF303030),
    ),
    _ChallengeCardData(
      category: 'Canli analiz',
      title: 'Skorunu tekrar oynatmayla incele',
      description: 'Cizimi bitirdigin an hizini, akiciligi ve cizgi uzunlugunu tek ekranda gor.',
      metric: 'Analiz hazir',
      duration: 'Aninda',
      color: Color(0xFF262626),
    ),
    _ChallengeCardData(
      category: 'Gunluk seri',
      title: 'Ritmini bozmadan 3 gorev tamamla',
      description: 'Ardisik gorevlerle refleksini sabit tut, daha temiz bitisler uret.',
      metric: '3 adim',
      duration: '2 dk',
      color: Color(0xFF383838),
    ),
  ];

  static const List<_FeedPostData> _posts = [
    _FeedPostData(
      author: 'deniz.ciziyor',
      timeLabel: '4 dk once',
      title: 'Tek hamlede lotus cizimi',
      caption: 'Tek cizgide tamamladim. Akicilik puani bekledigimden iyi geldi.',
      likes: '1.284',
      comments: '126',
      saves: '84',
      color: Color(0xFF2C2C2C),
    ),
    _FeedPostData(
      author: 'iz.akisi',
      timeLabel: '11 dk once',
      title: 'Dairesel refleks denemesi',
      caption: 'Hizi dusurup bitis hassasiyetine odaklandim. Cok daha temiz oldu.',
      likes: '982',
      comments: '74',
      saves: '51',
      color: Color(0xFF242424),
    ),
    _FeedPostData(
      author: 'studio.tekdokunus',
      timeLabel: '26 dk once',
      title: 'Gunluk meydan okuma',
      caption: 'Bugunun gorevi: cizgiyi bozmadan tek nefeste finale ulas.',
      likes: '2.104',
      comments: '201',
      saves: '140',
      color: Color(0xFF343434),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WelcomePage.bg,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeTab(context),
            _buildFeedTab(),
            _buildMyDrawingsTab(),
            _buildProfileTab(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 84,
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
        decoration: const BoxDecoration(
          color: WelcomePage.surface,
          border: Border(top: BorderSide(color: WelcomePage.line)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.dashboard_rounded,
              active: _selectedIndex == 0,
              onTap: () => setState(() => _selectedIndex = 0),
            ),
            _NavItem(
              icon: Icons.dynamic_feed_rounded,
              active: _selectedIndex == 1,
              onTap: () => setState(() => _selectedIndex = 1),
            ),
            _NavItem(
              icon: Icons.gesture_rounded,
              active: _selectedIndex == 2,
              onTap: () => setState(() => _selectedIndex = 2),
            ),
            _NavItem(
              icon: Icons.person_outline_rounded,
              active: _selectedIndex == 3,
              onTap: () => setState(() => _selectedIndex = 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Header(),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: WelcomePage.surface,
                    border: Border.all(color: WelcomePage.line),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66000000),
                        blurRadius: 20,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bugunun odagi',
                        style: TextStyle(color: WelcomePage.soft, fontSize: 13),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Ciz, olc, tekrar oynat.',
                        style: TextStyle(
                          color: WelcomePage.text,
                          fontSize: 30,
                          height: 1.05,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Acilis ekrani sade siyah ve gri yuzeylerle yeniden duzenlendi.',
                        style: TextStyle(color: Color(0xFFC7C7C7), height: 1.45),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DrawingPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD9D9D9),
                                foregroundColor: Colors.black,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              icon: const Icon(Icons.play_arrow_rounded),
                              label: const Text(
                                'Cizime Basla',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: WelcomePage.surfaceSoft,
                              border: Border.all(color: WelcomePage.line),
                            ),
                            child: const Icon(Icons.tune_rounded, color: WelcomePage.text),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Anlik ozet',
                  style: TextStyle(
                    color: WelcomePage.text,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: _insights
                      .map(
                        (item) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: item == _insights.last ? 0 : 10),
                            child: _InsightCard(item: item),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 28),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'One cikan akislar',
                      style: TextStyle(
                        color: WelcomePage.text,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Tumunu gor',
                      style: TextStyle(
                        color: WelcomePage.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList.builder(
            itemCount: _cards.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _ChallengeCard(
                  data: _cards[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DrawingPage(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildFeedTab() {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(),
                SizedBox(height: 24),
                Text(
                  'Akis',
                  style: TextStyle(
                    color: WelcomePage.text,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Toplulugun son cizimlerini kaydir, begen, yorumla ve kaydet.',
                  style: TextStyle(color: WelcomePage.soft, height: 1.4),
                ),
                SizedBox(height: 18),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList.builder(
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: _FeedPost(post: _posts[index]),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildMyDrawingsTab() {
    return ValueListenableBuilder<List<UserDrawing>>(
      valueListenable: UserDrawingStore.drawings,
      builder: (context, drawings, child) {
        if (drawings.isEmpty) {
          return _buildPlaceholderTab('Henuz bir cizimin yok. Bir cizim tamamlayinca burada goreceksin.');
        }

        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(),
                    SizedBox(height: 24),
                    Text(
                      'Cizimlerim',
                      style: TextStyle(
                        color: WelcomePage.text,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tamamladigin cizimler burada saklanir.',
                      style: TextStyle(color: WelcomePage.soft, height: 1.4),
                    ),
                    SizedBox(height: 18),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList.builder(
                itemCount: drawings.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: _MyDrawingCard(drawing: drawings[index]),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
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
        final totalLikes = drawings.fold<int>(0, (sum, drawing) {
          return sum + (drawing.score * 1.8).round() + 12;
        });
        final totalXp = drawings.fold<int>(0, (sum, drawing) {
          return sum + drawing.score.round() * 8 + 40;
        });
        final level = totalXp == 0 ? 1 : (totalXp ~/ 250) + 1;
        final currentLevelXp = totalXp % 250;
        final progress = totalXp == 0 ? 0.0 : currentLevelXp / 250;
        final followers = 128 + totalLikes;
        final following = 42 + (totalDrawings * 3);

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Header(),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: WelcomePage.surface,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: WelcomePage.line),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: WelcomePage.surfaceCard,
                                  border: Border.all(color: WelcomePage.line, width: 2),
                                ),
                                child: const Icon(Icons.person_rounded, color: WelcomePage.text, size: 40),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'tekdokunus.user',
                                      style: TextStyle(
                                        color: WelcomePage.text,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'Tek cizgide ritim, hassasiyet ve hiz calisan profil.',
                                      style: TextStyle(color: WelcomePage.soft, height: 1.4),
                                    ),
                                    const SizedBox(height: 10),
                                    _Badge(label: 'Level '),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(child: _StatCard(label: 'Takipci', value: '$followers')),
                              const SizedBox(width: 10),
                              Expanded(child: _StatCard(label: 'Takip', value: '$following')),
                              const SizedBox(width: 10),
                              Expanded(child: _StatCard(label: 'Cizim', value: '$totalDrawings')),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: _StatCard(label: 'Toplam begeni', value: '$totalLikes')),
                              const SizedBox(width: 10),
                              Expanded(child: _StatCard(label: 'Toplam XP', value: '$totalXp')),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: WelcomePage.surfaceSoft,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: WelcomePage.line),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Level $level ilerleme',
                                      style: const TextStyle(color: WelcomePage.text, fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      '$currentLevelXp / 250 XP',
                                      style: const TextStyle(color: WelcomePage.soft),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 10,
                                    backgroundColor: WelcomePage.surfaceCard,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD9D9D9)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Profil ozetin',
                      style: TextStyle(color: WelcomePage.text, fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Level ve toplam begeni degerleri kendi cizim performansina ve gorev skorlarina gore otomatik hesaplanir.',
                      style: TextStyle(color: WelcomePage.soft, height: 1.45),
                    ),
                  ],
                ),
              ),
            ),
            if (drawings.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _ProfileDrawingTile(drawing: drawings[index]),
                    childCount: drawings.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                ),
              )
            else
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      },
    );
  }
  Widget _buildPlaceholderTab(String text) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: WelcomePage.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: WelcomePage.line),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: WelcomePage.text, fontSize: 16),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: WelcomePage.surfaceSoft,
            border: Border.all(color: WelcomePage.line),
          ),
          child: const Icon(Icons.gesture_rounded, color: WelcomePage.text),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TekDokunus',
                style: TextStyle(
                  color: WelcomePage.text,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Hareket odakli cizim akisi',
                style: TextStyle(color: WelcomePage.soft, fontSize: 13),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: WelcomePage.surface,
            border: Border.all(color: WelcomePage.line),
          ),
          child: const Text(
            'PRO',
            style: TextStyle(
              color: WelcomePage.text,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.item});

  final _InsightItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WelcomePage.surfaceSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WelcomePage.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.label, style: const TextStyle(color: WelcomePage.soft, fontSize: 12)),
          const SizedBox(height: 8),
          Text(
            item.value,
            style: const TextStyle(
              color: WelcomePage.text,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({required this.data, required this.onTap});

  final _ChallengeCardData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: data.color,
        border: Border.all(color: WelcomePage.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: Colors.black26,
                      ),
                      child: Text(
                        data.category,
                        style: const TextStyle(
                          color: WelcomePage.text,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.north_east_rounded, color: Colors.white70),
                  ],
                ),
                const SizedBox(height: 48),
                Text(
                  data.title,
                  style: const TextStyle(
                    color: WelcomePage.text,
                    fontSize: 28,
                    height: 1.05,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  data.description,
                  style: const TextStyle(color: Color(0xFFD0D0D0), height: 1.45),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _MetaChip(icon: Icons.timeline_rounded, label: data.metric),
                    const SizedBox(width: 10),
                    _MetaChip(icon: Icons.schedule_rounded, label: data.duration),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedPost extends StatelessWidget {
  const _FeedPost({required this.post});

  final _FeedPostData post;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: WelcomePage.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: WelcomePage.line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: WelcomePage.surfaceCard,
                  child: const Icon(Icons.gesture_rounded, color: WelcomePage.text, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author,
                        style: const TextStyle(
                          color: WelcomePage.text,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        post.timeLabel,
                        style: const TextStyle(color: WelcomePage.soft, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz_rounded, color: Colors.white70),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 260,
              decoration: BoxDecoration(
                color: post.color,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    top: 16,
                    right: 16,
                    child: Icon(Icons.open_in_full_rounded, color: Colors.white54),
                  ),
                  Positioned(
                    left: 22,
                    right: 22,
                    bottom: 22,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: const TextStyle(
                            color: WelcomePage.text,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          post.caption,
                          style: const TextStyle(color: Color(0xFFD0D0D0), height: 1.45),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _ActionStat(icon: Icons.favorite_border_rounded, value: post.likes),
                const SizedBox(width: 12),
                _ActionStat(icon: Icons.mode_comment_outlined, value: post.comments),
                const SizedBox(width: 12),
                _ActionStat(icon: Icons.bookmark_border_rounded, value: post.saves),
                const Spacer(),
                const Icon(Icons.send_outlined, color: Colors.white70),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MyDrawingCard extends StatelessWidget {
  const _MyDrawingCard({required this.drawing});

  final UserDrawing drawing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: WelcomePage.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: WelcomePage.line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: WelcomePage.surfaceCard,
                  child: const Icon(Icons.brush_rounded, color: WelcomePage.text, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Kendi cizimin',
                    style: const TextStyle(
                      color: WelcomePage.text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  _formatTime(drawing.createdAt),
                  style: const TextStyle(color: WelcomePage.soft, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: 260,
                color: const Color(0xFF202020),
                width: double.infinity,
                child: Image.file(
                  drawing.imageFile,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text(
                        'Onizleme yuklenemedi',
                        style: TextStyle(color: WelcomePage.soft),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _ActionStat(
                  icon: Icons.timer_outlined,
                  value: '${drawing.drawingTime} ms',
                ),
                _ActionStat(
                  icon: Icons.straighten_rounded,
                  value: '${drawing.strokeLength.toStringAsFixed(0)} px',
                ),
                _ActionStat(
                  icon: Icons.star_border_rounded,
                  value: '${drawing.score.toStringAsFixed(0)} / 100',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}


class _ProfileDrawingTile extends StatelessWidget {
  const _ProfileDrawingTile({required this.drawing});

  final UserDrawing drawing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: WelcomePage.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: WelcomePage.line),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              drawing.imageFile,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: WelcomePage.surfaceCard);
              },
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xCC000000)],
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Text(
                'Skor ${drawing.score.toStringAsFixed(0)}',
                style: const TextStyle(color: WelcomePage.text, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: WelcomePage.surfaceSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: WelcomePage.line),
      ),
      child: Text(
        label,
        style: const TextStyle(color: WelcomePage.text, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WelcomePage.surfaceSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WelcomePage.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: WelcomePage.soft, fontSize: 12)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: WelcomePage.text,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
class _ActionStat extends StatelessWidget {
  const _ActionStat({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: WelcomePage.surfaceSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: WelcomePage.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: WelcomePage.text),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(color: WelcomePage.text, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0x22000000),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: WelcomePage.text),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: WelcomePage.text, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
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
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: active ? WelcomePage.surfaceCard : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: active ? WelcomePage.text : Colors.white54,
        ),
      ),
    );
  }
}

class _InsightItem {
  const _InsightItem({required this.label, required this.value});

  final String label;
  final String value;
}

class _ChallengeCardData {
  const _ChallengeCardData({
    required this.category,
    required this.title,
    required this.description,
    required this.metric,
    required this.duration,
    required this.color,
  });

  final String category;
  final String title;
  final String description;
  final String metric;
  final String duration;
  final Color color;
}

class _FeedPostData {
  const _FeedPostData({
    required this.author,
    required this.timeLabel,
    required this.title,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.saves,
    required this.color,
  });

  final String author;
  final String timeLabel;
  final String title;
  final String caption;
  final String likes;
  final String comments;
  final String saves;
  final Color color;
}




