# DISASTER-X

**Digital Interactive Simulation for Adaptive Emergency Response**

DISASTER-X adalah aplikasi pembelajaran mitigasi bencana berbasis **Flutter** yang menggabungkan materi edukasi, latihan evaluasi, dan simulasi pengambilan keputusan. Proyek ini dikembangkan untuk tugas mata kuliah **Mobile Programming**.

> **Status pengembangan:** Aplikasi masih dikembangkan. Simulasi **gempa bumi** telah memiliki interaksi berbasis checkpoint dan *Safety Score*. Simulasi **kebakaran** dan **banjir** belum selesai dikembangkan sebagai simulasi interaktif.

## Identitas proyek

| Informasi | Keterangan |
| --- | --- |
| Nama aplikasi | DISASTER-X |
| Pengembang utama | Shava Phiyan Anantha |
| NIM | 2413025047 |
| Mata kuliah | Mobile Programming |
| Teknologi | Flutter dan Dart |
| Penyimpanan lokal | `shared_preferences` (sesuai konfigurasi proyek) |

Proyek ini dikerjakan dalam konteks tugas kelompok. Kontribusi setiap anggota perlu dijelaskan sesuai pekerjaan yang benar-benar dilakukan; identitas dan pembagian tugas dapat dilengkapi setelah diverifikasi bersama kelompok.

## Tujuan aplikasi

DISASTER-X bertujuan membantu pengguna mempelajari langkah kesiapsiagaan dan respons awal terhadap bencana melalui materi yang mudah diakses serta latihan memilih tindakan dalam suatu skenario. Aplikasi ini merupakan **media edukasi**, bukan pengganti arahan petugas atau informasi resmi saat keadaan darurat.

## Fitur aplikasi

### 1. Login, mode tamu, dan profil

Rancangan aplikasi mencakup pengisian identitas pengguna, akses melalui mode tamu, pengelolaan profil, dan penyimpanan data lokal. Ketersediaan serta perilaku masing-masing fungsi perlu diperiksa pada versi aplikasi yang akan didemonstrasikan.

### 2. Beranda dan navigasi

Beranda digunakan sebagai pintu masuk menuju materi mitigasi, simulasi, kuis, serta fitur pendukung. Informasi progres belajar dan ringkasan aktivitas ditampilkan sesuai implementasi pada aplikasi.

### 3. Materi mitigasi dan E-LKPD

Cakupan materi yang dirancang meliputi:

- **Gempa bumi:** perlindungan diri saat guncangan dan evakuasi aman.
- **Kebakaran:** pencegahan dan respons awal terhadap kebakaran.
- **Banjir:** persiapan dan langkah keselamatan saat banjir.
- **Tsunami:** pengenalan tanda bahaya dan evakuasi menuju lokasi aman.

Materi dapat disusun berdasarkan tahap **prabencana, saat kejadian, pascabencana**, serta **hal yang dianjurkan dan perlu dihindari**. Kelengkapan tiap modul mengikuti implementasi yang tersedia dalam aplikasi.

### 4. Simulasi bencana interaktif

**Sudah diimplementasikan: Simulasi Gempa Bumi**

Simulasi gempa menempatkan pengguna dalam situasi darurat dan meminta pengguna menentukan tindakan pada titik-titik keputusan (*checkpoint*). Mekanisme yang sudah diuji dalam pengembangan meliputi:

- Simulasi berhenti sementara pada checkpoint.
- Pengguna memilih tindakan yang tersedia.
- Aplikasi memberikan umpan balik terhadap pilihan.
- **Safety Score** berubah sesuai keputusan pengguna.
- Hasil keputusan digunakan sebagai bagian dari evaluasi kesiapsiagaan.

**Masih dalam pengembangan:**

- Simulasi kebakaran di laboratorium komputer.
- Simulasi banjir atau banjir bandang.

Kedua skenario tersebut **belum dinyatakan selesai atau siap dimainkan secara interaktif**.

### 5. Kuis evaluasi

Proyek mencakup rancangan kuis untuk mengukur pemahaman pengguna tentang mitigasi bencana. Fitur seperti batas waktu, skor, pembahasan jawaban, dan penyimpanan hasil perlu dicocokkan dengan implementasi terkini sebelum dinyatakan sepenuhnya berfungsi.

