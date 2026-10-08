import 'package:flutter/material.dart';
import '../../models/user_profile_model.dart';
import '../../services/storage_service.dart';

class SertifikatScreen extends StatefulWidget {
  const SertifikatScreen({super.key});

  @override
  State<SertifikatScreen> createState() => _SertifikatScreenState();
}

class _SertifikatScreenState extends State<SertifikatScreen> {
  UserProfile? _profile;
  double _rataRata = 85.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prof = await StorageService.getUserProfile();
    final avg = await StorageService.getRataRataNilai();
    if (mounted) {
      setState(() {
        _profile = prof;
        _rataRata = avg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Sertifikat Kelulusan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Frame Sertifikat
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade300, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Logo & Header Sertifikat
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'DISASTER-X INDONESIA',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.2),
                          ),
                          Text(
                            'Mobile Disaster Mitigation Academy',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(thickness: 1.5, color: Color(0xFFFFE082)),
                  const SizedBox(height: 12),

                  const Text(
                    'SERTIFIKAT KESIAPSIAGAAN BENCANA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Color(0xFFC2185B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Diberikan dengan bangga kepada:',
                    style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),

                  // Nama Siswa
                  Text(
                    _profile!.nama.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NIM: ${_profile!.nim} • ${_profile!.sekolah}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 14),

                  const Text(
                    'Telah berhasil menyelesaikan seluruh rangkaian materi mitigasi prabencana, '
                    'kuis evaluasi, dan simulasi skenario kegawatdaruratan adaptif dengan perolehan nilai:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, height: 1.4, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),

                  // Nilai & Predikat
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Text(
                      'Rata-rata Skor: ${_rataRata.toStringAsFixed(0)} / 100 • Predikat: TANGGAP BENGGALA',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Cap & Tanda Tangan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: const [
                          Icon(Icons.qr_code_2_rounded, size: 48, color: Colors.black54),
                          Text('ID: DSX-2026-OKT', style: TextStyle(fontSize: 9, color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: const [
                          Text('Bandar Lampung, 2026', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          SizedBox(height: 6),
                          Icon(Icons.verified_rounded, color: Colors.blueAccent, size: 28),
                          SizedBox(height: 4),
                          Text(
                            'Instruktur Mobile Programming',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Unduh / Bagikan
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.download_done_rounded, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Sertifikat berhasil diunduh ke memori perangkat!'),
                        ],
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.download_rounded),
                label: const Text('Unduh Sertifikat PDF / Gambar', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
