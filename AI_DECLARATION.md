# AI DECLARATION — DISASTER-X

## 1. Identitas proyek

- **Nama aplikasi:** DISASTER-X (Digital Interactive Simulation for Adaptive Emergency Response)
- **Mata kuliah:** Mobile Programming
- **Pengembang:** Proyek kelompok; pembagian kontribusi setiap anggota dicatat sesuai pekerjaan yang benar-benar dilakukan.
- **Teknologi:** Flutter dan Dart
- **Tujuan dokumen:** Menjelaskan penggunaan AI secara transparan selama proses belajar, pengembangan, evaluasi, dan penyempurnaan aplikasi.

## 2. Alat AI dan perannya

| Alat | Penggunaan yang dapat dijelaskan | Batasan klaim |
|---|---|---|
| **Gemini** | Tutor belajar Flutter pada tahap awal, membantu memahami konsep dan langkah dasar pengembangan. | Tidak dinyatakan sebagai pengembang utama modul aplikasi. |
| **Google Antigravity** | Membantu pengembangan kode Flutter secara substansial dari proyek awal, termasuk usulan fitur dan proses penyiapan dependensi. | Tidak seluruh kode diklaim ditulis manual oleh mahasiswa. |
| **ChatGPT** | Diskusi, evaluasi UI/UX, saran implementasi Splash Screen, serta pembahasan penyempurnaan simulasi interaktif. | Saran ChatGPT dibedakan dari perubahan kode yang benar-benar diterapkan. |

**Catatan:** Jika Google Flow digunakan untuk membuat aset video simulasi, cantumkan juga sebagai alat pembuatan aset media setelah memeriksa bukti penggunaannya.

## 3. Kontribusi mahasiswa dan bantuan AI

### Kontribusi yang telah dijelaskan

- Menyiapkan proyek Flutter tahap awal dan membuat rancangan/implementasi awal halaman Login dan Beranda.
- Menentukan kebutuhan serta arah pengembangan DISASTER-X, termasuk penekanan pada antarmuka yang lebih menarik dan simulasi yang melibatkan pengambilan keputusan.
- Meninjau tampilan aplikasi, membandingkannya dengan sketsa pada laporan, dan meminta evaluasi/penyempurnaan.
- Melakukan demonstrasi atau pengujian fitur yang sudah berjalan, termasuk checkpoint simulasi dan perubahan Safety Score.

### Bagian yang dibantu AI

- Pengembangan sejumlah bagian struktur dan kode aplikasi secara substansial melalui Google Antigravity.
- Saran perancangan UI Splash Screen melalui ChatGPT.
- Pembelajaran Flutter tahap awal melalui Gemini.

**Perlu dilengkapi sebelum pengumpulan:** Catat perubahan kode spesifik yang benar-benar diketik sendiri, disalin dari AI, atau diterapkan oleh Antigravity. Jangan menyatakan suatu perbaikan sebagai hasil pengodean manual tanpa bukti.

## 4. Studi kasus 1 — Google Antigravity

### Prompt asli

> tolong kembangin tugas aku ini ya, ini untuk mata kuliah mobile pemrograming

### Respons dan proses yang tercatat

Antigravity menampilkan dua pertanyaan mengenai (1) prioritas pengembangan DISASTER-X dan (2) ketentuan teknis dari dosen. Rekomendasi yang ditampilkan adalah paket pengembangan Flutter meliputi struktur aplikasi, kuis interaktif, materi detail, simulasi, dan penyimpanan lokal dengan `SharedPreferences`, serta pendekatan Flutter standar.

Dalam log yang disimpan, terdapat pemasangan dependensi `shared_preferences` versi 2.5.6. Proses tersebut juga menampilkan pesan bahwa pembuatan aplikasi dengan plugin membutuhkan dukungan symlink dan Windows Developer Mode, dengan hasil perintah `exit code 1`. Setelah itu, Antigravity menyatakan akan menjalankan `flutter analyze`.

### Evaluasi kritis

Antigravity membantu mempercepat pengembangan dari proyek awal. Namun, proses otomatis tetap perlu diperiksa. Log instalasi menunjukkan kendala konfigurasi lingkungan Windows; pesan `flutter analyze` hanya menunjukkan analisis **dimulai**, bukan bukti bahwa hasilnya bebas masalah. Status penyelesaian kendala dan hasil akhir analisis harus diverifikasi dari log atau pengujian aktual.

### Penyesuaian lanjutan

Setelah pengembangan awal, antarmuka dan interaktivitas aplikasi dievaluasi kembali. Detail perubahan manual maupun perubahan berbantuan AI harus disesuaikan dengan riwayat kode dan bukti yang tersedia.

### Bukti yang disimpan

