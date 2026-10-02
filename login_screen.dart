import 'package:flutter/material.dart';
import 'main_navigation.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  // Logo / Ikon Aplikasi
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        shape: BoxShape.circle,
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
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Selamat Datang!\nSiapkan dirimu untuk situasi darurat.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Tombol Google
                  _buildLoginButton(
                    icon: Icons.g_mobiledata_rounded,
                    label: 'Masuk dengan Google',
                    color: Colors.black87,
                    isOutlined: true,
                    onPressed: () => _masukKeBeranda(context),
                  ),
                  const SizedBox(height: 12),

                  // Tombol Apple
                  _buildLoginButton(
                    icon: Icons.apple_rounded,
                    label: 'Masuk dengan Apple',
                    color: Colors.black87,
                    isOutlined: true,
                    onPressed: () => _masukKeBeranda(context),
                  ),
                  const SizedBox(height: 12),

                  // Tombol Email
                  _buildLoginButton(
                    icon: Icons.mail_outline_rounded,
                    label: 'Masuk dengan Email',
                    color: Colors.black87,
                    isOutlined: true,
                    onPressed: () => _masukKeBeranda(context),
                  ),
                  const SizedBox(height: 20),

                  // Pemisah / Divider
                  Row(
                    children: const [
                      Expanded(child: Divider(thickness: 1, color: Color(0xFFEEEEEE))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'atau',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                      Expanded(child: Divider(thickness: 1, color: Color(0xFFEEEEEE))),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Mode Tamu
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _masukKeBeranda(context),
                    child: const Text(
                      'Masuk sebagai Tamu',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Teks Daftar (Menggunakan Wrap agar tidak overflow)
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: [
                        const Text(
                          'Belum punya akun?',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Halaman pendaftaran akun')),
                            );
                          },
                          child: const Text(
                            'Daftar Sekarang',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _masukKeBeranda(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigation()),
    );
  }

  Widget _buildLoginButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isOutlined,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}