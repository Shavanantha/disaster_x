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

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final list = await StorageService.getScoreHistory();
    if (mounted) {
      setState(() {
        _history = list;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Riwayat Nilai & Evaluasi', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? const Center(
                  child: Text('Belum ada riwayat pengerjaan nilai.', style: TextStyle(color: Colors.grey)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final item = _history[index];
                    final isKuis = item.kategori == 'Kuis';
                    final isGood = item.skor >= 70;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: isKuis ? Colors.blue.withValues(alpha: 0.12) : Colors.red.withValues(alpha: 0.12),
                            child: Icon(
                              isKuis ? Icons.assignment_turned_in_rounded : Icons.videocam_rounded,
                              color: isKuis ? Colors.blue : Colors.redAccent,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        item.kategori,
                                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(item.tanggal, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.judul,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Status: ${item.status}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isGood ? Colors.green : Colors.orange.shade800,
                                    fontWeight: FontWeight.w600,
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
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: isGood ? Colors.green : Colors.redAccent,
                                ),
                              ),
                              const Text('/100', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