### 6. Fitur pendukung

Dalam rancangan proyek terdapat fitur pendukung seperti informasi nomor darurat, checklist tas siaga, riwayat nilai, dan sertifikat. Keberadaan menu tidak selalu berarti seluruh fungsi—termasuk penyimpanan, unduh, atau ekspor—sudah selesai diuji. Status fitur-fitur ini mengikuti versi aplikasi yang tersedia.

## Teknologi yang digunakan

- **Flutter** — framework pengembangan antarmuka lintas platform.
- **Dart** — bahasa pemrograman aplikasi.
- **`shared_preferences`** — penyimpanan data sederhana secara lokal, apabila digunakan pada fitur terkait.

Versi Flutter, Dart, dan dependensi yang tepat dapat diperiksa melalui `flutter --version` dan `pubspec.yaml` pada proyek ini.

## Struktur proyek

Struktur utama proyek Flutter adalah sebagai berikut. Nama file dan folder dapat berkembang mengikuti pembaruan implementasi.

```text
disaster_x/
├── lib/                  # Kode sumber Dart
│   ├── main.dart         # Titik masuk aplikasi
│   ├── models/           # Model data
│   ├── services/         # Pengelolaan data dan penyimpanan
│   ├── widgets/          # Komponen antarmuka yang digunakan ulang
│   └── screens/          # Halaman aplikasi
├── test/                 # Pengujian (jika tersedia)
├── android/              # Konfigurasi Android
├── web/                  # Konfigurasi Web
├── pubspec.yaml          # Dependensi dan metadata proyek
├── AI_DECLARATION.md     # Dokumentasi penggunaan AI
└── README.md             # Dokumentasi utama proyek
```

## Cara menjalankan aplikasi

**Prasyarat:** Flutter SDK dan perangkat atau browser yang didukung telah disiapkan.

1. Buka terminal di folder proyek `disaster_x`.
2. Periksa instalasi Flutter dan unduh dependensi:

   ```bash
   flutter doctor
   flutter pub get
   ```

3. Jalankan aplikasi pada Chrome:

   ```bash
   flutter run -d chrome
   ```

   Atau lihat perangkat yang tersedia dan pilih target yang sesuai:

   ```bash
   flutter devices
   flutter run
   ```

4. Untuk memeriksa kode dan menjalankan pengujian yang tersedia:

   ```bash
   flutter analyze
   flutter test
   ```

   > Perintah di atas merupakan **langkah pemeriksaan**, bukan klaim bahwa seluruh pengujian telah lulus. Hasilnya bergantung pada keadaan kode dan lingkungan pengembangan saat dijalankan.

## Penggunaan AI dalam pengembangan

Pengembangan DISASTER-X melibatkan bantuan AI dengan peran berbeda:

- **Gemini:** membantu proses belajar dan memahami dasar Flutter pada tahap awal.
- **Google Antigravity:** membantu pengembangan kode dan penyusunan sejumlah fitur aplikasi secara substansial.
- **ChatGPT:** membantu diskusi pengembangan, evaluasi antarmuka, serta penyempurnaan konsep dan mekanisme simulasi interaktif.

Detail penggunaan AI, contoh prompt, dan evaluasi hasilnya didokumentasikan secara terpisah pada **[AI_DECLARATION.md](AI_DECLARATION.md)**.

## Status dan rencana pengembangan

| Komponen | Status |
| --- | --- |
| Simulasi interaktif gempa bumi | Sudah diimplementasikan; perlu pengujian akhir sebelum presentasi |
| Simulasi interaktif kebakaran | Dalam pengembangan |
| Simulasi interaktif banjir | Dalam pengembangan |
| Fitur lainnya | Perlu pemeriksaan akhir berdasarkan aplikasi terbaru |

Rencana pengembangan berikutnya adalah melengkapi simulasi kebakaran dan banjir, menguji konsistensi penyimpanan progres dan skor, serta memperbaiki pengalaman pengguna berdasarkan hasil pengujian.

## Catatan

Informasi keselamatan dalam aplikasi ditujukan untuk pembelajaran. Saat terjadi bencana nyata, ikuti informasi resmi dan instruksi petugas berwenang.
