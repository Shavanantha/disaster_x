import 'package:flutter/material.dart';

class KuisScreen extends StatelessWidget {
  const KuisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Kuis & Evaluasi', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Kartu Ringkasan Nilai / Skor
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
                  backgroundColor: Colors.amber.withOpacity(0.15),
                  child: const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 32),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Rata-rata Nilai Kamu', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      SizedBox(height: 4),
                      Text('85 / 100', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                      SizedBox(height: 2),
                      Text('Predikat: Tanggap Bencana Madya', style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text('Daftar Evaluasi Bencana', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          _buildKuisCard(
            context,
            title: 'Kuis 1: Prosedur Drop, Cover, Hold On',
            category: 'Gempa Bumi',
            questions: '10 Soal',
            score: 'Nilai: 90',
            scoreColor: Colors.green,
            status: 'Kerjakan Ulang',
          ),
          const SizedBox(height: 12),
          _buildKuisCard(
            context,
            title: 'Kuis 2: Taktik Menghindari Asap Beracun',
            category: 'Kebakaran',
            questions: '10 Soal',
            score: 'Nilai: 80',
            scoreColor: Colors.green,
            status: 'Kerjakan Ulang',
          ),
          const SizedBox(height: 12),
          _buildKuisCard(
            context,
            title: 'Kuis 3: Penyelamatan Saat Air Naik Cepat',
            category: 'Banjir',
            questions: '15 Soal',
            score: 'Belum Dikerjakan',
            scoreColor: Colors.grey,
            status: 'Mulai Kuis',
          ),
        ],
      ),
    );
  }

  Widget _buildKuisCard(
    BuildContext context, {
    required String title,
    required String category,
    required String questions,
    required String score,
    required Color scoreColor,
    required String status,
  }) {
    final bool isStart = status == 'Mulai Kuis';

    return Container(
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
                category,
                style: const TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold),
              ),
              Text(
                questions,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(score, style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isStart ? Colors.redAccent : Colors.white,
                  foregroundColor: isStart ? Colors.white : Colors.redAccent,
                  side: BorderSide(color: Colors.redAccent.withOpacity(0.5)),
                  elevation: 0,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$status sedang dibuka...')),
                  );
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