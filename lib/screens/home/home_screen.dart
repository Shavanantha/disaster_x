import 'package:flutter/material.dart';
import '../../models/bencana_model.dart';
import '../../models/user_profile_model.dart';
import '../../services/dummy_data.dart';
import '../../services/storage_service.dart';
import '../../widgets/icon_helper.dart';
import '../profil/nomor_darurat_screen.dart';
import '../profil/riwayat_nilai_screen.dart';
import '../profil/tas_siaga_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onTabChange;

  const HomeScreen({
    super.key,
    this.onTabChange,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserProfile _profile = const UserProfile(
    nama: 'Shava Phiyan Anantha',
    nim: '2413025047',
    sekolah: 'Universitas Lampung',
    kelas: 'Mobile Programming A',
  );

  double _progress = 0.85;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    final prof = await StorageService.getUserProfile();
    final prog = await StorageService.getOverallProgress();
    if (mounted) {
      setState(() {
        _profile = prof;
        _progress = prog > 0 ? prog : 0.4;
      });
    }
  }

  void _showNewsDetail(BeritaTips tips) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tips.kategori,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      Text(tips.tanggal, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tips.judul,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                  const SizedBox(height: 14),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    tips.konten,
                    style: const TextStyle(fontSize: 13, height: 1.55, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Tutup Artikel'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final progressPercent = (_progress * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Beranda DISASTER-X', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            tooltip: 'Nomor Darurat',
            icon: const Icon(Icons.emergency_outlined, color: Colors.redAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NomorDaruratScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Pengguna Dinamis
            Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFFFFEBEE),
                  child: Icon(Icons.person, size: 30, color: Colors.redAccent),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, ${_profile.nama.split(" ").first}!',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Level: ${progressPercent >= 80 ? "Siaga Utama" : (progressPercent >= 50 ? "Siaga Madya" : "Siaga Pratama")}',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Tas Siaga',
                  icon: const Icon(Icons.backpack_outlined, color: Colors.black87),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TasSiagaScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Card Progress Belajar Dinamis
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Progress Belajar & Kesiapan', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
                      Text(
                        '$progressPercent%',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.redAccent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 10,
                      backgroundColor: const Color(0xFFEEEEEE),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Terus tingkatkan kesiapsiagaan menghadapi kondisi darurat!', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Emergency SOS Hotline Quick Bar
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NomorDaruratScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone_in_talk_rounded, color: Colors.redAccent, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Panggilan Cepat Darurat (SOS 112)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.redAccent)),
                          Text('Klik untuk melihat kontak BASARNAS, Damkar & PMI', style: TextStyle(fontSize: 11, color: Colors.black87)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.redAccent),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // 4 Tombol Menu Utama (Grid 2x2)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                _buildQuickMenu(
                  icon: Icons.menu_book_rounded,
                  label: 'Materi & Video',
                  color: Colors.orange,
                  onTap: () => widget.onTabChange?.call(1),
                ),
                _buildQuickMenu(
                  icon: Icons.play_circle_fill_rounded,
                  label: 'Simulasi Bencana',
                  color: Colors.redAccent,
                  onTap: () => widget.onTabChange?.call(2),
                ),
                _buildQuickMenu(
                  icon: Icons.assignment_turned_in_rounded,
                  label: 'Kuis Evaluasi',
                  color: Colors.blue,
                  onTap: () => widget.onTabChange?.call(3),
                ),
                _buildQuickMenu(
                  icon: Icons.bar_chart_rounded,
                  label: 'Riwayat Nilai',
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RiwayatNilaiScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Bagian Berita & Tips Interaktif
            const Text('Berita & Tips Mitigasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            ...DummyData.daftarBerita.map((tips) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: _buildTipsCard(
                  title: tips.judul,
                  desc: tips.ringkasan,
                  icon: getDisasterIcon(tips.ikon),
                  onTap: () => _showNewsDetail(tips),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickMenu({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipsCard({
    required String title,
    required String desc,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                  child: Icon(icon, color: Colors.redAccent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 2),
                      Text(desc, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
