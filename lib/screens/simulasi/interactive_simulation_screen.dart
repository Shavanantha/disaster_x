import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../models/simulasi_model.dart';
import '../../services/storage_service.dart';

class InteractiveSimulationScreen extends StatefulWidget {
  final SkenarioSimulasi skenario;

  const InteractiveSimulationScreen({
    super.key,
    required this.skenario,
  });

  @override
  State<InteractiveSimulationScreen> createState() => _InteractiveSimulationScreenState();
}

class _InteractiveSimulationScreenState extends State<InteractiveSimulationScreen> with TickerProviderStateMixin {
  late int _totalSeconds;
  int _currentSeconds = 0;
  Timer? _timer;
  bool _isPlaying = false;
  int _safetyScore = 50; // Skor awal
  final List<String> _eventLogs = [];
  final Set<int> _triggeredCheckpoints = {};

  // Mode Tampilan: Animasi Interaktif (Canvas) vs Video Player MP4
  bool _useVideoPlayerMode = false;
  VideoPlayerController? _videoController;

  // Animasi Controller untuk efek visual simulasi
  late AnimationController _shakeAnimController; // Efek guncangan gempa
  late AnimationController _pulseAnimController; // Efek kedip sirine darurat
  late AnimationController _waveAnimController;  // Efek ombak air banjir

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.skenario.totalDetik;
    _eventLogs.add(widget.skenario.prolog);

