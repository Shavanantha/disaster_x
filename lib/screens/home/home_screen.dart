import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/bencana_model.dart';
import '../../models/user_profile_model.dart';
import '../../services/dummy_data.dart';
import '../../services/storage_service.dart';
import '../../widgets/icon_helper.dart';
import '../profil/nomor_darurat_screen.dart';
import '../profil/riwayat_nilai_screen.dart';
import '../profil/tas_siaga_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onTabChange;

  const HomeScreen({
    super.key,
    this.onTabChange,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  UserProfile _profile = const UserProfile(
    nama: 'Shava Phiyan Anantha',
    nim: '2413025047',
    sekolah: 'Universitas Lampung',
    kelas: 'Mobile Programming A',
  );

  double _progress = 0.85;

  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _progressAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _animationController.forward();

    _loadHomeData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadHomeData() async {
    final prof = await StorageService.getUserProfile();
    final prog = await StorageService.getOverallProgress();

    if (mounted) {
      setState(() {
        _profile = prof;
        _progress = prog > 0 ? prog : 0.4;
      });
    }
  }

  String get _firstName {
    final name = _profile.nama.trim();

    if (name.isEmpty) {
      return 'Teman';
    }

    return name.split(' ').first;
  }

  String get _levelName {
    final percent = (_progress * 100).round();

    if (percent >= 80) {
      return 'Siaga Utama';
    } else if (percent >= 50) {
      return 'Siaga Madya';
    }

    return 'Siaga Pratama';
  }

  // =========================================================
  // NAVIGATION
  // =========================================================

  void _goToTab(int index) {
    HapticFeedback.lightImpact();
    widget.onTabChange?.call(index);
  }

  void _openEmergency() {
    HapticFeedback.mediumImpact();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NomorDaruratScreen(),
      ),
    );
  }

  void _openTasSiaga() {
    HapticFeedback.lightImpact();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TasSiagaScreen(),
      ),
    );
  }

  void _openHistory() {
    HapticFeedback.lightImpact();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RiwayatNilaiScreen(),
      ),
    );
  }

  // =========================================================
  // NEWS DETAIL
  // =========================================================

  void _showNewsDetail(BeritaTips tips) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.68,
          minChildSize: 0.5,
          maxChildSize: 0.94,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9DDE5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE9E6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          tips.kategori.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFFE64A3B),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Color(0xFF9AA1AE),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        tips.tanggal,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9AA1AE),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1EF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          getDisasterIcon(tips.ikon),
                          color: const Color(0xFFE64A3B),
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Text(
                          tips.judul,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                            color: Color(0xFF202A3A),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  const Divider(
                    color: Color(0xFFECEEF2),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    tips.konten,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.7,
                      color: Color(0xFF515B6B),
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF243B64),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Tutup Artikel',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final progressPercent = (_progress * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FB),

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // =================================================
            // HEADER
            // =================================================

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF6B5E),
                                  Color(0xFFE5483C),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE5483C)
                                      .withValues(alpha: 0.18),
                                  blurRadius: 12,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Halo, $_firstName! 👋',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF202A3A),
                                  ),
                                ),

                                const SizedBox(height: 3),

                                Row(
                                  children: [
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF22C55E),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '$_levelName • Tetap siap!',
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        color: Color(0xFF7B8493),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    // SOS
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: _openEmergency,
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEFED),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color(0xFFFFD6D1),
                            ),
                          ),
                          child: const Icon(
                            Icons.emergency_rounded,
                            color: Color(0xFFE5483C),
                            size: 23,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =================================================
            // HERO CARD
            // =================================================

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                child: _buildHeroCard(progressPercent),
              ),
            ),

            // =================================================
            // QUICK ACTION
            // =================================================

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: _buildSectionTitle(
                  title: 'Aksi Cepat',
                  subtitle: 'Hal penting yang bisa kamu akses',
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildActionCard(
                        icon: Icons.phone_in_talk_rounded,
                        title: 'Nomor Darurat',
                        subtitle: 'SOS & bantuan',
                        color: const Color(0xFFE5483C),
                        background: const Color(0xFFFFEFED),
                        onTap: _openEmergency,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _buildActionCard(
                        icon: Icons.backpack_rounded,
                        title: 'Tas Siaga',
                        subtitle: 'Cek perlengkapan',
                        color: const Color(0xFF3567C8),
                        background: const Color(0xFFEDF3FF),
                        onTap: _openTasSiaga,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =================================================
            // MAIN MENU
            // =================================================

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
                child: _buildSectionTitle(
                  title: 'Belajar & Berlatih',
                  subtitle: 'Tingkatkan kesiapsiagaanmu',
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  children: [
                    // SIMULASI - FEATURED
                    _buildSimulationCard(),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildMenuCard(
                            icon: Icons.menu_book_rounded,
                            title: 'Materi & Video',
                            subtitle: 'Pelajari dasar mitigasi',
                            color: const Color(0xFFF28C28),
                            background: const Color(0xFFFFF4E7),
                            onTap: () => _goToTab(1),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _buildMenuCard(
                            icon: Icons.assignment_rounded,
                            title: 'Kuis Evaluasi',
                            subtitle: 'Uji pemahamanmu',
                            color: const Color(0xFF4778D4),
                            background: const Color(0xFFEDF3FF),
                            onTap: () => _goToTab(3),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    _buildHistoryCard(),
                  ],
                ),
              ),
            ),

            // =================================================
            // NEWS
            // =================================================

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: _buildSectionTitle(
                  title: 'Berita & Tips',
                  subtitle: 'Info singkat untuk tetap siap',
                  trailing: 'Terbaru',
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Column(
                  children: DummyData.daftarBerita.take(3).map((tips) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildTipsCard(
                        title: tips.judul,
                        desc: tips.ringkasan,
                        kategori: tips.kategori,
                        icon: getDisasterIcon(tips.ikon),
                        onTap: () => _showNewsDetail(tips),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // HERO CARD
  // =========================================================

  Widget _buildHeroCard(int progressPercent) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF243B64),
            Color(0xFF315681),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF243B64).withValues(alpha: 0.24),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -25,
            top: -35,
            child: Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            right: 20,
            bottom: -50,
            child: Icon(
              Icons.shield_rounded,
              size: 150,
              color: Colors.white.withValues(alpha: 0.055),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.shield_rounded,
                            size: 14,
                            color: Color(0xFFFFD166),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _levelName.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    Text(
                      '$progressPercent%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                const Text(
                  'Tingkat Kesiapsiagaan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Terus berlatih agar semakin siap menghadapi situasi darurat.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11.5,
                    height: 1.4,
                  ),
                ),

                const Spacer(),

                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _progress * _progressAnimation.value,
                        minHeight: 9,
                        backgroundColor: Colors.white.withValues(
                          alpha: 0.15,
                        ),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(
                          Color(0xFFFFC857),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Icon(
                      _progress >= 0.8
                          ? Icons.check_circle_rounded
                          : Icons.trending_up_rounded,
                      size: 15,
                      color: const Color(0xFFFFD166),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _progress >= 0.8
                          ? 'Kamu sudah cukup siap! Pertahankan 💪'
                          : 'Ayo tingkatkan lagi kesiapsiagaanmu!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SECTION TITLE
  // =========================================================

  Widget _buildSectionTitle({
    required String title,
    required String subtitle,
    String? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF202A3A),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF8992A2),
                ),
              ),
            ],
          ),
        ),

        if (trailing != null)
          Text(
            trailing,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9AA1AE),
            ),
          ),
      ],
    );
  }

  // =========================================================
  // QUICK ACTION CARD
  // =========================================================

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color background,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE9ECF2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF27354D),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 9.5,
                        color: Color(0xFF9299A6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SIMULATION FEATURED CARD
  // =========================================================

  Widget _buildSimulationCard() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _goToTab(2),
        borderRadius: BorderRadius.circular(21),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFE94B3F),
                Color(0xFFF06A50),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(21),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE94B3F).withValues(alpha: 0.20),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -12,
                bottom: -25,
                child: Icon(
                  Icons.play_circle_filled_rounded,
                  size: 115,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),

              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Simulasi Bencana',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Latih pengambilan keputusan dalam situasi darurat.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10.5,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // NORMAL MENU CARD
  // =========================================================

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color background,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE8EBF0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 23,
                ),
              ),

              const SizedBox(height: 13),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF27354D),
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9.5,
                  color: Color(0xFF9299A6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // HISTORY CARD
  // =========================================================

  Widget _buildHistoryCard() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _openHistory,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE8EBF0),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFECF8F1),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: Color(0xFF249653),
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Riwayat Nilai',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF27354D),
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Lihat hasil kuis dan perkembanganmu',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9299A6),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: Color(0xFF9AA1AE),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // NEWS CARD
  // =========================================================

  Widget _buildTipsCard({
    required String title,
    required String desc,
    required String kategori,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Ink(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: const Color(0xFFE8EBF0),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 49,
                height: 49,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0EE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFE5483C),
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kategori.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFE5483C),
                        letterSpacing: 0.6,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF27354D),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      desc,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9299A6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Color(0xFFB0B6C1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}