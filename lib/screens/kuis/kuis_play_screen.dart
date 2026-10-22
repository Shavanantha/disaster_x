import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'kuis_result_screen.dart';

class KuisPlayScreen extends StatefulWidget {
  final dynamic paketKuis;

  const KuisPlayScreen({
    super.key,
    required this.paketKuis,
  });

  @override
  State<KuisPlayScreen> createState() => _KuisPlayScreenState();
}

class _KuisPlayScreenState extends State<KuisPlayScreen> {
  int _currentIndex = 0;
  final Map<int, int> _userAnswers = {};

  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _remainingSeconds = widget.paketKuis.batasWaktuMenit * 60;
    _startTimer();
  }

  // ============================================================
  // TIMER
  // ============================================================

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _finishQuiz();
      } else {
        if (mounted) {
          setState(() {
            _remainingSeconds--;
          });
        }
      }
    });
  }

  // ============================================================
  // FINISH QUIZ
  // ============================================================

  void _finishQuiz() {
    _timer?.cancel();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => KuisResultScreen(
          paketKuis: widget.paketKuis,
          userAnswers: _userAnswers,
        ),
      ),
    );
  }

  // ============================================================
  // CONFIRM SUBMIT
  // ============================================================

  void _confirmSubmit() {
    final totalSoal = widget.paketKuis.daftarSoal.length;
    final belumDijawab = totalSoal - _userAnswers.length;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Selesaikan Kuis?',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          content: Text(
            belumDijawab > 0
                ? 'Masih ada $belumDijawab soal yang belum dijawab. Yakin ingin melihat hasil sekarang?'
                : 'Semua soal sudah dijawab. Yakin ingin menyelesaikan kuis?',
            style: const TextStyle(
              color: Color(0xFF667085),
              height: 1.5,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Kembali',
                style: TextStyle(
                  color: Color(0xFF667085),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _finishQuiz();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Ya, Selesai',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ============================================================
  // TIMER FORMAT
  // ============================================================

  String _formatTimer(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  String get _category {
    return widget.paketKuis.kategori.toString();
  }

  IconData get _categoryIcon {
    final category = _category.toLowerCase();

    if (category.contains('gempa')) {
      return Icons.public;
    }

    if (category.contains('kebakaran')) {
      return Icons.local_fire_department_rounded;
    }

    if (category.contains('banjir')) {
      return Icons.water_drop_rounded;
    }

    return Icons.shield_rounded;
  }

  Color get _accentColor {
    final category = _category.toLowerCase();

    if (category.contains('gempa')) {
      return const Color(0xFF315EFB);
    }

    if (category.contains('kebakaran')) {
      return const Color(0xFFE85D3F);
    }

    if (category.contains('banjir')) {
      return const Color(0xFF159A9C);
    }

    return const Color(0xFF315EFB);
  }

  Color get _accentLightColor {
    return _accentColor.withValues(alpha: 0.10);
  }

  // ============================================================
  // ANSWER
  // ============================================================

  void _selectAnswer(int answer) {
    HapticFeedback.selectionClick();

    setState(() {
      _userAnswers[_currentIndex] = answer;
    });
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void _nextQuestion() {
    if (_currentIndex < widget.paketKuis.daftarSoal.length - 1) {
      HapticFeedback.selectionClick();

      setState(() {
        _currentIndex++;
      });
    } else {
      _confirmSubmit();
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      HapticFeedback.selectionClick();

      setState(() {
        _currentIndex--;
      });
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final soal = widget.paketKuis.daftarSoal[_currentIndex];
    final totalSoal = widget.paketKuis.daftarSoal.length;

    final progress = (_currentIndex + 1) / totalSoal;
    final answeredProgress = _userAnswers.length / totalSoal;

    final selectedAnswer = _userAnswers[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // TOP HEADER
            // ==================================================

            _buildHeader(),

            // ==================================================
            // CONTENT
            // ==================================================

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.04, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: SingleChildScrollView(
                  key: ValueKey(_currentIndex),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProgressSection(
                        progress,
                        answeredProgress,
                        totalSoal,
                      ),

                      const SizedBox(height: 22),

                      _buildCategoryBadge(),

                      const SizedBox(height: 14),

                      _buildQuestionCard(
                        soal.pertanyaan,
                        _currentIndex,
                        totalSoal,
                      ),

                      const SizedBox(height: 20),

                      _buildOptions(
                        soal.pilihan,
                        selectedAnswer,
                      ),

                      const SizedBox(height: 18),

                      _buildInfoTip(),
                    ],
                  ),
                ),
              ),
            ),

            // ==================================================
            // BOTTOM NAVIGATION
            // ==================================================

            _buildBottomNavigation(totalSoal),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    final isLowTime = _remainingSeconds <= 60;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE9EDF3),
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          Material(
            color: const Color(0xFFF4F6FA),
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      title: const Text(
                        'Keluar dari kuis?',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      content: const Text(
                        'Progress jawabanmu mungkin tidak tersimpan jika keluar sekarang.',
                        style: TextStyle(
                          color: Color(0xFF667085),
                          height: 1.5,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          child: const Text('Tetap di Kuis'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Keluar',
                            style: TextStyle(
                              color: Color(0xFFE85D3F),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  Icons.close_rounded,
                  size: 22,
                  color: Color(0xFF344054),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kuis Kesiapsiagaan',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172033),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.paketKuis.judul,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF98A2B3),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Timer
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: isLowTime
                  ? const Color(0xFFFFF0EE)
                  : const Color(0xFFF1F4FA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isLowTime
                    ? const Color(0xFFFFD5CE)
                    : const Color(0xFFE5EAF2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 17,
                  color: isLowTime
                      ? const Color(0xFFE85D3F)
                      : const Color(0xFF475467),
                ),
                const SizedBox(width: 6),
                Text(
                  _formatTimer(_remainingSeconds),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isLowTime
                        ? const Color(0xFFE85D3F)
                        : const Color(0xFF344054),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  Widget _buildProgressSection(
    double progress,
    double answeredProgress,
    int totalSoal,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PERTANYAAN ${_currentIndex + 1} / $totalSoal',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: _accentColor,
              ),
            ),
            Text(
              '${(_userAnswers.length / totalSoal * 100).round()}% terjawab',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF98A2B3),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: const Color(0xFFE6EAF1),
            valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: _accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '${_userAnswers.length} sudah dijawab',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF667085),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${totalSoal - _userAnswers.length} tersisa',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF98A2B3),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // CATEGORY BADGE
  // ============================================================

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: _accentLightColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _categoryIcon,
            size: 17,
            color: _accentColor,
          ),
          const SizedBox(width: 7),
          Text(
            _category.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: _accentColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUESTION CARD
  // ============================================================

  Widget _buildQuestionCard(
    String question,
    int index,
    int total,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE8ECF2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _accentLightColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.help_outline_rounded,
                  size: 20,
                  color: _accentColor,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Pilih jawaban yang paling tepat',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF98A2B3),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            question,
            style: const TextStyle(
              fontSize: 18,
              height: 1.45,
              fontWeight: FontWeight.w800,
              color: Color(0xFF172033),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: _accentColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // OPTIONS
  // ============================================================

  Widget _buildOptions(
    List<String> options,
    int? selectedAnswer,
  ) {
    return Column(
      children: List.generate(
        options.length,
        (index) {
          final option = options[index];
          final isSelected = selectedAnswer == index;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildOptionCard(
              option,
              index,
              isSelected,
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptionCard(
    String option,
    int index,
    bool isSelected,
  ) {
    final letters = ['A', 'B', 'C', 'D', 'E'];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isSelected
            ? _accentLightColor
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected
              ? _accentColor
              : const Color(0xFFE3E7EE),
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: _accentColor.withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            _selectAnswer(index);
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _accentColor
                        : const Color(0xFFF2F4F7),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 20,
                          )
                        : Text(
                            letters[index],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF667085),
                            ),
                          ),
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF172033)
                          : const Color(0xFF475467),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  opacity: isSelected ? 1 : 0,
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: _accentColor,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INFO TIP
  // ============================================================

  Widget _buildInfoTip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            size: 19,
            color: Color(0xFF667085),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Pilih tindakan yang menurutmu paling aman dalam situasi darurat.',
              style: TextStyle(
                fontSize: 11.5,
                height: 1.45,
                color: Color(0xFF667085),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation(int totalSoal) {
    final isFirst = _currentIndex == 0;
    final isLast = _currentIndex == totalSoal - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE9EDF3),
          ),
        ),
      ),
      child: Row(
        children: [
          // Previous
          Expanded(
            flex: 1,
            child: OutlinedButton(
              onPressed: isFirst ? null : _previousQuestion,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 52),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                foregroundColor: const Color(0xFF344054),
                disabledForegroundColor: const Color(0xFFD0D5DD),
                side: BorderSide(
                  color: isFirst
                      ? const Color(0xFFE6E8EC)
                      : const Color(0xFFD8DDE6),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Next / Finish
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: _nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLast
                        ? 'Selesai & Lihat Hasil'
                        : 'Lanjut ke Soal Berikutnya',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isLast
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                    size: 19,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}