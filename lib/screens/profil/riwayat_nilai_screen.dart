import 'package:flutter/material.dart';
import '../../models/user_profile_model.dart';
import '../../services/storage_service.dart';

class RiwayatNilaiScreen extends StatefulWidget {
  const RiwayatNilaiScreen({super.key});

  @override
  State<RiwayatNilaiScreen> createState() => _RiwayatNilaiScreenState();
}

class _RiwayatNilaiScreenState extends State<RiwayatNilaiScreen> {
  List<RiwayatSkorItem> _history = [];
  bool _isLoading = true;

  static const Color _navy = Color(0xFF172B4D);
  static const Color _blue = Color(0xFF367BF5);
  static const Color _background = Color(0xFFF4F7FB);
  static const Color _textDark = Color(0xFF263449);
  static const Color _textMuted = Color(0xFF8290A3);

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final list = await StorageService.getScoreHistory();

      if (!mounted) return;

      setState(() {
        _history = list;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Riwayat nilai gagal dimuat. Coba lagi nanti.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  double get _averageScore {
    if (_history.isEmpty) return 0;

    final total = _history.fold<int>(
      0,
      (sum, item) => sum + item.skor,
    );

    return total / _history.length;
  }

  int get _goodScoreCount {
    return _history.where((item) => item.skor >= 70).length;
  }

  Color _scoreColor(int score) {
    if (score >= 85) return const Color(0xFF15966A);
    if (score >= 70) return const Color(0xFF367BF5);
    if (score >= 50) return const Color(0xFFE69A26);
    return const Color(0xFFE25555);
  }

  String _scoreLabel(int score) {
    if (score >= 85) return 'Sangat Baik';
    if (score >= 70) return 'Baik';
    if (score >= 50) return 'Cukup';
    return 'Perlu Belajar';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        foregroundColor: _navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Riwayat Nilai',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 19,
            color: _navy,
          ),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: _blue,
                strokeWidth: 3,
              ),
            )
          : RefreshIndicator(
              color: _blue,
              onRefresh: _loadHistory,
              child: _history.isEmpty
                  ? _buildEmptyState()
                  : _buildHistoryContent(),
            ),
    );
  }

  Widget _buildHistoryContent() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        _buildSummaryCard(),
        const SizedBox(height: 26),

        Row(
          children: [
            const Expanded(
              child: Text(
                'Aktivitas Evaluasi',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: _textDark,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5EAF2)),
              ),
              child: Text(
                '${_history.length} aktivitas',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _textMuted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Text(
          'Pantau hasil kuis dan simulasi yang telah kamu kerjakan.',
          style: TextStyle(
            fontSize: 12,
            color: _textMuted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),

        ..._history.map(_buildHistoryCard),

        const SizedBox(height: 8),
        _buildInfoNote(),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF172B4D),
            Color(0xFF285AA8),
            Color(0xFF367BF5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _blue.withValues(alpha: 0.20),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Performa Belajarmu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Ringkasan hasil evaluasi',
                      style: TextStyle(
                        color: Color(0xFFD7E5FF),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.auto_graph_rounded,
                color: Color(0xFFBBD5FF),
                size: 25,
              ),
            ],
          ),
          const SizedBox(height: 25),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rata-rata nilai',
                      style: TextStyle(
                        color: Color(0xFFD7E5FF),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _averageScore.toStringAsFixed(0),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 43,
                            height: 1,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 4, left: 4),
                          child: Text(
                            '/100',
                            style: TextStyle(
                              color: Color(0xFFD7E5FF),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.emoji_events_rounded,
                      color: Color(0xFFFFD166),
                      size: 22,
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '$_goodScoreCount dari ${_history.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Nilai ≥ 70',
                      style: TextStyle(
                        color: Color(0xFFD7E5FF),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 21),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: (_averageScore / 100).clamp(0.0, 1.0),
              minHeight: 7,
              backgroundColor: Colors.white.withValues(alpha: 0.20),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF8FE3C0),
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            _history.isEmpty
                ? 'Mulai evaluasi pertamamu!'
                : _averageScore >= 70
                    ? 'Pertahankan hasil baikmu dan terus belajar!'
                    : 'Terus berlatih untuk meningkatkan kesiapsiagaanmu.',
            style: const TextStyle(
              color: Color(0xFFE5EEFF),
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(RiwayatSkorItem item) {
    final isKuis = item.kategori.toLowerCase() == 'kuis';
    final scoreColor = _scoreColor(item.skor);
    final iconColor = isKuis
        ? const Color(0xFF367BF5)
        : const Color(0xFFE66B56);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EDF4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF172B4D).withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              isKuis
                  ? Icons.quiz_rounded
                  : Icons.personal_video_rounded,
              color: iconColor,
              size: 23,
            ),
          ),
          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 7,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.09),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        item.kategori,
                        style: TextStyle(
                          color: iconColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      item.tanggal,
                      style: const TextStyle(
                        fontSize: 10,
                        color: _textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.judul,
                  style: const TextStyle(
                    color: _textDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Icon(
                      item.skor >= 70
                          ? Icons.check_circle_rounded
                          : Icons.info_rounded,
                      size: 13,
                      color: scoreColor,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        item.status,
                        style: TextStyle(
                          fontSize: 10,
                          color: scoreColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: scoreColor.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    _scoreLabel(item.skor),
                    style: TextStyle(
                      color: scoreColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.skor}',
                style: TextStyle(
                  color: scoreColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              const Text(
                'DARI 100',
                style: TextStyle(
                  color: _textMuted,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF1F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: (item.skor / 100).clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: scoreColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8E6FF)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: _blue,
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Gunakan hasil evaluasi ini untuk mengetahui bagian yang perlu kamu pelajari kembali. Kesiapsiagaan dimulai dari pengetahuan dan latihan yang konsisten.',
              style: TextStyle(
                color: Color(0xFF38577E),
                fontSize: 11,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      children: [
        const SizedBox(height: 80),
        Center(
          child: Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FF),
              borderRadius: BorderRadius.circular(35),
            ),
            child: const Icon(
              Icons.history_rounded,
              size: 55,
              color: _blue,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Belum Ada Riwayat',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: _navy,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Hasil kuis dan simulasi yang kamu selesaikan akan muncul di sini. Yuk, mulai belajar dan uji kesiapsiagaanmu!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: _textMuted,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE4EAF3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  color: _blue,
                  size: 17,
                ),
                SizedBox(width: 8),
                Text(
                  'Mulai dari menu Kuis atau Simulasi',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
