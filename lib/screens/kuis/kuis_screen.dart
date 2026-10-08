import 'package:flutter/material.dart';
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
  Map<String, int> _scores = {};

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final avg = await StorageService.getRataRataNilai();
    final scores = await StorageService.getQuizScores();
    if (mounted) {
      setState(() {
        _rataRata = avg;
        _scores = scores;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Kuis & Evaluasi Belajar', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Kartu Ringkasan Nilai
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.amber.withValues(alpha: 0.15),
                  child: const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 32),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Rata-rata Nilai Kamu', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(
                        '${_rataRata.toStringAsFixed(0)} / 100',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _rataRata >= 80 ? 'Predikat: Tanggap Bencana Madya' : 'Predikat: Tanggap Bencana Pratama',
                        style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text('Daftar Paket Kuis Bencana', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          ...DummyData.daftarKuis.map((kuis) {
            final score = _scores[kuis.id];
            final bool hasAttempted = score != null;

            return _buildKuisCard(
              context,
              kuis: kuis,
              score: hasAttempted ? 'Nilai: $score' : 'Belum Dikerjakan',
              scoreColor: hasAttempted ? (score >= 70 ? Colors.green : Colors.redAccent) : Colors.grey,
              status: hasAttempted ? 'Kerjakan Ulang' : 'Mulai Kuis',
            );
          }),
        ],
      ),
    );
  }

  Widget _buildKuisCard(
    BuildContext context, {
    required PaketKuis kuis,
    required String score,
    required Color scoreColor,
    required String status,
  }) {
    final bool isStart = status == 'Mulai Kuis';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                kuis.kategori,
                style: const TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold),
              ),
              Text(
                '${kuis.jumlahSoal} Soal • ${kuis.batasWaktuMenit} Menit',
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(kuis.judul, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(score, style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isStart ? Colors.redAccent : Colors.white,
                  foregroundColor: isStart ? Colors.white : Colors.redAccent,
                  side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
                  elevation: 0,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KuisPlayScreen(paketKuis: kuis),
                    ),
                  );
                  _loadScores();
                },
                child: Text(status, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
