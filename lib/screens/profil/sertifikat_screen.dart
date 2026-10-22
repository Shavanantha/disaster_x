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
  double _rataRata = 0;

  static const Color navy = Color(0xFF142744);
  static const Color blue = Color(0xFF315DAB);
  static const Color red = Color(0xFFD92535);
  static const Color gold = Color(0xFFD6AD5B);
  static const Color cream = Color(0xFFFFFEFA);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prof = await StorageService.getUserProfile();
    final avg = await StorageService.getRataRataNilai();

    if (!mounted) return;

    setState(() {
      _profile = prof;
      _rataRata = avg;
    });
  }

  String get _predikat {
    if (_rataRata >= 90) return 'UNGGUL';
    if (_rataRata >= 80) return 'SANGAT BAIK';
    if (_rataRata >= 70) return 'BAIK';
    if (_rataRata >= 60) return 'CUKUP';
    return 'TERUS BELAJAR';
  }

  Color get _predikatColor {
    if (_rataRata >= 70) return const Color(0xFF168566);
    return const Color(0xFFD18A28);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F3F9),
        foregroundColor: navy,
        elevation: 0,
        title: const Text(
          'Sertifikat Kelulusan',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: _profile == null
          ? const Center(
              child: CircularProgressIndicator(color: blue),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 28),
              child: Column(
                children: [
                  _buildCertificate(),
                  const SizedBox(height: 20),
                  _buildScoreInfo(),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Fitur ekspor PDF atau gambar belum diaktifkan.',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.download_rounded),
                      label: const Text(
                        'Unduh Sertifikat PDF / Gambar',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: red,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: red.withValues(alpha: 0.25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCertificate() {
    final profile = _profile!;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFE8A6),
            gold,
            Color(0xFFB98632),
            Color(0xFFFFE8A6),
          ],
        ),
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.14),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: cream,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: gold, width: 1.2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              // Background dekoratif
              Positioned.fill(
                child: CustomPaint(
                  painter: _CertificateBackgroundPainter(),
                ),
              ),

              // Pita merah-biru sudut atas
              Positioned(
                top: 0,
                left: 0,
                child: _buildRibbon(isTop: true),
              ),

              // Pita merah-biru sudut bawah
              Positioned(
                bottom: 0,
                right: 0,
                child: _buildRibbon(isTop: false),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(17, 24, 17, 22),
                child: Column(
                  children: [
                    // Logo asli DISASTER-X
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/images/disasterlogo.png',
                            height: 48,
                            fit: BoxFit.contain,
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Flexible(
                          child: Text(
                            'MOBILE DISASTER\nMITIGATION ACADEMY',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: navy,
                              fontSize: 8,
                              height: 1.6,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Emblem
                    Container(
                      width: 69,
                      height: 69,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [blue, navy],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: gold, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: navy.withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shield_rounded,
                            color: Color(0xFFFFD878),
                            size: 33,
                          ),
                          Text(
                            'DSX',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 8,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'SERTIFIKAT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 27,
                        height: 1.2,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.1,
                        color: navy,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'KESIAPSIAGAAN BENCANA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.3,
                        color: red,
                      ),
                    ),

                    const SizedBox(height: 17),

                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: gold, thickness: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: gold,
                            size: 17,
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: gold, thickness: 1),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Diberikan dengan bangga kepada',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF7D8796),
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      profile.nama.trim().isEmpty
                          ? 'Nama Peserta'
                          : profile.nama.trim(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        height: 1.35,
                      ),
                    ),

                    Container(
                      height: 2,
                      width: 115,
                      margin: const EdgeInsets.only(top: 9, bottom: 11),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [gold, Color(0xFFFFE8A6), gold],
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),

                    Text(
                      [
                        if (profile.nim.trim().isNotEmpty)
                          'NIM: ${profile.nim.trim()}',
                        if (profile.sekolah.trim().isNotEmpty)
                          profile.sekolah.trim(),
                        if (profile.kelas.trim().isNotEmpty)
                          'Kelas ${profile.kelas.trim()}',
                      ].join('  •  '),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF68768B),
                        fontSize: 10,
                        height: 1.7,
                      ),
                    ),

                    const SizedBox(height: 19),

                    const Text(
                      'Telah mengikuti pembelajaran kesiapsiagaan dan '
                      'mitigasi bencana melalui materi, kuis evaluasi, '
                      'serta simulasi interaktif DISASTER-X.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF47556A),
                        fontSize: 11,
                        height: 1.8,
                      ),
                    ),

                    const SizedBox(height: 19),

                    // Panel skor premium
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [navy, Color(0xFF254D82)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: gold, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: navy.withValues(alpha: 0.15),
                            blurRadius: 9,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.emoji_events_rounded,
                            color: Color(0xFFFFD166),
                            size: 35,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'RATA-RATA SKOR',
                                  style: TextStyle(
                                    color: Color(0xFFD9E5FA),
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.7,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${_rataRata.toStringAsFixed(0)} / 100',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 42,
                            color: Colors.white24,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'PREDIKAT',
                                  style: TextStyle(
                                    color: Color(0xFFD9E5FA),
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.7,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _predikat,
                                  style: const TextStyle(
                                    color: Color(0xFFFFD166),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 21),

                    const Text(
                      'DISASTER-X  •  BELAJAR SIAP, BERTINDAK TEPAT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: navy,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 17),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.verified_user_rounded,
                                color: blue,
                                size: 28,
                              ),
                              SizedBox(height: 5),
                              Text(
                                'DISASTER-X',
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                'Digital Learning',
                                style: TextStyle(
                                  color: Color(0xFF8290A3),
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.workspace_premium_rounded,
                              color: gold,
                              size: 28,
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'DIGITAL CERTIFICATE',
                              style: TextStyle(
                                color: navy,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.4,
                              ),
                            ),
                            Text(
                              'Skor: ${_rataRata.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Color(0xFF8290A3),
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRibbon({required bool isTop}) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          Positioned(
            top: isTop ? -33 : null,
            bottom: isTop ? null : -33,
            left: isTop ? -33 : null,
            right: isTop ? null : -33,
            child: Transform.rotate(
              angle: isTop ? -0.785398 : 2.35619,
              child: Container(
                width: 145,
                height: 25,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [navy, blue],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: navy.withValues(alpha: 0.15),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: isTop ? 0 : null,
            bottom: isTop ? null : 0,
            left: isTop ? 0 : null,
            right: isTop ? null : 0,
            child: Transform.rotate(
              angle: isTop ? -0.785398 : 2.35619,
              child: Container(
                width: 115,
                height: 13,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [red, Color(0xFFAA1726)],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE4EAF3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0FF),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.analytics_rounded,
              color: blue,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pencapaian Belajarmu',
                  style: TextStyle(
                    color: navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Rata-rata nilai dari data yang tersimpan',
                  style: TextStyle(
                    color: Color(0xFF8290A3),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _rataRata.toStringAsFixed(0),
            style: TextStyle(
              color: _predikatColor,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificateBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final goldPaint = Paint()
      ..color = const Color(0xFFD6AD5B).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final bluePaint = Paint()
      ..color = const Color(0xFF315DAB).withValues(alpha: 0.055)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Garis kontur dekoratif di bagian atas dan bawah.
    for (int i = 0; i < 7; i++) {
      final offset = i * 9.0;

      final topPath = Path()
        ..moveTo(size.width * 0.35 + offset, 0)
        ..quadraticBezierTo(
          size.width * 0.65,
          35 + offset,
          size.width,
          12 + offset,
        );

      canvas.drawPath(topPath, bluePaint);

      final bottomPath = Path()
        ..moveTo(0, size.height - offset)
        ..quadraticBezierTo(
          size.width * 0.35,
          size.height - 45 - offset,
          size.width * 0.65,
          size.height - 12 - offset,
        );

      canvas.drawPath(bottomPath, goldPaint);
    }

    // Pola titik halus pada area samping.
    final dotPaint = Paint()
      ..color = const Color(0xFF315DAB).withValues(alpha: 0.07);

    for (int row = 0; row < 7; row++) {
      for (int col = 0; col < 4; col++) {
        canvas.drawCircle(
          Offset(
            size.width - 16 - col * 8.0,
            size.height * 0.34 + row * 8.0,
          ),
          1.2,
          dotPaint,
        );

        canvas.drawCircle(
          Offset(
            16 + col * 8.0,
            size.height * 0.68 + row * 8.0,
          ),
          1.2,
          dotPaint,
        );
      }
    }

      // Bingkai dalam.
    final borderPaint = Paint()
      ..color = const Color(0xFFD6AD5B).withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          8,
          8,
          size.width - 16,
          size.height - 16,
        ),
        const Radius.circular(10),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

