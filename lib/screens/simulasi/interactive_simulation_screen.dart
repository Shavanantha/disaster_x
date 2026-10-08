import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/simulasi_model.dart';
import '../../services/storage_service.dart';
import '../../widgets/icon_helper.dart';

class InteractiveSimulationScreen extends StatefulWidget {
  final SkenarioSimulasi skenario;

  const InteractiveSimulationScreen({
    super.key,
    required this.skenario,
  });

  @override
  State<InteractiveSimulationScreen> createState() => _InteractiveSimulationScreenState();
}

class _InteractiveSimulationScreenState extends State<InteractiveSimulationScreen> {
  late int _totalSeconds;
  int _currentSeconds = 0;
  Timer? _timer;
  bool _isPlaying = false;
  int _safetyScore = 50; // Skor awal
  final List<String> _eventLogs = [];
  final Set<int> _triggeredCheckpoints = {};
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.skenario.totalDetik;
    _eventLogs.add(widget.skenario.prolog);
    _startSimulation();
  }

  void _startSimulation() {
    setState(() {
      _isPlaying = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds >= _totalSeconds) {
        _timer?.cancel();
        _onSimulationCompleted();
      } else {
        setState(() {
          _currentSeconds++;
        });

        // Cek apakah detik ini memicu checkpoint
        for (final cp in widget.skenario.checkpoints) {
          if (_currentSeconds == cp.detik && !_triggeredCheckpoints.contains(cp.detik)) {
            _triggeredCheckpoints.add(cp.detik);
            _pauseAndTriggerCheckpoint(cp);
            break;
          }
        }
      }
    });
  }

  void _pauseAndTriggerCheckpoint(SimulasiCheckpoint checkpoint) {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _eventLogs.insert(0, '⚠️ [PERINGATAN]: ${checkpoint.narasiSituasi}');
    });

    // Buka modal keputusan
    _showDecisionBottomSheet(checkpoint);
  }

  void _resumeSimulation() {
    setState(() {
      _isPlaying = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds >= _totalSeconds) {
        _timer?.cancel();
        _onSimulationCompleted();
      } else {
        setState(() {
          _currentSeconds++;
        });

        for (final cp in widget.skenario.checkpoints) {
          if (_currentSeconds == cp.detik && !_triggeredCheckpoints.contains(cp.detik)) {
            _triggeredCheckpoints.add(cp.detik);
            _pauseAndTriggerCheckpoint(cp);
            break;
          }
        }
      }
    });
  }

  Future<void> _onSimulationCompleted() async {
    setState(() {
      _isPlaying = false;
      _isFinished = true;
      _eventLogs.insert(0, '🎉 ${widget.skenario.pesanSelesai}');
    });

    // Simpan ke storage
    await StorageService.saveSimulationScore(widget.skenario.id, _safetyScore);

    if (!mounted) return;
    _showFinishDialog();
  }

  void _showDecisionBottomSheet(SimulasiCheckpoint checkpoint) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      checkpoint.judul,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                checkpoint.narasiSituasi,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, height: 1.35),
              ),
              const SizedBox(height: 16),
              ...checkpoint.pilihan.map((pilihan) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _handleAnswer(pilihan);
                      },
                      child: Text(
                        '${pilihan.kode}. ${pilihan.teks}',
                        style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _handleAnswer(PilihanKeputusan pilihan) {
    final bool isSafe = pilihan.isAman;
    final int delta = pilihan.skorDelta;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
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
                  pilihan.judulFeedback,
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
              Text(pilihan.feedback, style: const TextStyle(fontSize: 13, height: 1.4)),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSafe ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Perubahan Safety Score: ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSafe ? Colors.green.shade900 : Colors.red.shade900,
                      ),
                    ),
                    Text(
                      delta > 0 ? '+$delta' : '$delta',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSafe ? Colors.green : Colors.redAccent,
                      ),
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
                Navigator.pop(ctx);
                setState(() {
                  _safetyScore = (_safetyScore + delta).clamp(0, 100);
                  _eventLogs.insert(0, '${isSafe ? "✓" : "✗"} Pilihan ${pilihan.kode}: $delta (${pilihan.judulFeedback})');
                });
                _resumeSimulation();
              },
              child: const Text('Lanjutkan Simulasi'),
            ),
          ],
        );
      },
    );
  }

  void _showFinishDialog() {
    final bool isPassed = _safetyScore >= 60;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: isPassed ? Colors.green.withValues(alpha: 0.15) : Colors.redAccent.withValues(alpha: 0.15),
                child: Icon(
                  isPassed ? Icons.emoji_events_rounded : Icons.replay_rounded,
                  color: isPassed ? Colors.green : Colors.redAccent,
                  size: 44,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isPassed ? 'Simulasi Berhasil!' : 'Evaluasi Diperlukan',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                isPassed ? 'Kamu berhasil mengambil keputusan mitigasi darurat dengan baik!' : 'Tingkat keselamatan masih di bawah batas aman (60%). Coba pelajari materi dan ulangi lagi.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.3),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isPassed ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text('Skor Keselamatan Akhir', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      '$_safetyScore / 100',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: isPassed ? Colors.green : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                // Restart simulasi
                setState(() {
                  _currentSeconds = 0;
                  _safetyScore = 50;
                  _triggeredCheckpoints.clear();
                  _eventLogs.clear();
                  _eventLogs.add(widget.skenario.prolog);
                  _isFinished = false;
                });
                _startSimulation();
              },
              child: const Text('Coba Lagi'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('Kembali ke Menu'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Color(widget.skenario.warnaHex);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: Text(widget.skenario.judul, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E2C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Area Visual Simulasi Interaktif
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ilustrasi Skenario
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        getDisasterIcon(widget.skenario.iconCode),
                        size: 88,
                        color: _currentSeconds >= 12 ? Colors.amber : Colors.white54,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isFinished
                            ? 'SIMULASI SELESAI'
                            : (_currentSeconds >= 12 ? '⚠️ TAHAP DARURAT BERJALAN ⚠️' : 'Situasi Normal / Deteksi Awal'),
                        style: TextStyle(
                          color: _currentSeconds >= 12 ? Colors.amber : Colors.white70,
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
                        _isPlaying ? 'SIMULASI AKTIF' : 'PAUSED (CHECKPOINT)',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // Safety Score Badge
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.shield_rounded,
                            color: _safetyScore >= 60 ? Colors.greenAccent : Colors.redAccent,
                            size: 16,
                          ),
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

          // Area Log Kejadian & Kontrol
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Catatan & Riwayat Kejadian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('${widget.skenario.checkpoints.length} Checkpoints', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Daftar Log Kejadian
                  Expanded(
                    child: ListView.builder(
                      itemCount: _eventLogs.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F9FC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(
                            _eventLogs[index],
                            style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.3),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),
                  // Progress Bar Waktu
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _totalSeconds > 0 ? (_currentSeconds / _totalSeconds) : 0,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Tombol Keluar
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.exit_to_app_rounded, size: 18),
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
