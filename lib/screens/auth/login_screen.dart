import 'package:flutter/material.dart';
import '../../models/user_profile_model.dart';
import '../../services/storage_service.dart';
import '../main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _namaController = TextEditingController(text: 'Shava Phiyan Anantha');
  final _nimController = TextEditingController(text: '2413025047');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    super.dispose();
  }

  Future<void> _masukDenganIdentitas() async {
    if (_formKey.currentState!.validate()) {
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    }
  }

  Future<void> _masukSebagaiTamu() async {
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  // Logo Ikon Aplikasi
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withValues(alpha: 0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        size: 48,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'DISASTER-X',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Sistem Edukasi & Simulasi Mitigasi Bencana\nSiapkan dirimu menghadapi situasi darurat.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Form Identitas Mahasiswa
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Identitas Peserta / Siswa',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _namaController,
                            decoration: InputDecoration(
                              labelText: 'Nama Lengkap Mahasiswa',
                              hintText: 'Contoh: Shava Phiyan Anantha',
                              prefixIcon: const Icon(Icons.person_outline, size: 20),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            validator: (val) => val == null || val.trim().isEmpty ? 'Nama wajib diisi' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _nimController,
                            decoration: InputDecoration(
                              labelText: 'NIM / Nomor Induk Mahasiswa',
                              hintText: 'Contoh: 2413025047',
                              prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            validator: (val) => val == null || val.trim().isEmpty ? 'NIM wajib diisi' : null,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: _masukDenganIdentitas,
                              icon: const Icon(Icons.login_rounded, size: 20),
                              label: const Text('Masuk ke Aplikasi', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Mode Tamu (Guest)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _masukSebagaiTamu,
                    icon: const Icon(Icons.person_pin_outlined, color: Colors.black87, size: 20),
                    label: const Text(
                      'Masuk Cepat sebagai Tamu (Guest)',
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Pemisah / Divider
                  Row(
                    children: const [
                      Expanded(child: Divider(thickness: 1, color: Color(0xFFEEEEEE))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'opsi akun lain',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ),
                      Expanded(child: Divider(thickness: 1, color: Color(0xFFEEEEEE))),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Opsi Google Login
                  _buildSocialButton(
                    icon: Icons.g_mobiledata_rounded,
                    label: 'Masuk Akun Google Kampus',
                    onPressed: () {
                      _namaController.text = 'Shava Phiyan (Google)';
                      _masukDenganIdentitas();
                    },
                  ),

                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Tugas Mata Kuliah Mobile Programming\n© 2026 DISASTER-X Indonesia',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black87, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
