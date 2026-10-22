import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/kuis_model.dart';
import '../../services/dummy_data.dart';
import '../../services/storage_service.dart';
import 'kuis_play_screen.dart';

class KuisScreen extends StatefulWidget {
  const KuisScreen({super.key});

  @override
  State<KuisScreen> createState() => _KuisScreenState();
}

class _KuisScreenState extends State<KuisScreen> {
  double _rataRata = 85.0;
  Map<String, dynamic> _scores = {};

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final rataRata = await StorageService.getRataRataNilai();
    final scores = await StorageService.getQuizScores();

    if (!mounted) return;

    setState(() {
      _rataRata = rataRata;
      _scores = scores;
    });
  }

  String get _predikat {
    if (_rataRata >= 90) {
      return 'Sangat Siap';
    } else if (_rataRata >= 80) {
      return 'Tanggap Bencana Madya';
    } else {
      return 'Tanggap Bencana Pratama';
    }
  }

  Color get _scoreColor {
    if (_rataRata >= 80) {
      return const Color(0xFF16A085);
    } else if (_rataRata >= 60) {
      return const Color(0xFFF39C12);
    }
    return const Color(0xFFE74C3C);
  }

  IconData _categoryIcon(String kategori) {
    final value = kategori.toLowerCase();

    if (value.contains('gempa')) {
      return Icons.public_rounded;
    }

    if (value.contains('kebakaran')) {
      return Icons.local_fire_department_rounded;
    }

    if (value.contains('banjir')) {
      return Icons.water_rounded;
    }

    return Icons.warning_amber_rounded;
  }

  Color _categoryColor(String kategori) {
    final value = kategori.toLowerCase();

    if (value.contains('gempa')) {
      return const Color(0xFF536DFE);
    }

    if (value.contains('kebakaran')) {
      return const Color(0xFFE85D3F);
    }

    if (value.contains('banjir')) {
      return const Color(0xFF1597D4);
    }

    return const Color(0xFF64748B);
  }

  Future<void> _mulaiKuis(PaketKuis kuis) async {
    HapticFeedback.mediumImpact();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KuisPlayScreen(
          paketKuis: kuis,
        ),
      ),
    );

    await _loadScores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadScores,
          color: const Color(0xFF173B6C),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),

              SliverToBoxAdapter(
                child: _buildScoreHero(),
              ),

              SliverToBoxAdapter(
                child: _buildSectionTitle(),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final kuis = DummyData.daftarKuis[index];

                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                        right: 18,
                        bottom: 14,
                      ),
                      child: _buildKuisCard(kuis),
                    );
                  },
                  childCount: DummyData.daftarKuis.length,
                ),
              ),

              SliverToBoxAdapter(
                child: _buildTipsCard(),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kuis & Evaluasi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey.shade500,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Uji Kesiapanmu! 🎯',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14213D),
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Tantang dirimu dan ukur seberapa siap kamu menghadapi bencana.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blueGrey.shade600,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.quiz_rounded,
              color: Color(0xFF315B9A),
              size: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreHero() {
    final progress = (_rataRata / 100).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF173B6C),
              Color(0xFF285B93),
            ],
          ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF173B6C).withValues(alpha: 0.18),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 94,
              height: 94,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 88,
                    height: 88,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: progress),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return CircularProgressIndicator(
                          value: value,
                          strokeWidth: 8,
                          backgroundColor: Colors.white.withValues(alpha: 0.15),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _scoreColor,
                          ),
                        );
                      },
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _rataRata.toStringAsFixed(0),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '/ 100',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Safety Readiness Score',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _predikat,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Terus latihan agar semakin siap menghadapi situasi darurat.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 11.5,
                      height: 1.4,
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

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Pilih Tantangan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14213D),
              ),
            ),
          ),
          Text(
            '${DummyData.daftarKuis.length} kuis',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKuisCard(PaketKuis kuis) {
    final score = _scores[kuis.id];
    final hasAttempted = score != null;

    final icon = _categoryIcon(kuis.kategori);
    final color = _categoryColor(kuis.kategori);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: () => _mulaiKuis(kuis),
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFE8ECF3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.11),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 27,
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.09),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            kuis.kategori,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          kuis.judul,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF172033),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (hasAttempted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F8F3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 13,
                            color: Color(0xFF16A085),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            score.toString(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF138A72),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  _buildInfoChip(
                    Icons.help_outline_rounded,
                    '${kuis.jumlahSoal} Soal',
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    Icons.timer_outlined,
                    '${kuis.batasWaktuMenit} Menit',
                  ),

                  const Spacer(),

                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () => _mulaiKuis(kuis),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            hasAttempted ? 'Ulangi' : 'Mulai',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.blueGrey.shade500,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8ED),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFF7E7C5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE9BD),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.lightbulb_rounded,
                color: Color(0xFFD99000),
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tips sebelum mulai',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF6F4C00),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Baca setiap pertanyaan dengan teliti, '
                    'pilih tindakan yang paling aman, dan jangan terburu-buru.',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.brown.shade500,
                      height: 1.45,
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