    // Inisialisasi controller animasi
    _shakeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _pulseAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _waveAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _startSimulation();
  }

  void _startSimulation() {
    setState(() {
      _isPlaying = true;
    });

    if (widget.skenario.id == 'gempa_kelas' && _currentSeconds >= 12 && _currentSeconds < 32) {
      _shakeAnimController.repeat(reverse: true);
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds >= _totalSeconds) {
        _timer?.cancel();
        _shakeAnimController.stop();
        _onSimulationCompleted();
      } else {
        setState(() {
          _currentSeconds++;
        });

        // Trigger animasi gempa saat gempa aktif
        if (widget.skenario.id == 'gempa_kelas') {
          if (_currentSeconds >= 12 && _currentSeconds <= 30) {
            if (!_shakeAnimController.isAnimating) {
              _shakeAnimController.repeat(reverse: true);
            }
          } else {
            _shakeAnimController.stop();
          }
        }

        // Cek checkpoint
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
    _shakeAnimController.stop();
    _videoController?.pause();

    setState(() {
      _isPlaying = false;
      _eventLogs.insert(0, '⚠️ [CHECKPOINT TERCAPAI]: ${checkpoint.narasiSituasi}');
    });

    _showDecisionBottomSheet(checkpoint);
  }

  void _resumeSimulation() {
    setState(() {
      _isPlaying = true;
    });

    if (_useVideoPlayerMode && _videoController != null && _videoController!.value.isInitialized) {
      _videoController?.play();
    }

    _startSimulation();
  }

  Future<void> _onSimulationCompleted() async {
    setState(() {
      _isPlaying = false;
      _eventLogs.insert(0, '🎉 ${widget.skenario.pesanSelesai}');
    });

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
                isPassed ? 'Simulasi Berhasil Diselesaikan!' : 'Evaluasi Kesiapsiagaan',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                isPassed
                    ? 'Luar biasa! Keputusan keselamatan yang kamu ambil tepat sasaran dan mengurangi risiko bencana.'
                    : 'Skor keselamatan di bawah batas aman (60%). Jangan panik, pelajari kembali modul materi dan coba lagi.',
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
                    const Text('Safety Readiness Score Akhir', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                setState(() {
                  _currentSeconds = 0;
                  _safetyScore = 50;
                  _triggeredCheckpoints.clear();
                  _eventLogs.clear();
                  _eventLogs.add(widget.skenario.prolog);
                });
                _startSimulation();
              },
              child: const Text('Ulangi Simulasi'),
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
              child: const Text('Selesai & Keluar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeAnimController.dispose();
    _pulseAnimController.dispose();
    _waveAnimController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Color(widget.skenario.warnaHex);

    return Scaffold(
      backgroundColor: const Color(0xFF161622),
      appBar: AppBar(
        title: Text(widget.skenario.judul, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF161622),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Switch mode antara Animasi Canvas Interaktif dan Video Player MP4
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.white70),
            icon: Icon(_useVideoPlayerMode ? Icons.animation_rounded : Icons.videocam_rounded, size: 18),
            label: Text(_useVideoPlayerMode ? 'Animasi Canvas' : 'Video MP4', style: const TextStyle(fontSize: 11)),
            onPressed: () {
              setState(() {
                _useVideoPlayerMode = !_useVideoPlayerMode;
              });
              if (_useVideoPlayerMode && _videoController == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mode Video MP4 aktif. Jika belum ada file mp4 lokal, kanvas simulasi animasi tetap menjadi acuan visual.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ================= VIEWPORT ANIMASI INTERAKTIF =================
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Kanvas Animasi Grafis Dinamis Berdasarkan Bencana
                  _buildAnimatedCanvas(),

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
                        _isPlaying ? 'ANIMASI AKTIF (PLAYING)' : 'PAUSED (AUTO-CHECKPOINT)',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // Floating Safety Score
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
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

          // ================= AREA LOG KEJADIAN & KONTROL =================
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
                      const Text('Catatan & Status Kejadian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Detik 00:${_currentSeconds.toString().padLeft(2, '0')} / 00:$_totalSeconds',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Daftar Log Kejadian Skenario
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

                  // Tombol Keluar dari Simulasi
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

  /// Membangun kanvas visual animasi sesuai jenis bencana skenario
  Widget _buildAnimatedCanvas() {
    final String scenarioId = widget.skenario.id;

    if (scenarioId == 'gempa_kelas') {
      return _buildGempaAnimation();
    } else if (scenarioId == 'kebakaran_lab') {
      return _buildKebakaranAnimation();
    } else {
      return _buildBanjirAnimation();
    }
  }

  // ================= ANIMASI SKENARIO 1: GEMPA BUMI =================
  Widget _buildGempaAnimation() {
    final bool isQuakeActive = _currentSeconds >= 12 && _currentSeconds <= 30;
    final bool isEvacuating = _currentSeconds > 30;

    return AnimatedBuilder(
      animation: _shakeAnimController,
      builder: (context, child) {
        // Efek getar layar menggunakan translate offsetX & offsetY
        final double shakeOffset = isQuakeActive ? (_shakeAnimController.value * 12.0 - 6.0) : 0.0;

        return Transform.translate(
          offset: Offset(shakeOffset, isQuakeActive ? (shakeOffset / 2) : 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Efek Lampu Darurat Berkedip
              if (isQuakeActive)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _pulseAnimController,
                      child: const Icon(Icons.emergency_rounded, color: Colors.amber, size: 28),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'PERINGATAN: GUNCANGAN GEMPA AKTIF',
                      style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1),
                    ),
                  ],
                ),
              const SizedBox(height: 14),

              // Ikon Situasi Ruang Kelas
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isQuakeActive ? Colors.redAccent.withValues(alpha: 0.15) : Colors.white10,
                    ),
                  ),
                  Icon(
                    isEvacuating
                        ? Icons.directions_run_rounded
                        : (isQuakeActive ? Icons.table_restaurant_rounded : Icons.apartment_rounded),
                    size: 80,
                    color: isQuakeActive ? Colors.amberAccent : Colors.white70,
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Text(
                isEvacuating
                    ? 'Tahap Evakuasi: Menuju Tangga Darurat'
                    : (isQuakeActive ? '⚠️ Puing Berjatuhan! Berlindung di Bawah Meja' : 'Suasana Pembelajaran di Kelas (Lantai 3)'),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                'Skenario: Ruang Kelas SMA • Animasi 2D Interaktif',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= ANIMASI SKENARIO 2: KEBAKARAN LAB =================
  Widget _buildKebakaranAnimation() {
    final bool isFireActive = _currentSeconds >= 12;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isFireActive)
          FadeTransition(
            opacity: _pulseAnimController,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.local_fire_department_rounded, color: Colors.redAccent, size: 24),
                SizedBox(width: 6),
                Text(
                  'BAHAYA API & ASAP TEBAL DI LABORATORIUM',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        const SizedBox(height: 14),

        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFireActive ? Colors.deepOrange.withValues(alpha: 0.2) : Colors.white10,
              ),
            ),
            Icon(
              isFireActive ? Icons.local_fire_department_rounded : Icons.computer_rounded,
              size: 80,
              color: isFireActive ? Colors.deepOrangeAccent : Colors.white70,
            ),
          ],
        ),
        const SizedBox(height: 14),

        Text(
          isFireActive
              ? 'Kepulan Asap Karbon Monoksida • Merangkak Rendah!'
              : 'Praktikum Komputer Berjalan Normal',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Text(
          'Skenario: Korsleting Server Lab Komputer • Animasi 2D',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
        ),
      ],
    );
  }

  // ================= ANIMASI SKENARIO 3: BANJIR TANGGUL =================
  Widget _buildBanjirAnimation() {
    final bool isFloodActive = _currentSeconds >= 14;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isFloodActive)
          FadeTransition(
            opacity: _pulseAnimController,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.waves_rounded, color: Colors.lightBlueAccent, size: 24),
                SizedBox(width: 6),
                Text(
                  'DEBIT AIR TANGGUL MELUAP CEPAT',
                  style: TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        const SizedBox(height: 14),

        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFloodActive ? Colors.blue.withValues(alpha: 0.2) : Colors.white10,
              ),
            ),
            Icon(
              isFloodActive ? Icons.tsunami_rounded : Icons.house_rounded,
              size: 80,
              color: isFloodActive ? Colors.lightBlueAccent : Colors.white70,
            ),
          ],
        ),
        const SizedBox(height: 14),

        Text(
          isFloodActive
              ? 'Arus Deras Memasuki Rumah • Evakuasi Vertikal!'
              : 'Hujan Lebat di Kawasan Pemukiman Warga',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Text(
          'Skenario: Tanggul Jebol & Banjir Bandang • Animasi 2D',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
        ),
      ],
    );
  }
}
