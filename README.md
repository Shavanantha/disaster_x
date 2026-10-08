# DISASTER-X (Digital Interactive Simulation for Adaptive Emergency Response)

**DISASTER-X** adalah aplikasi mobile berbasis Flutter yang dirancang sebagai media pembelajaran interaktif dan simulasi mitigasi bencana alam serta kegawatdaruratan bagi siswa dan mahasiswa. Aplikasi ini dikembangkan untuk memenuhi tugas mata kuliah **Mobile Programming**.

---

## 👨‍🎓 Identitas Mahasiswa & Pengembang
- **Nama:** Shava Phiyan Anantha
- **NIM:** 2413025047
- **Mata Kuliah:** Mobile Programming
- **Framework & Bahasa:** Flutter 3.47+ / Dart 3.13+
- **Manajemen Data:** SharedPreferences (Penyimpanan Lokal Persisten)

---

## 🚀 Fitur Utama Aplikasi

### 1. 📱 Autentikasi & Profil Siswa
- **Login Mahasiswa:** Form input Nama Lengkap dan NIM/NISN dengan validasi.
- **Mode Tamu (Guest):** Akses langsung tanpa login untuk pengujian cepat.
- **Edit Profil Dinamis:** Pengguna dapat memperbarui identitas siswa, asal sekolah/kampus, dan jurusan sewaktu-waktu.
- **Penyimpanan Lokal:** Sesi masuk dan data akun tersimpan secara lokal menggunakan `shared_preferences`.

### 2. 🏠 Beranda Terintegrasi (Home Screen)
- **Salam Pengguna Dinamis:** Menampilkan sapaan nama siswa dan predikat level kesiapsiagaan (Siaga Pratama, Madya, Utama).
- **Indikator Progres Belajar:** Perhitungan persentase kesiapan otomatis berdasarkan jumlah modul yang selesai dibaca dan simulasi/kuis yang dikerjakan.
- **Quick SOS Bar:** Akses cepat satu ketukan menuju menu Nomor Darurat Nasional.
- **Menu Navigasi 2x2:** Akses cepat ke Modul Materi, Simulasi Bencana, Kuis Evaluasi, dan Riwayat Nilai.
- **Berita & Tips Mitigasi:** Artikel edukasi bencana interaktif (Gempa, Kebakaran, Tas Siaga) yang dapat dibuka dalam modal lembar bacaan lengkap.

### 3. 📚 Modul Materi & E-LKPD (4 Bencana Utama)
Mencakup 4 modul materi komprehensif berstandar BNPB:
1. **Mitigasi Gempa Bumi** (Drop, Cover, Hold On, jalur evakuasi aman, gempa susulan).
2. **Mitigasi Kebakaran Gedung** (Teknik PASS APAR, penyelamatan asap tebal beracun).
3. **Mitigasi Banjir Luapan** (Pemutusan arus listrik, penyelamatan arsip, penyakit pascabanjir).
4. **Mitigasi Tsunami & Pesisir** (Golden rule 20-20-20, tanda air laut surut tiba-tiba).

Setiap modul dilengkapi 4 sub-tab pembelajaran:
- **Prabencana (Siaga)**: Langkah persiapan dan pencegahan dini.
- **Saat Kejadian (Aksi)**: Tindakan penyelamatan diri darurat.
- **Pascabencana (Pemulihan)**: Penanganan setelah situasi mereda.
- **Do's & Don'ts**: Daftar anjuran dan larangan tindakan kritis.
- **Fitur Penyelesaian Modul**: Tombol "Tandai Modul Selesai" untuk memperbarui persentase belajar.

### 4. 🎮 Simulasi Bencana Interaktif (Interactive Branching Simulation)
Fitur simulasi waktu nyata (real-time simulation) dengan skenario percabangan keputusan:
- **Skenario 1:** Evakuasi Gempa Bumi di Ruang Kelas (Lantai 3) - 60 Detik.
- **Skenario 2:** Korsleting Listrik & Kebakaran di Lab Komputer - 50 Detik.
- **Skenario 3:** Bertahan saat Tanggul Jebol & Banjir Bandang - 55 Detik.

**Mekanisme Simulasi:**
- **Auto-Pause Checkpoint:** Simulasi otomatis berhenti ketika peristiwa kritis terjadi.
- **Pilihan Keputusan (A, B, C):** Pengguna memilih tindakan yang harus diambil.
- **Feedback & Konsekuensi Edukatif:** Menjelaskan alasan mengapa suatu tindakan aman atau berbahaya.
- **Safety Score Dinamis (+/-):** Skor bertambah jika tindakan benar dan berkurang jika membahayakan.
- **Evaluasi Akhir:** Menampilkan predikat kelulusan dan menyimpan skor ke histori.

