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
  bool _useVideoPlayerMode = true; // Default langsung video MP4
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  // Animasi Controller untuk efek visual simulasi (Canvas 2D)
  late AnimationController _shakeAnimController;
  late AnimationController _pulseAnimController;
  late AnimationController _waveAnimController;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.skenario.totalDetik;
    _eventLogs.add(widget.skenario.prolog);

    // Inisialisasi controller animasi canvas
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

    // Inisialisasi Video Player
    _initVideoPlayer();

    _startSimulation();
  }

  void _initVideoPlayer() {
    _videoController = VideoPlayerController.asset('assets/videos/gempa_simulasi.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
          });
          if (_isPlaying) {
            _videoController?.play();
          }
        }
      }).catchError((error) {
        debugPrint("Video Player Error: $error");
      });
  }

  void _startSimulation() {
    setState(() {
      _isPlaying = true;
    });

    if (_useVideoPlayerMode && _videoController != null && _isVideoInitialized) {
      _videoController?.play();
    }

    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_currentSeconds >= _totalSeconds) {
        _timer?.cancel();
        _shakeAnimController.stop();
        _videoController?.pause();
        _onSimulationCompleted();
      } else {
        // Update detik berdasarkan posisi riil video MP4
        if (_useVideoPlayerMode && _videoController != null && _isVideoInitialized) {
          final videoPos = _videoController!.value.position.inSeconds;
          if (videoPos != _currentSeconds) {
            setState(() {
              _currentSeconds = videoPos;
            });
          }
        } else {
          setState(() {
            _currentSeconds++;
          });
        }

        // Cek Trigger Checkpoint
        for (final cp in widget.skenario.checkpoints) {
          if (_currentSeconds >= cp.detik && !_triggeredCheckpoints.contains(cp.detik)) {
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

    if (_useVideoPlayerMode && _videoController != null && _isVideoInitialized) {
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
                    ? 'Luar biasa! Keputusan keselamatan yang kamu ambil tepat sasaran.'
                    : 'Skor keselamatan di bawah batas aman (60%). Coba pelajari materi dan ulangi lagi.',
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
                if (_videoController != null && _isVideoInitialized) {
                  _videoController?.seekTo(Duration.zero);
                }
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
    final progress = _totalSeconds > 0
        ? (_currentSeconds / _totalSeconds).clamp(0.0, 1.0).toDouble()
        : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF172B4D),
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 4,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.skenario.judul,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            const Text(
              'SIMULASI TANGGAP BENCANA',
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 1.0,
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<bool>(
            tooltip: 'Mode tampilan',
            icon: const Icon(Icons.tune_rounded, size: 21),
            onSelected: (useVideo) {
              setState(() {
                _useVideoPlayerMode = useVideo;
              });
              if (useVideo) {
                if (_videoController != null && _isVideoInitialized) {
                  _videoController!.seekTo(Duration(seconds: _currentSeconds));
                  if (_isPlaying) _videoController!.play();
                }
              } else {
                _videoController?.pause();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<bool>(
                value: true,
                child: Row(
                  children: [
                    Icon(Icons.videocam_rounded, size: 19),
                    SizedBox(width: 10),
                    Text('Video MP4'),
                  ],
                ),
              ),
              PopupMenuItem<bool>(
                value: false,
                child: Row(
                  children: [
                    Icon(Icons.animation_rounded, size: 19),
                    SizedBox(width: 10),
                    Text('Animasi Canvas'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                color: const Color(0xFF10131A),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_useVideoPlayerMode)
                      (_isVideoInitialized && _videoController != null)
                          ? Center(
                              child: AspectRatio(
                                aspectRatio: _videoController!.value.aspectRatio,
                                child: VideoPlayer(_videoController!),
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Color(0xFF78A6FF),
                                  strokeWidth: 3,
                                ),
                                SizedBox(height: 14),
                                Text(
                                  'Menyiapkan simulasi...',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                    else
                      _buildAnimatedCanvas(),
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: _isPlaying
                              ? const Color(0xFFE84D5B)
                              : const Color(0xFFE0A12D),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isPlaying
                                  ? Icons.fiber_manual_record_rounded
                                  : Icons.pause_circle_filled_rounded,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _isPlaying ? 'SEDANG BERJALAN' : 'DIJEDA',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xE8172438),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.shield_rounded,
                              color: Color(0xFFFFC857),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'SAFETY SCORE',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  '$_safetyScore / 100',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!_isPlaying && _currentSeconds < _totalSeconds)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.62),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.pause_rounded, color: Colors.white, size: 17),
                            SizedBox(width: 6),
                            Text(
                              'Menunggu keputusanmu',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 4,
                        color: Colors.white.withValues(alpha: 0.15),
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: progress,
                          child: Container(color: const Color(0xFF78A6FF)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 17, 18, 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 37,
                          height: 37,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF1FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.radar_rounded,
                            color: Color(0xFF3478F6),
                            size: 21,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pusat Informasi',
                                style: TextStyle(
                                  color: Color(0xFF172B4D),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Pantau perkembangan kejadian',
                                style: TextStyle(
                                  color: Color(0xFF8290A4),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F4F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_formatTime(_currentSeconds)} / ${_formatTime(_totalSeconds)}',
                            style: const TextStyle(
                              color: Color(0xFF536783),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Text(
                          'CATATAN KEJADIAN',
                          style: TextStyle(
                            color: Color(0xFF8290A4),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _isPlaying
                                ? const Color(0xFF36B37E)
                                : const Color(0xFFE0A12D),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _isPlaying ? 'Live' : 'Menunggu',
                          style: const TextStyle(
                            color: Color(0xFF536783),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _eventLogs.isEmpty
                          ? const Center(
                              child: Text(
                                'Belum ada catatan kejadian.',
                                style: TextStyle(
                                  color: Color(0xFF8290A4),
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _eventLogs.length,
                              itemBuilder: (context, index) {
                                final isLatest = index == 0;
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 7),
                                  padding: const EdgeInsets.all(11),
                                  decoration: BoxDecoration(
                                    color: isLatest
                                        ? const Color(0xFFF1F5FC)
                                        : const Color(0xFFF8FAFD),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isLatest
                                          ? const Color(0xFFDCE7FA)
                                          : const Color(0xFFEDF1F6),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        isLatest
                                            ? Icons.notifications_active_rounded
                                            : Icons.check_circle_outline_rounded,
                                        color: isLatest
                                            ? const Color(0xFF3478F6)
                                            : const Color(0xFF9AA7B8),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _eventLogs[index],
                                          style: TextStyle(
                                            color: const Color(0xFF34445D),
                                            fontSize: 11,
                                            height: 1.45,
                                            fontWeight: isLatest
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        const Icon(
                          Icons.flag_rounded,
                          color: Color(0xFF3478F6),
                          size: 15,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Progres simulasi',
                          style: TextStyle(
                            color: Color(0xFF536783),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(
                            color: Color(0xFF172B4D),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: const Color(0xFFE9EEF6),
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                        minHeight: 5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 43,
                      child: OutlinedButton.icon(
                        onPressed: _showExitConfirmation,
                        icon: const Icon(Icons.close_rounded, size: 17),
                        label: const Text(
                          'Keluar dari Simulasi',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF536783),
                          side: const BorderSide(color: Color(0xFFE0E6EF)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _showExitConfirmation() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Keluar dari simulasi?',
          style: TextStyle(
            color: Color(0xFF172B4D),
            fontWeight: FontWeight.w800,
            fontSize: 17,
          ),
        ),
        content: const Text(
          'Progres simulasi saat ini mungkin belum selesai. Kamu yakin ingin keluar?',
          style: TextStyle(fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Lanjut Belajar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3478F6),
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );

    if (shouldExit == true && mounted) {
      Navigator.pop(context);
    }
  }

  Widget _buildAnimatedCanvas() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.apartment_rounded, size: 80, color: Colors.white70),
        SizedBox(height: 14),
        Text('Simulasi Interaktif', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}