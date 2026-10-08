import 'package:flutter/material.dart';
import '../../services/dummy_data.dart';
import '../../widgets/icon_helper.dart';

class NomorDaruratScreen extends StatelessWidget {
  const NomorDaruratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Nomor Darurat Nasional', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner Informasi Panggilan Darurat
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.phone_in_talk_rounded, color: Colors.redAccent, size: 36),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Panggilan Darurat Bebas Pulsa',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.redAccent),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Nomor-nomor ini dapat dihubungi dari segala operator tanpa pulsa dalam situasi darurat dan bencana.',
                        style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          const Text('Daftar Kontak Cepat (SOS)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          ...DummyData.nomorDarurat.map((item) {
            final color = Color(int.parse(item['warna']!));
            final nomor = item['nomor']!;
            final instansi = item['instansi']!;
            final deskripsi = item['deskripsi']!;
            final iconName = item['ikon']!;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: color.withValues(alpha: 0.12),
                    child: Icon(getDisasterIcon(iconName), color: color, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(instansi, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 2),
                        Text(deskripsi, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Panggil: $nomor',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.call_rounded, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Menghubungi nomor darurat $nomor ($instansi)...'),
                          backgroundColor: color,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
