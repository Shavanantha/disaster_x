import 'dart:async';
import 'package:flutter/material.dart';

class InteractiveSimulationScreen extends StatefulWidget {
  const InteractiveSimulationScreen({super.key});

  @override
  State<InteractiveSimulationScreen> createState() => _InteractiveSimulationScreenState();
}

class _InteractiveSimulationScreenState extends State<InteractiveSimulationScreen> {
  int _currentSeconds = 0;
  final int _totalSeconds = 60;
  Timer? _timer;
  bool _isPlaying = false;
  bool _checkpointTriggered = false;
  int _safetyScore = 50; // Skor awal
  String _simulationLog = 'Simulasi dimulai. Situasi kelas normal...';

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  void _startSimulation() {
    setState(() {
      _isPlaying = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds >= _totalSeconds) {
        _timer?.cancel();
        setState(() {
          _isPlaying = false;
        });
      } else {
        setState(() {
          _currentSeconds++;
        });

        // Checkpoint aktif otomatis di detik ke-15 (Auto-Pause)
        if (_currentSeconds == 15 && !_checkpointTriggered) {
          _pauseAndTriggerCheckpoint();
        }
      }
    });
  }

  void _pauseAndTriggerCheckpoint() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _checkpointTriggered = true;
      _simulationLog = 'PERINGATAN: Guncangan gempa 6.5 SR terjadi!';
    });

    // Munculkan dialog pilihan tindakan otomatis
    _showDecisionDialog();
  }

  void _resumeSimulation() {
    setState(() {
      _isPlaying = true;
      _simulationLog = 'Melanjutkan proses evakuasi ke titik kumpul aman...';
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds >= _totalSeconds) {
        _timer?.cancel();
        setState(() {
          _isPlaying = false;
          _simulationLog = 'Simulasi Selesai! Kamu berhasil mengevakuasi diri.';
        });
      } else {
        setState(() {
          _currentSeconds++;
        });
      }
    });
  }

  void _showDecisionDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'CHECKPOINT 1 (Detik 00:15)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.redAccent),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Lantai berguncang sangat hebat, puing plafon mulai berjatuhan! Apa tindakan pertama yang kamu ambil?',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Opsi A (Salah)
              _buildOptionButton(
                text: 'A. Segera lari kencang menuju pintu keluar & tangga',
                onTap: () {
                  Navigator.pop(context);
                  _handleAnswer(
                    isSafe: false,
                    scoreDelta: -20,
                    title: 'Tindakan Berisiko!',
                    feedback: 'Lari saat guncangan hebat sangat berbahaya. Kamu berisiko tinggi terjatuh atau tertimpa runtuhan bangunan.',
                  );
                },
              ),
              const SizedBox(height: 8),

              // Opsi B (Benar)
              _buildOptionButton(
                text: 'B. Berlindung di bawah meja kokoh (Drop, Cover, Hold On)',
                onTap: () {
                  Navigator.pop(context);
                  _handleAnswer(
                    isSafe: true,
                    scoreDelta: 40,
                    title: 'Tindakan Tepat & Aman!',
                    feedback: 'Sangat bagus! Metode Drop, Cover, Hold On melindungi kepala dan organ vitalmu dari material jatuh.',
                  );
                },
              ),
              const SizedBox(height: 8),

              // Opsi C (Salah)
              _buildOptionButton(
                text: 'C. Berdiri di dekat jendela kaca untuk melihat keluar',
                onTap: () {
                  Navigator.pop(context);
                  _handleAnswer(
                    isSafe: false,
                    scoreDelta: -30,
                    title: 'Tindakan Sangat Berbahaya!',
                    feedback: 'Kaca jendela rentan pecah dan dapat melukai tubuh akibat serpihan benda tajam.',
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleAnswer({
    required bool isSafe,
    required int scoreDelta,
    required String title,
    required String feedback,
  }) {
    // Tampilkan Modal Konsekuensi sesuai dokumen PRD
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(
                isSafe ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: isSafe ? Colors.green : Colors.redAccent,
                size: 28,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSafe ? Colors.green : Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(feedback, style: const TextStyle(fontSize: 13, height: 1.4)),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSafe ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Perubahan Safety Score: ',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSafe ? Colors.green.shade900 : Colors.red.shade900),
                    ),
                    Text(
                      scoreDelta > 0 ? '+$scoreDelta' : '$scoreDelta',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isSafe ? Colors.green : Colors.redAccent),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSafe ? Colors.green : Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _safetyScore = (_safetyScore + scoreDelta).clamp(0, 100);
                });
                // Lanjutkan video/simulasi
                _resumeSimulation();
              },
              child: const Text('Lanjutkan Simulasi'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOptionButton({required String text, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onTap,
        child: Text(text, style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w500)),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('Simulasi Gempa Bumi (Ruang Kelas)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E2C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Area Player Video Interaktif
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ilustrasi Situasi Skenario
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _currentSeconds >= 15 ? Icons.flood_rounded : Icons.apartment_rounded,
                        size: 90,
                        color: _currentSeconds >= 15 ? Colors.amber : Colors.white54,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _currentSeconds >= 15 ? '⚠️ GUNCANGAN GEMPA AKTIF ⚠️' : 'Situasi Kelas Kondusif',
                        style: TextStyle(
                          color: _currentSeconds >= 15 ? Colors.amber : Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Waktu Simulasi: 00:${_currentSeconds.toString().padLeft(2, '0')} / 00:$_totalSeconds',
                        style: const TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),

                  // Badge Live / Status Auto-Pause
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isPlaying ? Colors.redAccent : Colors.amber.shade700,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _isPlaying ? 'REC • SIMULASI AKTIF' : 'PAUSED (CHECKPOINT)',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // Safety Readiness Score Floating Chip
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shield_rounded, color: Colors.greenAccent, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Safety Score: $_safetyScore',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Area Kontrol & Log Kejadian di Bawah Player
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Catatan & Status Kejadian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F9FC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(_simulationLog, style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.3)),
                  ),
                  const Spacer(),
                  // Progress Bar Simulasi
                  LinearProgressIndicator(
                    value: _currentSeconds / _totalSeconds,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 16),
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
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.exit_to_app_rounded),
                      label: const Text('Keluar dari Simulasi', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
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