### 5. 📝 Kuis Evaluasi Berwaktu (Timed Quizzes)
- Kuis bertopik untuk Gempa Bumi, Kebakaran, dan Banjir.
- Dilengkapi **penghitung mundur waktu (countdown timer)**.
- Pertanyaan pilihan ganda interaktif dengan indikator progres soal.
- Modal konfirmasi pengumpulan sebelum waktu habis.
- **Halaman Hasil & Pembahasan Lengkap:** Menampilkan perolehan nilai (/100), predikat kelulusan, statistik benar/salah, serta kunci jawaban dan pembahasan untuk setiap butir soal.

### 6. 🧰 Fitur Pendukung Kesiapsiagaan
- **Checklist Tas Siaga Bencana (72 Jam):** Daftar perlengkapan ransel bertahan hidup 3 hari berstandar BNPB dengan kotak centang yang statusnya tersimpan di database lokal.
- **Nomor Darurat Nasional (SOS):** Kontak telepon bebas pulsa 112 (Darurat), 113 (Damkar), 115 (Basarnas), 118 (Ambulans/PMI), 110 (Polisi), dan 119 (Kemenkes).
- **Riwayat Nilai:** Audit log lengkap riwayat pengerjaan kuis dan simulasi siswa beserta tanggal dan status.
- **Sertifikat Kelulusan Digital:** Sertifikat penghargaan kesiapsiagaan berpredikat resmi atas nama siswa yang dapat diunduh/disimpan.
- **Fitur Reset Data:** Opsi reset kembali ke kondisi awal yang sangat praktis untuk keperluan presentasi dan penilaian dosen.

---

## 📂 Struktur Direktori Proyek

```
disaster_x/
├── android/                   # Konfigurasi platform Android
├── ios/                       # Konfigurasi platform iOS
├── web/                       # Konfigurasi platform Web
├── windows/                   # Konfigurasi platform Windows Desktop
├── test/
│   └── widget_test.dart       # Widget smoke tests (Passed)
├── lib/
│   ├── main.dart              # Titik masuk aplikasi (Entry point & Theme)
│   ├── models/                # Data model class
│   │   ├── bencana_model.dart
│   │   ├── simulasi_model.dart
│   │   ├── kuis_model.dart
│   │   └── user_profile_model.dart
│   ├── services/              # Logika data & penyimpanan lokal
│   │   ├── dummy_data.dart    # Dataset edukasi BNPB, skenario, & kuis
│   │   └── storage_service.dart # SharedPreferences wrapper
│   ├── widgets/               # Komponen UI pendukung
│   │   └── icon_helper.dart
│   └── screens/               # Tampilan layar aplikasi
│       ├── splash_screen.dart # Layar pembuka beranimasi
│       ├── main_navigation.dart # 5-Tab Bottom Navigation Bar
│       ├── auth/
│       │   └── login_screen.dart
│       ├── home/
│       │   └── home_screen.dart
│       ├── materi/
│       │   ├── materi_screen.dart
│       │   └── materi_detail_screen.dart
│       ├── simulasi/
│       │   ├── simulasi_screen.dart
│       │   └── interactive_simulation_screen.dart
│       ├── kuis/
│       │   ├── kuis_screen.dart
│       │   ├── kuis_play_screen.dart
│       │   └── kuis_result_screen.dart
│       └── profil/
│           ├── profil_screen.dart
│           ├── edit_profil_dialog.dart
│           ├── riwayat_nilai_screen.dart
│           ├── sertifikat_screen.dart
│           ├── nomor_darurat_screen.dart
│           ├── tas_siaga_screen.dart
│           └── tentang_aplikasi_screen.dart
└── pubspec.yaml               # Metadata & dependencies Flutter
```

---

## 🛠️ Cara Menjalankan Aplikasi

1. Pastikan Flutter SDK sudah terpasang di komputer Anda:
   ```bash
   flutter --version
   ```

2. Buka terminal di folder proyek ini (`disaster_x`), lalu unduh dependencies:
   ```bash
   flutter pub get
   ```

3. Jalankan pengujian widget dan analisis kode:
   ```bash
   flutter test
   flutter analyze
   ```

4. Jalankan aplikasi pada perangkat / emulator yang tersedia:
   ```bash
   # Jalankan di Chrome (Web)
   flutter run -d chrome

   # Jalankan di Windows Desktop
   flutter run -d windows

   # Jalankan di Emulator Android atau Handphone
   flutter run
   ```
