import 'package:flutter/material.dart';
import '../../models/kuis_model.dart';
import '../../services/storage_service.dart';

class KuisResultScreen extends StatefulWidget {
  final PaketKuis paketKuis;
  final Map<int, int> userAnswers;

  const KuisResultScreen({
    super.key,
    required this.paketKuis,
    required this.userAnswers,
  });

  @override
  State<KuisResultScreen> createState() => _KuisResultScreenState();
}

class _KuisResultScreenState extends State<KuisResultScreen> {
  late int _score;
  late int _totalCorrect;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _calculateAndSaveScore();
  }

  Future<void> _calculateAndSaveScore() async {
    int correct = 0;

    for (int i = 0; i < widget.paketKuis.daftarSoal.length; i++) {
      final userAnswer = widget.userAnswers[i];

      if (userAnswer != null &&
          userAnswer ==
              widget.paketKuis.daftarSoal[i].indexJawabanBenar) {
        correct++;
      }
    }

    final score =
        ((correct / widget.paketKuis.daftarSoal.length) * 100).round();

    setState(() {
      _totalCorrect = correct;
      _score = score;
    });

    if (!_isSaved) {
      _isSaved = true;

      await StorageService.saveQuizScore(
        widget.paketKuis.id,
        widget.paketKuis.judul,
        score,
      );
    }
  }

  String get _predicate {
    if (_score >= 90) return 'Sangat Siap';
    if (_score >= 70) return 'Tanggap Bencana Utama';
    if (_score >= 50) return 'Cukup Siap';
    return 'Perlu Pendalaman';
  }

  String get _message {
    if (_score >= 90) {
      return 'Hebat! Pemahaman kamu tentang kesiapsiagaan bencana sudah sangat baik.';
    } else if (_score >= 70) {
      return 'Bagus! Kamu sudah memahami sebagian besar tindakan yang tepat saat menghadapi bencana.';
    } else if (_score >= 50) {
      return 'Kamu sudah memiliki dasar yang cukup. Yuk, pelajari kembali materi yang masih belum dikuasai.';
    }

    return 'Jangan menyerah! Pelajari kembali materi dan coba kerjakan kuis ini lagi.';
  }

  Color get _scoreColor {
    if (_score >= 70) return const Color(0xFF16A34A);
    if (_score >= 50) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  IconData get _resultIcon {
    if (_score >= 90) return Icons.emoji_events_rounded;
    if (_score >= 70) return Icons.verified_rounded;
    if (_score >= 50) return Icons.psychology_alt_rounded;
    return Icons.menu_book_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final totalSoal = widget.paketKuis.daftarSoal.length;
    final totalWrong = totalSoal - _totalCorrect;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(context),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(
                  children: [
                    _buildScoreCard(totalSoal, totalWrong),
                    const SizedBox(height: 16),
                    _buildInsightCard(),
                    const SizedBox(height: 28),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Pembahasan Soal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF172033),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Lihat jawaban dan pembahasan untuk mengevaluasi pemahamanmu.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final soal = widget.paketKuis.daftarSoal[index];
                    final userAnswer = widget.userAnswers[index];
                    final isCorrect =
                        userAnswer == soal.indexJawabanBenar;

                    return _buildQuestionReview(
                      index: index,
                      soal: soal,
                      userAnswer: userAnswer,
                      isCorrect: isCorrect,
                    );
                  },
                  childCount: totalSoal,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: Column(
                  children: [
                    _buildTryAgainButton(context),
                    const SizedBox(height: 10),
                    _buildBackButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF172033),
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hasil Evaluasi',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172033),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Lihat hasil dan evaluasi belajarmu',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(int totalSoal, int totalWrong) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF172033),
            Color(0xFF263B61),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF172033).withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            widget.paketKuis.judul,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            width: 124,
            height: 124,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 2,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _resultIcon,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$_score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    '/ 100',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            _predicate,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            _message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _buildScoreStat(
                  icon: Icons.check_circle_rounded,
                  value: '$_totalCorrect',
                  label: 'Benar',
                  color: const Color(0xFF4ADE80),
                ),
              ),
              Container(
                width: 1,
                height: 35,
                color: Colors.white12,
              ),
              Expanded(
                child: _buildScoreStat(
                  icon: Icons.cancel_rounded,
                  value: '$totalWrong',
                  label: 'Salah',
                  color: const Color(0xFFFCA5A5),
                ),
              ),
              Container(
                width: 1,
                height: 35,
                color: Colors.white12,
              ),
              Expanded(
                child: _buildScoreStat(
                  icon: Icons.quiz_rounded,
                  value: '$totalSoal',
                  label: 'Total',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreStat({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 18,
          color: color,
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _scoreColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _scoreColor.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _scoreColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lightbulb_rounded,
              color: _scoreColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Evaluasi Belajar',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172033),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Perhatikan soal yang masih salah dan pahami kembali pembahasannya agar lebih siap menghadapi situasi darurat.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionReview({
    required int index,
    required dynamic soal,
    required int? userAnswer,
    required bool isCorrect,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCorrect
              ? const Color(0xFFBBF7D0)
              : const Color(0xFFFECACA),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isCorrect
                          ? Icons.check_rounded
                          : Icons.close_rounded,
                      size: 14,
                      color: isCorrect
                          ? const Color(0xFF15803D)
                          : const Color(0xFFDC2626),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      isCorrect ? 'Benar' : 'Salah',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: isCorrect
                            ? const Color(0xFF15803D)
                            : const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Soal ${index + 1}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black45,
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          Text(
            soal.pertanyaan,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF172033),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 12),

          _buildAnswerRow(
            title: 'Jawaban kamu',
            answer: userAnswer != null
                ? soal.pilihan[userAnswer]
                : 'Tidak dijawab',
            color: isCorrect
                ? const Color(0xFF15803D)
                : const Color(0xFFDC2626),
            background: isCorrect
                ? const Color(0xFFF0FDF4)
                : const Color(0xFFFEF2F2),
            icon: isCorrect
                ? Icons.check_circle_outline_rounded
                : Icons.cancel_outlined,
          ),

          if (!isCorrect) ...[
            const SizedBox(height: 8),
            _buildAnswerRow(
              title: 'Kunci jawaban',
              answer: soal.pilihan[soal.indexJawabanBenar],
              color: const Color(0xFF15803D),
              background: const Color(0xFFF0FDF4),
              icon: Icons.verified_outlined,
            ),
          ],

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.menu_book_rounded,
                  size: 17,
                  color: Color(0xFF52647A),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    soal.penjelasan,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF52647A),
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerRow({
    required String title,
    required String answer,
    required Color color,
    required Color background,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 17,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black87,
                  height: 1.35,
                ),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  TextSpan(
                    text: answer,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTryAgainButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.refresh_rounded),
        label: const Text(
          'Kembali & Coba Lagi',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEF4444),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_rounded),
        label: const Text(
          'Kembali ke Menu Kuis',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF172033),
          side: BorderSide(
            color: Colors.grey.shade300,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}