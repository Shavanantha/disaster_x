import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/kuis_model.dart';
import 'kuis_result_screen.dart';

class KuisPlayScreen extends StatefulWidget {
  final PaketKuis paketKuis;

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

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        _timer?.cancel();
        _finishQuiz();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

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

  void _confirmSubmit() {
    final unanswered = widget.paketKuis.daftarSoal.length - _userAnswers.length;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Kumpulkan Jawaban?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text(
          unanswered > 0
              ? 'Masih ada $unanswered soal yang belum kamu jawab. Apakah kamu yakin ingin menyelesaikan kuis sekarang?'
              : 'Semua soal telah dijawab. Apakah kamu ingin mengakhiri dan melihat nilai akhir?',
          style: const TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Periksa Lagi'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _finishQuiz();
            },
            child: const Text('Ya, Selesai'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTimer(int totalSecs) {
    final min = totalSecs ~/ 60;
    final sec = totalSecs % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final totalSoal = widget.paketKuis.daftarSoal.length;
    final currentSoal = widget.paketKuis.daftarSoal[_currentIndex];
    final selectedOption = _userAnswers[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(widget.paketKuis.judul, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _remainingSeconds < 60 ? Colors.red.withValues(alpha: 0.1) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _remainingSeconds < 60 ? Colors.redAccent : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: _remainingSeconds < 60 ? Colors.redAccent : Colors.black87,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatTimer(_remainingSeconds),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _remainingSeconds < 60 ? Colors.redAccent : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar Soal
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Soal ${_currentIndex + 1} dari $totalSoal',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87),
                      ),
                      Text(
                        'Terjawab: ${_userAnswers.length}/$totalSoal',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (_currentIndex + 1) / totalSoal,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),

            // Card Soal & Pilihan
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(
                      currentSoal.pertanyaan,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, height: 1.45),
                    ),
                  ),
                  const SizedBox(height: 16),

                  ...currentSoal.pilihan.asMap().entries.map((entry) {
                    final optIndex = entry.key;
                    final optText = entry.value;
                    final isSelected = selectedOption == optIndex;
                    final optionLetter = String.fromCharCode(65 + optIndex); // A, B, C, D

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.redAccent.withValues(alpha: 0.06) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.redAccent : Colors.grey.shade300,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            setState(() {
                              _userAnswers[_currentIndex] = optIndex;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: isSelected ? Colors.redAccent : Colors.grey.shade100,
                                  child: Text(
                                    optionLetter,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    optText,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isSelected ? Colors.redAccent.shade700 : Colors.black87,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Bottom Navigation Buttons (Prev / Next / Finish)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  if (_currentIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          setState(() {
                            _currentIndex--;
                          });
                        },
                        child: const Text('Sebelumnya'),
                      ),
                    ),
                  if (_currentIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (_currentIndex < totalSoal - 1) {
                          setState(() {
                            _currentIndex++;
                          });
                        } else {
                          _confirmSubmit();
                        }
                      },
                      child: Text(
                        _currentIndex < totalSoal - 1 ? 'Selanjutnya' : 'Selesai & Kumpulkan',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
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
