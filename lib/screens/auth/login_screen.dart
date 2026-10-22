import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/storage_service.dart';
import '../../models/user_profile_model.dart';
import '../main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = false;
  bool _showForm = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();

    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) {
        setState(() {
          _showForm = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _masukDenganIdentitas() async {
    if (!_formKey.currentState!.validate()) return;

    HapticFeedback.lightImpact();

    setState(() => _isLoading = true);

    final profile = UserProfile(
      nama: _namaController.text.trim(),
      nim: _nimController.text.trim(),
      sekolah: 'Universitas Lampung',
      kelas: 'Mobile Programming A',
      isGuest: false,
    );

    await StorageService.saveUserProfile(profile);
    await StorageService.setLoggedIn(true);

    if (!mounted) return;

    setState(() => _isLoading = false);

    _goToMain();
  }

  Future<void> _masukSebagaiTamu() async {
    HapticFeedback.lightImpact();

    setState(() => _isLoading = true);

    const guestProfile = UserProfile(
      nama: 'Siswa Tamu (Guest)',
      nim: 'GUEST-001',
      sekolah: 'Umum',
      kelas: 'Peserta Simulasi',
      isGuest: true,
    );

    await StorageService.saveUserProfile(guestProfile);
    await StorageService.setLoggedIn(true);

    if (!mounted) return;

    setState(() => _isLoading = false);

    _goToMain();
  }

  Future<void> _masukDenganGoogle() async {
    HapticFeedback.lightImpact();

    setState(() => _isLoading = true);

    // Saat ini masih berupa login simulasi.
    // Google OAuth asli bisa ditambahkan kemudian.
    const googleProfile = UserProfile(
      nama: 'Pengguna Google',
      nim: 'GOOGLE-001',
      sekolah: 'Universitas Lampung',
      kelas: 'Mobile Programming A',
      isGuest: false,
    );

    await StorageService.saveUserProfile(googleProfile);
    await StorageService.setLoggedIn(true);

    if (!mounted) return;

    setState(() => _isLoading = false);

    _goToMain();
  }

  void _goToMain() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainNavigation(),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 450),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF9AA1B2),
        fontSize: 14,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF52627A),
        size: 21,
      ),
      filled: true,
      fillColor: const Color(0xFFF7F8FB),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFE8EBF1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFF243B64),
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required Widget icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: _isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF27354D),
          side: const BorderSide(
            color: Color(0xFFE2E6ED),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: SafeArea(
        child: Stack(
          children: [
            // =========================
            // BACKGROUND DECORATION
            // =========================
            Positioned(
              top: -90,
              right: -70,
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF0FA).withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              bottom: -100,
              left: -80,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFECE9).withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // =========================
            // MAIN CONTENT
            // =========================
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 430,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // =========================
                          // LOGO
                          // =========================
                          Center(
                            child: Container(
                              width: 125,
                              height: 125,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF243B64)
                                        .withValues(alpha: 0.10),
                                    blurRadius: 25,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/disasterlogo.png',
                                fit: BoxFit.contain,
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.shield_rounded,
                                    size: 65,
                                    color: Color(0xFF243B64),
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // =========================
                          // WELCOME TEXT
                          // =========================
                          const Text(
                            'Selamat Datang 👋',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1F2A3D),
                              letterSpacing: -0.5,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'Yuk belajar dan berlatih menghadapi\nsituasi darurat dengan lebih siap.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5,
                              height: 1.5,
                              color: Color(0xFF7A8496),
                            ),
                          ),

                          const SizedBox(height: 25),

                          // =========================
                          // LOGIN CARD
                          // =========================
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: _showForm ? 1 : 0,
                            child: AnimatedSlide(
                              duration: const Duration(milliseconds: 500),
                              offset: _showForm
                                  ? Offset.zero
                                  : const Offset(0, 0.05),
                              curve: Curves.easeOut,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withValues(alpha: 0.045),
                                      blurRadius: 25,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Text(
                                        'Masuk dengan Identitas',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF27354D),
                                        ),
                                      ),

                                      const SizedBox(height: 5),

                                      const Text(
                                        'Isi data berikut untuk melanjutkan.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8A93A3),
                                        ),
                                      ),

                                      const SizedBox(height: 18),

                                      // NAMA
                                      TextFormField(
                                        controller: _namaController,
                                        textInputAction:
                                            TextInputAction.next,
                                        decoration: _inputDecoration(
                                          hint: 'Nama Lengkap',
                                          icon: Icons.person_outline_rounded,
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Nama lengkap wajib diisi';
                                          }
                                          return null;
                                        },
                                      ),

                                      const SizedBox(height: 12),

                                      // NIM
                                      TextFormField(
                                        controller: _nimController,
                                        keyboardType: TextInputType
                                            .number,
                                        textInputAction:
                                            TextInputAction.done,
                                        decoration: _inputDecoration(
                                          hint: 'NIM / ID',
                                          icon: Icons.badge_outlined,
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'NIM / ID wajib diisi';
                                          }
                                          return null;
                                        },
                                        onFieldSubmitted: (_) {
                                          if (!_isLoading) {
                                            _masukDenganIdentitas();
                                          }
                                        },
                                      ),

                                      const SizedBox(height: 18),

                                      // =========================
                                      // MAIN BUTTON
                                      // =========================
                                      SizedBox(
                                        height: 52,
                                        child: ElevatedButton(
                                          onPressed: _isLoading
                                              ? null
                                              : _masukDenganIdentitas,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF243B64),
                                            foregroundColor: Colors.white,
                                            disabledBackgroundColor:
                                                const Color(0xFF9AA5B8),
                                            elevation: 0,
                                            shape:
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                15,
                                              ),
                                            ),
                                          ),
                                          child: _isLoading
                                              ? const SizedBox(
                                                  width: 21,
                                                  height: 21,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.3,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                  children: [
                                                    Text(
                                                      'Masuk Sekarang',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward_rounded,
                                                      size: 19,
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 17),

                          // =========================
                          // DIVIDER
                          // =========================
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: Color(0xFFE1E5EC),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  'atau',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: Color(0xFFE1E5EC),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // =========================
                          // GUEST
                          // =========================
                          SizedBox(
                            height: 50,
                            child: OutlinedButton.icon(
                              onPressed:
                                  _isLoading ? null : _masukSebagaiTamu,
                              icon: const Icon(
                                Icons.person_outline_rounded,
                                size: 20,
                              ),
                              label: const Text(
                                'Lanjut sebagai Tamu',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    const Color(0xFF35445C),
                                side: const BorderSide(
                                  color: Color(0xFFDDE2EA),
                                ),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 11),

                          // =========================
                          // GOOGLE
                          // =========================
                          _buildSocialButton(
                            text: 'Lanjut dengan Google',
                            onPressed: _masukDenganGoogle,
                            icon: Container(
                              width: 21,
                              height: 21,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'G',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF4285F4),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          // =========================
                          // FOOTER
                          // =========================
                          const Text(
                            'DISASTER-X • Learn • Simulate • Be Ready',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                              color: Color(0xFF9AA1AE),
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            'Interactive Disaster Preparedness',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9.5,
                              color: Color(0xFFB0B6C1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}