- `Bukti_AI_DISASTER-X/01_Antigravity_Prompt.png`
- `Bukti_AI_DISASTER-X/02_Antigravity_Proses.png`
- **[TAMBAHKAN jika tersedia]** Log akhir `flutter analyze` dan hasil pengujian aplikasi.

## 5. Studi kasus 2 — ChatGPT: evaluasi Splash Screen

### Prompt asli

> halaman splashscreen aku kan gini ya, nah sedangakn ini tu masi polos manget kan,,, ini yg sketsa ini kek kasaran di laporan aku, nah aku tu mqu buat gtu, jd biar ngga terlal polos, ini dia mgoding atau kita buat desaij gt ya

### Respons awal ChatGPT yang terdokumentasi

> Iyaaa aku paham maksudmu 😭 Kamu pengen **tampilan splash screen yang sekarang jangan terlalu polos**, tapi dibuat lebih mendekati **sketsa/wireframe yang ada di laporan**.
>
> Dan menurutku **jangan dibuat sebagai satu gambar full yang ditempel di Flutter**. Lebih bagus **desainnya kita implementasikan lewat coding Flutter**, sedangkan kalau mau ada ilustrasi bencana di belakangnya, ilustrasinya bisa dibuat sebagai **asset gambar**.

### Evaluasi kritis

Saran tersebut membedakan komponen antarmuka Flutter dengan aset visual. Pengguna telah memberikan acuan berupa sketsa laporan dan mengidentifikasi bahwa tampilan awal terlalu polos. Respons AI menjadi bahan pertimbangan untuk menyempurnakan UI, bukan bukti bahwa seluruh kode perubahan sudah dibuat atau diterapkan secara manual.

### Tindak lanjut

**[VERIFIKASI]** Bandingkan sketsa awal, tampilan akhir, dan file Flutter Splash Screen. Tuliskan perubahan nyata (misalnya widget, layout, ilustrasi, navigasi) hanya setelah dipastikan dari proyek. Jelaskan siapa yang menerapkan kode dan apakah ada bantuan AI.

### Bukti yang disimpan

- `Bukti_AI_DISASTER-X/03_ChatGPT_Splash_Prompt.png`
- `Bukti_AI_DISASTER-X/04_ChatGPT_Splash_Respons.png`
- `Bukti_AI_DISASTER-X/05_Splash_Hasil.png`
- `Bukti_AI_DISASTER-X/06_Kode_Splash.png`

## 6. Refleksi penggunaan AI

AI membantu mempercepat pembelajaran Flutter, menyusun alternatif solusi teknis, dan mengembangkan aplikasi. Meski demikian, keluaran AI tidak otomatis sesuai dengan seluruh kebutuhan proyek. Pengembang perlu mengevaluasi kesesuaian rancangan, menguji interaksi aplikasi, memeriksa log error, serta memahami fungsi kode yang digunakan. Penggunaan AI dinyatakan secara terbuka dan tidak menggantikan tanggung jawab mahasiswa atas hasil yang dikumpulkan.

## 7. Transparansi kolaborasi dan Git

Proyek dikerjakan secara kelompok. Riwayat Git digunakan untuk menunjukkan perkembangan file dan identitas pembuat commit, tetapi identitas commit tidak selalu sama dengan penulis asli seluruh kode, khususnya bila kode dihasilkan AI atau dipindahkan antaranggota. Pembagian kerja dijelaskan sesuai fakta; tidak dilakukan rekayasa tanggal commit atau atribusi kontribusi.

**[VERIFIKASI]** Lengkapi nama akun GitHub anggota, pembagian pekerjaan yang benar-benar terjadi, dan commit terkait apabila diperlukan dosen.

## 8. Daftar verifikasi sebelum pengumpulan

- [ ] Dua prompt dan respons AI didokumentasikan dengan screenshot asli.
- [ ] Hasil akhir UI Splash Screen didokumentasikan.
- [ ] Bagian perubahan kode dan peran manual/AI telah diperiksa.
- [ ] Hasil akhir `flutter analyze` atau pengujian aplikasi diverifikasi jika hendak diklaim.
- [ ] `AI_DECLARATION.md` ditempatkan di root proyek, sejajar dengan `README.md` dan `pubspec.yaml`.
- [ ] File dan bukti yang ingin disertakan sudah di-commit dan di-push ke repository yang benar.
- [ ] Pernyataan dalam video konsisten dengan isi deklarasi dan kode aktual.

---

*Dokumen ini disusun dari prompt dan respons yang berhasil dipulihkan dari percakapan pengguna. Bagian bertanda [VERIFIKASI] wajib dicocokkan dengan bukti asli sebelum dinyatakan final.*
