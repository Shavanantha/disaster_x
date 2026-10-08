import 'package:flutter/material.dart';
import '../../models/kuis_model.dart';
import '../../services/storage_service.dart';

class KuisResultScreen extends StatefulWidget {
  final PaketKuis paketKuis;
  final Map<int, int> userAnswers; // indexSoal -> selectedOptionIndex

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
      if (userAnswer != null && userAnswer == widget.paketKuis.daftarSoal[i].indexJawabanBenar) {
        correct++;
      }
    }
    final score = ((correct / widget.paketKuis.daftarSoal.length) * 100).round();

    setState(() {
      _totalCorrect = correct;
      _score = score;
    });

    if (!_isSaved) {
      _isSaved = true;
      await StorageService.saveQuizScore(widget.paketKuis.id, widget.paketKuis.judul, score);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalSoal = widget.paketKuis.daftarSoal.length;
    final isPassed = _score >= 70;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Hasil Evaluasi Kuis', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Score summary card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: isPassed ? Colors.green.withValues(alpha: 0.12) : Colors.amber.withValues(alpha: 0.15),
                  child: Icon(
                    isPassed ? Icons.military_tech_rounded : Icons.psychology_alt_rounded,
                    color: isPassed ? Colors.green : Colors.amber.shade800,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isPassed ? 'Lulus Memuaskan!' : 'Perlu Pendalaman Materi',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.paketKuis.judul,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  '$_score / 100',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: isPassed ? Colors.green : Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPassed ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isPassed ? 'Predikat: Tanggap Bencana Utama' : 'Predikat: Tanggap Bencana Pemula',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isPassed ? Colors.green.shade800 : Colors.orange.shade900,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCol('Benar', '$_totalCorrect', Colors.green),
                    _buildStatCol('Salah', '${totalSoal - _totalCorrect}', Colors.redAccent),
                    _buildStatCol('Total Soal', '$totalSoal', Colors.black87),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Pembahasan Soal
          const Text('Pembahasan & Kunci Jawaban', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          ...widget.paketKuis.daftarSoal.asMap().entries.map((entry) {
            final index = entry.key;
            final soal = entry.value;
            final userAnswer = widget.userAnswers[index];
            final isCorrect = userAnswer == soal.indexJawabanBenar;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isCorrect ? Colors.green.shade200 : Colors.redAccent.shade100,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isCorrect ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isCorrect ? '✓ Benar' : '✗ Salah',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isCorrect ? Colors.green : Colors.redAccent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Soal #${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(soal.pertanyaan, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Text(
                    'Jawaban Kamu: ${userAnswer != null ? soal.pilihan[userAnswer] : "Tidak dijawab"}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isCorrect ? Colors.green.shade800 : Colors.redAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (!isCorrect) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Kunci Jawaban: ${soal.pilihan[soal.indexJawabanBenar]}',
                      style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F9FC),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Pembahasan: ${soal.penjelasan}',
                      style: const TextStyle(fontSize: 11, color: Colors.black87, height: 1.3),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Kembali ke Menu Kuis', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatCol(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
