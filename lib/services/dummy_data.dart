import '../models/bencana_model.dart';
import '../models/simulasi_model.dart';
import '../models/kuis_model.dart';

class DummyData {
  // ================= DAFTAR MODUL MATERI =================
  static const List<BencanaModul> daftarModul = [
    BencanaModul(
      id: 'gempa',
      judul: 'Mitigasi Gempa Bumi',
      kategori: 'Geologi',
      ringkasan: 'Teknik Drop, Cover, Hold On, penentuan jalur evakuasi aman, dan pencegahan risiko gempa susulan.',
      warnaHex: 0xFFFF7043,
      ikon: 'landscape_rounded',
      capaian: 'Mampu melindungi kepala & organ vital, membaca peta evakuasi, dan menghindari benda berisiko saat guncangan.',
      prabencana: [
        'Kenali jalur evakuasi dan titik kumpul di rumah atau sekolah.',
        'Kaitkan lemari atau furnitur tinggi ke dinding agar tidak mudah roboh.',
        'Siapkan Tas Siaga Bencana di dekat pintu keluar yang mudah dijangkau.',
        'Ketahui lokasi saklar listrik utama dan keran gas untuk segera dimatikan.',
      ],
      saatBencana: [
        'Lakukan teknik DROP (merunduk), COVER (berlindung di bawah meja kokoh), dan HOLD ON (pegang kaki meja).',
        'Jauhi jendela kaca, cermin, lampu gantung, dan lemari kaca rapuh.',
        'Jangan gunakan LIFT saat evakuasi; selalu gunakan tangga darurat darat.',
        'Jika berada di luar ruangan, jauhi gedung tinggi, pohon besar, dan kabel listrik bertegangan.',
      ],
      pascabencana: [
        'Periksa kondisi fisik diri sendiri dan orang sekitar dari luka.',
        'Waspadai potensi gempa bumi susulan (aftershocks).',
        'Cek bau gas dan instalasi kabel korslet sebelum menyalakan api atau saklar.',
        'Menuju titik kumpul yang telah ditentukan dan pantau arahan resmi dari BMKG / BPBD.',
      ],
      dos: [
        'Melindungi kepala dengan helm, tas, atau kedua tangan.',
        'Berlindung di bawah meja yang kuat.',
        'Membantu evakuasi anak-anak, ibu hamil, dan lansia.',
        'Mengikuti arahan petugas evakuasi dan rambu keselamatan.',
      ],
      donts: [
        'Jangan panik dan jangan berdesak-desakan di pintu keluar.',
        'Jangan menyalakan korek api atau kompor jika tercium bau gas.',
        'Jangan masuk kembali ke dalam gedung yang sudah retak parah.',
        'Jangan menyebarkan informasi hoaks yang belum terverifikasi BMKG.',
      ],
    ),
    BencanaModul(
      id: 'kebakaran',
      judul: 'Mitigasi Kebakaran Gedung',
      kategori: 'Sosial & Fisik',
      ringkasan: 'Penggunaan APAR teknik PASS, penyelamatan dari asap tebal beracun, dan prosedur evakuasi darurat.',
      warnaHex: 0xFFE53935,
      ikon: 'local_fire_department_rounded',
      capaian: 'Memahami prinsip segitiga api, cara mengoperasikan APAR, dan simulasi penyelamatan dari kepulan asap gas monoksida.',
      prabencana: [
        'Pastikan APAR (Alat Pemadam Api Ringan) tersedia, terawat, dan masa berlakunya dicek berkala.',
        'Jangan menumpuk colokan listrik (overload) pada satu stop kontak.',
        'Pahami letak pintu darurat dan rute keluar gedung bebas hambatan barang.',
        'Pasang detektor asap dan bel alarm kebakaran yang berfungsi aktif.',
      ],
      saatBencana: [
        'Tarik tuas alarm kebakaran terdekat dan segera hubungi 113 (Damkar).',
        'Jika ruangan dipenuhi asap, merangkak rendah di lantai karena oksigen bersih berada di 30 cm terbawah.',
        'Tutup hidung dan mulut dengan kain basah untuk meminimalkan inhalasi gas beracun.',
        'Pegang gagang pintu dengan punggung tangan; jika terasa panas, jangan buka pintu tersebut.',
        'Gunakan APAR bila api masih skala kecil dengan metode PASS (Pull, Aim, Squeeze, Sweep).',
      ],
      pascabencana: [
        'Berkumpul di titik kumpul aman dan laporkan rekan yang belum terlihat.',
        'Segera cari pertolongan medis jika mengalami sesak napas atau luka bakar.',
        'Jangan memasuki gedung hingga petugas pemadam menyatakan struktur bangunan aman.',
      ],
      dos: [
        'Merayap atau merangkak di lantai saat asap pekat.',
        'Menyiramkan air hanya pada kebakaran kayu/kain (bukan minyak atau instalasi listrik aktif).',
        'Gunakan selimut basah untuk memadamkan pakaian yang terbakar (Stop, Drop, and Roll).',
      ],
      donts: [
        'Jangan sekali-kali menggunakan lift saat kebakaran.',
        'Jangan menyiram api minyak goreng atau korsleting listrik dengan air langsung.',
        'Jangan kembali ke dalam ruangan terbakar untuk mengambil barang berharga.',
      ],
    ),
    BencanaModul(
      id: 'banjir',
      judul: 'Mitigasi Banjir Luapan',
      kategori: 'Hidrometeorologi',
      ringkasan: 'Penyelamatan dokumen berharga, pemutusan aliran listrik, dan taktik bertahan dari arus deras.',
      warnaHex: 0xFF1E88E5,
      ikon: 'water_rounded',
      capaian: 'Mengantisipasi luapan air musiman, mengevakuasi keluarga ke dataran tinggi, dan mencegah penyakit pascabanjir.',
      prabencana: [
        'Ketahui riwayat ketinggian banjir di daerah tempat tinggalmu.',
        'Amankan dokumen penting (ijazah, sertifikat, akta) dalam kantong plastik kedap air di lantai atas.',
        'Bersihkan saluran air dan selokan dari sumbatan sampah berkala.',
        'Siapkan perbekalan darurat berupa air minum bersih, makanan kaleng, dan obat pribadi.',
      ],
      saatBencana: [
        'Matikan sekring MCB listrik utama dan cabut semua peralatan elektronik dari stopkontak.',
        'Tutup keran saluran pembuangan air untuk mencegah luapan balik dari gorong-gorong.',
        'Evakuasi segera ke tempat tinggi atau posko pengungsian sebelum debit air memutus jalur jalan.',
        'Jangan berjalan atau berkendara menembus arus deras (air setinggi 15 cm berarus deras dapat merobohkan orang dewasa).',
      ],
      pascabencana: [
        'Jangan menyalakan listrik sebelum instalasi diperiksa dan dinyatakan kering oleh teknisi/PLN.',
        'Bersihkan rumah dari lumpur dan endapan menggunakan disinfektan untuk mencegah kencing tikus (leptospirosis).',
        'Konsumsi air matang dan makanan yang terjamin kebersihannya.',
      ],
      dos: [
        'Mengutamakan evakuasi kelompok rentan (bayi, lansia, difabel).',
        'Menggunakan sepatu boot karet pelindung dan sarung tangan saat membersihkan sisa banjir.',
        'Memantau informasi peringatan dini debit pintu air BPBD/BMKG.',
      ],
      donts: [
        'Jangan biarkan anak-anak bermain di genangan air banjir yang tercemar kotoran.',
        'Jangan menyentuh tiang listrik atau kawat yang terendam air.',
        'Jangan mengonsumsi bahan makanan yang sudah tercemar air banjir.',
      ],
    ),
    BencanaModul(
      id: 'tsunami',
      judul: 'Mitigasi Tsunami & Pesisir',
      kategori: 'Kelautan & Geologi',
      ringkasan: 'Aturan emas 20-20-20, mengenali tanda surutnya air laut, dan evakuasi mandiri ke perbukitan.',
      warnaHex: 0xFF00897B,
      ikon: 'tsunami_rounded',
      capaian: 'Mengenali tanda alam tsunami tanpa menunggu sirine resmi dan melakukan evakuasi vertikal tepat waktu.',
      prabencana: [
        'Ketahui zona rawan tsunami dan rute jalur evakuasi menuju perbukitan terdekat.',
        'Pahami aturan 20-20-20: Guncangan gempa > 20 detik, punya waktu evakuasi ~20 menit, lari ke ketinggian > 20 meter.',
        'Siapkan pelampung dan senter di tas siaga bencana keluarga.',
      ],
      saatBencana: [
        'Jika air laut tiba-tiba surut drastis dan tercium bau garam menyengat, JANGAN mendekat ke pantai; SEGERA LARI ke tempat tinggi!',
        'Tinggalkan kendaraan jika jalanan macet; evakuasi jalan kaki atau berlari lebih efektif.',
        'Bila tidak sempat ke perbukitan, naik ke gedung beton bertingkat tinggi (evakuasi vertikal).',
      ],
      pascabencana: [
        'Ingat bahwa gelombang tsunami biasanya datang lebih dari satu kali dan gelombang kedua/ketiga bisa lebih dahsyat.',
        'Jangan kembali ke pesisir sebelum ada pernyataan resmi "Tsunami Berakhir" dari BMKG.',
      ],
      dos: [
        'Segera lari ke tempat tinggi saat merasakan gempa kuat di pesisir.',
        'Bantu sesama bila memungkinkan tanpa menunda evakuasi.',
      ],
      donts: [
        'Jangan memungut ikan terdampar di pantai saat air laut surut tiba-tiba.',
        'Jangan menonton datangnya gelombang tsunami di bibir pantai.',
      ],
    ),
  ];

  // ================= DAFTAR SKENARIO SIMULASI =================
  static const List<SkenarioSimulasi> daftarSkenario = [
    SkenarioSimulasi(
      id: 'gempa_kelas',
      judul: 'Skenario 1: Gempa Bumi di Ruang Kelas (Lantai 3)',
      kategori: 'Gempa Bumi',
      durasi: '60 Detik',
      totalDetik: 60,
      tingkatKesulitan: 'Menengah',
      deskripsi: 'Uji reflek dan pengambilan keputusanmu saat gempa 6.5 SR mengguncang gedung sekolah di lantai atas.',
      warnaHex: 0xFFFF7043,
      iconCode: 'landscape_rounded',
      statusAwal: 'Tersedia',
      prolog: 'Simulasi aktif: Situasi pembelajaran di ruang kelas lantai 3 sedang berlangsung normal...',
      pesanSelesai: 'Simulasi Selesai! Kamu berhasil selamat sampai di titik kumpul aman lapangan terbuka.',
      checkpoints: [
        SimulasiCheckpoint(
          detik: 12,
          judul: 'CHECKPOINT 1 (Detik 00:12)',
          narasiSituasi: 'Lantai berguncang sangat hebat! Puing plafon mulai berjatuhan dari atap kelas. Apa tindakan pertama yang kamu ambil?',
          pilihan: [
            PilihanKeputusan(
              kode: 'A',
              teks: 'Segera lari kencang berebut menuju pintu keluar dan tangga.',
              isAman: false,
              skorDelta: -25,
              judulFeedback: 'Tindakan Berisiko Tinggi!',
              feedback: 'Lari saat guncangan hebat sangat berbahaya. Kamu rentan terjatuh, terinjak-injak rekan, atau tertimpa runtuhan plafon beton.',
            ),
            PilihanKeputusan(
              kode: 'B',
              teks: 'Berlindung di bawah meja kokoh dengan teknik Drop, Cover, Hold On.',
              isAman: true,
              skorDelta: 35,
              judulFeedback: 'Tindakan Tepat & Sempurna!',
              feedback: 'Luar biasa! Melindungi kepala dan organ vital di bawah meja kokoh adalah standar keselamatan emas saat guncangan aktif.',
            ),
            PilihanKeputusan(
              kode: 'C',
              teks: 'Berdiri di dekat jendela kaca untuk melihat kondisi luar gedung.',
              isAman: false,
              skorDelta: -30,
              judulFeedback: 'Sangat Berbahaya!',
              feedback: 'Kaca jendela sangat mudah pecah akibat getaran gempa dan serpihannya dapat melukai tubuh secara fatal.',
            ),
          ],
        ),
        SimulasiCheckpoint(
          detik: 32,
          judul: 'CHECKPOINT 2 (Detik 00:32)',
          narasiSituasi: 'Guncangan gempa mereda sejenak. Kamu harus segera keluar dari gedung lantai 3. Bagaimana caramu turun ke bawah?',
          pilihan: [
            PilihanKeputusan(
              kode: 'A',
              teks: 'Menggunakan lift pengunjung agar cepat sampai ke lantai dasar.',
              isAman: false,
              skorDelta: -35,
              judulFeedback: 'Bahaya Fatal Terjebak!',
              feedback: 'DILARANG menggunakan lift saat gempa! Gempa dapat memutus aliran listrik seketika dan membuatmu terjebak dalam sangkar lift.',
            ),
            PilihanKeputusan(
              kode: 'B',
              teks: 'Lindungi kepala dengan tas, jalan cepat tertib lewat tangga darurat darat.',
              isAman: true,
              skorDelta: 35,
              judulFeedback: 'Keputusan Tepat!',
              feedback: 'Hebat! Tangga darurat dirancang lebih tahan beban dan melindungi kepala dengan tas meminimalkan benturan material.',
            ),
            PilihanKeputusan(
              kode: 'C',
              teks: 'Berhenti di koridor untuk membuat video rekaman di media sosial.',
              isAman: false,
              skorDelta: -20,
              judulFeedback: 'Tindakan Lalai & Membahayakan!',
              feedback: 'Gempa susulan dapat terjadi kapan saja. Menunda evakuasi demi ponsel mengancam keselamatan dirimu dan orang lain.',
            ),
          ],
        ),
        SimulasiCheckpoint(
          detik: 50,
          judul: 'CHECKPOINT 3 (Detik 00:50)',
          narasiSituasi: 'Kamu sudah berhasil keluar ke pekarangan sekolah. Di mana lokasi berkumpul yang paling aman?',
          pilihan: [
            PilihanKeputusan(
              kode: 'A',
              teks: 'Berdiri di lapangan terbuka yang jauh dari gedung, tiang, dan kabel listrik.',
              isAman: true,
              skorDelta: 30,
              judulFeedback: 'Titik Kumpul Ideal!',
              feedback: 'Tepat sekali! Titik kumpul terbuka menjamin keselamatan dari bahaya reruntuhan kaca, dinding runtuh, maupun sengatan kabel putus.',
            ),
            PilihanKeputusan(
              kode: 'B',
              teks: 'Berteduh persis di bawah kanopi teras pintu masuk gedung.',
              isAman: false,
              skorDelta: -20,
              judulFeedback: 'Lokasi Rawan Runtuh!',
              feedback: 'Kanopi dan ornamen dinding depan gedung adalah bagian yang paling rentan rontok saat gempa susulan datang.',
            ),
          ],
        ),
      ],
    ),
    SkenarioSimulasi(
      id: 'kebakaran_lab',
      judul: 'Skenario 2: Korsleting Listrik & Kebakaran di Lab Komputer',
      kategori: 'Kebakaran',
      durasi: '50 Detik',
      totalDetik: 50,
      tingkatKesulitan: 'Menengah',
      deskripsi: 'Asap hitam tebal muncul dari panel kabel server lab. Uji kesiapanmu memadamkan api dan menembus kepulan asap.',
      warnaHex: 0xFFE53935,
      iconCode: 'local_fire_department_rounded',
      statusAwal: 'Tersedia',
      prolog: 'Simulasi aktif: Siswa sedang praktikum pemrograman di laboratorium komputer...',
      pesanSelesai: 'Simulasi Selesai! Kamu berhasil mengevakuasi diri dan rekan satu kelas dengan selamat.',
      checkpoints: [
        SimulasiCheckpoint(
          detik: 12,
          judul: 'CHECKPOINT 1 (Detik 00:12)',
          narasiSituasi: 'Percikan api membesar dari colokan server dan bau kabel hangus menyengat. Apa tindakan pertamamu?',
          pilihan: [
            PilihanKeputusan(
              kode: 'A',
              teks: 'Segera siram panel listrik yang terbakar menggunakan seember air.',
              isAman: false,
              skorDelta: -40,
              judulFeedback: 'Bahaya Sengatan Listrik!',
              feedback: 'Air adalah konduktor listrik yang kuat. Menyiram kabel beraliran listrik aktif dapat menyebabkan sengatan listrik yang mematikan!',
            ),
            PilihanKeputusan(
              kode: 'B',
              teks: 'Matikan saklar MCB utama listrik ruangan dan bunyikan alarm kebakaran.',
              isAman: true,
              skorDelta: 40,
              judulFeedback: 'Tindakan Sangat Profesional!',
              feedback: 'Langkah tepat! Memutus pasokan arus listrik mencegah penyebaran api elektrik dan alarm memberi tahu seluruh penghuni gedung.',
            ),
            PilihanKeputusan(
              kode: 'C',
              teks: 'Membuka semua jendela lebar-lebar dan membiarkan api menyala.',
              isAman: false,
              skorDelta: -20,
              judulFeedback: 'Kurang Tepat!',
              feedback: 'Pasokan oksigen berlebih dapat membuat api menyala semakin cepat tanpa ada tindakan pemutusan sumber arus.',
            ),
          ],
        ),
        SimulasiCheckpoint(
          detik: 30,
          judul: 'CHECKPOINT 2 (Detik 00:30)',
          narasiSituasi: 'Asap hitam tebal mulai memenuhi lorong keluar. Penglihatan terbatas dan napas mulai sesak. Bagaimana taktik jalanmu?',
          pilihan: [
            PilihanKeputusan(
              kode: 'A',
              teks: 'Merangkak rendah di lantai sambil menutup hidung dengan kain basah.',
              isAman: true,
              skorDelta: 35,
              judulFeedback: 'Taktik Evakuasi Sempurna!',
              feedback: 'Luar biasa! Asap dan gas karbon monoksida naik ke atas. Udara bersih tersisa di dekat lantai dan kain basah menyaring partikel jelaga.',
            ),
            PilihanKeputusan(
              kode: 'B',
              teks: 'Berlari tegak secepat mungkin menembus kepulan asap tebal.',
              isAman: false,
              skorDelta: -30,
              judulFeedback: 'Risiko Keracunan Asap!',
              feedback: 'Berlari tegak membuatmu menghirup udara bersuhu tinggi dan gas monoksida yang dapat menyebabkan pingsan seketika dalam hitungan detik.',
            ),
            PilihanKeputusan(
              kode: 'C',
              teks: 'Kembali ke dalam lab untuk mengambil tas dan laptop pribadi.',
              isAman: false,
              skorDelta: -35,
              judulFeedback: 'Keputusan Sangat Buruk!',
              feedback: 'Nyawa jauh lebih berharga daripada barang elektronik. Menunda evakuasi sering kali berujung pada terjebak api.',
            ),
          ],
        ),
        SimulasiCheckpoint(
          detik: 42,
          judul: 'CHECKPOINT 3 (Detik 00:42)',
          narasiSituasi: 'Di dekat pintu keluar darurat tergantung sebuah APAR powder. Api kecil menghalangi pintu. Bagaimana cara memakai APAR?',
          pilihan: [
            PilihanKeputusan(
              kode: 'A',
              teks: 'Gunakan teknik PASS: Tarik Pin, Arahkan Nozzle ke pangkal api, Remas Tuas, Sapukan kiri-kanan.',
              isAman: true,
              skorDelta: 35,
              judulFeedback: 'Teknik PASS Sempurna!',
              feedback: 'Tepat sekali! Mengarahkan semprotan ke pangkal api dari jarak aman 2-3 meter akan memadamkan sumber api secara efektif.',
            ),
            PilihanKeputusan(
              kode: 'B',
              teks: 'Arahkan semprotan ke ujung kobaran lidah api bagian atas.',
              isAman: false,
              skorDelta: -25,
              judulFeedback: 'Pemadaman Kurang Efektif!',
              feedback: 'Menyemprot ujung kobaran api tidak akan memadamkan bara inti bahan yang terbakar di bagian dasar.',
            ),
          ],
        ),
      ],
    ),
    SkenarioSimulasi(
      id: 'banjir_tanggul',
      judul: 'Skenario 3: Bertahan saat Tanggul Jebol & Banjir Bandang',
      kategori: 'Banjir',
      durasi: '55 Detik',
      totalDetik: 55,
      tingkatKesulitan: 'Tinggi',
      deskripsi: 'Air bah meluap cepat masuk ke area pemukiman akibat tanggul jebol. Selamatkan keluarga dan dokumen penting.',
      warnaHex: 0xFF1E88E5,
      iconCode: 'water_rounded',
      statusAwal: 'Tersedia',
      prolog: 'Simulasi aktif: Sirine peringatan tanggul berbunyi di pemukiman warga saat hujan lebat...',
      pesanSelesai: 'Simulasi Selesai! Kamu dan keluargamu berhasil diselamatkan ke tempat pengungsian yang aman.',
      checkpoints: [
        SimulasiCheckpoint(
          detik: 14,
          judul: 'CHECKPOINT 1 (Detik 00:14)',
          narasiSituasi: 'Air keruh mulai menggenangi halaman rumah setinggi mata kaki dan arus terlihat deras. Apa aksi pertamamu?',
          pilihan: [
            PilihanKeputusan(
              kode: 'A',
              teks: 'Segera matikan sekring meteran listrik (MCB) dan amankan dokumen penting ke tempat tinggi.',
              isAman: true,
              skorDelta: 40,
              judulFeedback: 'Prioritas Aksi Sangat Tepat!',
              feedback: 'Bagus sekali! Mematikan MCB mencegah insiden tersetrum air banjir dan menyelamatkan arsip berharga di awal sangat krusial.',
            ),
            PilihanKeputusan(
              kode: 'B',
              teks: 'Berenang ke luar pagar untuk mengecek seberapa parah tanggul yang jebol.',
              isAman: false,
              skorDelta: -35,
              judulFeedback: 'Bahaya Terseret Arus!',
              feedback: 'Arus bawah banjir bandang membawa puing berbahaya, kayu, dan kawat tajam yang dapat menyeret manusia dengan mudah.',
            ),
            PilihanKeputusan(
              kode: 'C',
              teks: 'Menyalakan pompa air celup di lantai dasar rumah.',
              isAman: false,
              skorDelta: -30,
              judulFeedback: 'Berisiko Tersengat Listrik!',
              feedback: 'Mengoperasikan perangkat listrik saat genangan naik membahayakan keselamatan jiwa.',
            ),
          ],
        ),
        SimulasiCheckpoint(
          detik: 35,
          judul: 'CHECKPOINT 2 (Detik 00:35)',
          narasiSituasi: 'Debit air di dalam rumah sudah mencapai pinggang dalam waktu singkat. Ke mana kamu mengarahkan evakuasi keluarga?',
          pilihan: [
            PilihanKeputusan(
              kode: 'A',
              teks: 'Evakuasi ke lantai dua atau atap rumah yang kokoh sambil membawa Tas Siaga Bencana.',
              isAman: true,
              skorDelta: 35,
              judulFeedback: 'Evakuasi Vertikal Tepat!',
              feedback: 'Benar! Menuju tempat yang lebih tinggi (evakuasi vertikal) adalah keputusan paling aman ketika arus di jalanan sudah tidak dapat dilalui.',
            ),
            PilihanKeputusan(
              kode: 'B',
              teks: 'Tetap bertahan di lantai dasar sambil menjaga barang perabotan rumah.',
              isAman: false,
              skorDelta: -40,
              judulFeedback: 'Sangat Berbahaya Terjebak Air!',
              feedback: 'Air bah bisa terus naik dengan cepat hingga menyentuh langit-langit, menjebak siapapun yang bertahan di lantai dasar.',
            ),
          ],
        ),
        SimulasiCheckpoint(
          detik: 46,
          judul: 'CHECKPOINT 3 (Detik 00:46)',
          narasiSituasi: 'Perahu karet tim SAR mendekat ke arah rumahmu. Bagaimana caramu menarik perhatian mereka?',
          pilihan: [
            PilihanKeputusan(
              kode: 'A',
              teks: 'Meniup peluit darurat dan melambaikan kain terang untuk memberi sinyal posisi.',
              isAman: true,
              skorDelta: 35,
              judulFeedback: 'Sinyal Darurat Efektif!',
              feedback: 'Luar biasa! Suara peluit dapat menembus suara gemuruh air hujan dan warna terang memudahkan tim penyelamat melacak posisimu.',
            ),
            PilihanKeputusan(
              kode: 'B',
              teks: 'Melompat ke air banjir berusaha berenang mengejar perahu SAR.',
              isAman: false,
              skorDelta: -30,
              judulFeedback: 'Tindakan Ceroboh!',
              feedback: 'Melompat ke pusaran air berisiko terbawa arus atau tertabrak lambung perahu.',
            ),
          ],
        ),
      ],
    ),
  ];

  // ================= DAFTAR PAKET KUIS EVALUASI =================
  static const List<PaketKuis> daftarKuis = [
    PaketKuis(
      id: 'kuis_gempa',
      judul: 'Kuis 1: Prosedur Mitigasi Gempa Bumi',
      kategori: 'Gempa Bumi',
      jumlahSoal: 5,
      batasWaktuMenit: 5,
      warnaHex: 0xFFFF7043,
      daftarSoal: [
        SoalKuis(
          pertanyaan: 'Apa kepanjangan dan urutan gerakan mitigasi mandiri yang benar saat terjadi gempa bumi?',
          pilihan: [
            'Run, Jump, Shout',
            'Drop, Cover, Hold On',
            'Stand, Protect, Escape',
            'Look, Listen, Evacuate',
          ],
          indexJawabanBenar: 1,
          penjelasan: 'Drop (merunduk), Cover (berlindung di bawah meja), dan Hold On (pegang erat kaki meja) adalah prosedur standar internasional BNPB & FEMA.',
        ),
        SoalKuis(
          pertanyaan: 'Mengapa dilarang menggunakan elevator atau lift saat terjadi gempa bumi di gedung bertingkat?',
          pilihan: [
            'Lift bergerak terlalu lambat',
            'Biaya operasional lift mahal saat darurat',
            'Potensi listrik padam seketika dan kabel lift terputus mengakibatkan terjebak',
            'Lift hanya diperuntukkan untuk mengangkut barang bawaan',
          ],
          indexJawabanBenar: 2,
          penjelasan: 'Gempa sering menyebabkan kegagalan sistem kelistrikan dan deformasi rel lift sehingga berisiko tinggi macet di antara lantai.',
        ),
        SoalKuis(
          pertanyaan: 'Bila kamu sedang berada di dalam ruang kelas saat gempa, benda apa yang paling berbahaya didekati?',
          pilihan: [
            'Meja kayu guru',
            'Jendela kaca dan lemari arsip kaca',
            'Lantai keramik',
            'Pintu darurat kayu',
          ],
          indexJawabanBenar: 1,
          penjelasan: 'Kaca rentan pecah akibat tegangan struktur dinding dan dapat melukai tubuh secara serius.',
        ),
        SoalKuis(
          pertanyaan: 'Berapa jarak aman berkumpul di titik kumpul luar gedung dari struktur bangunan tinggi?',
          pilihan: [
            'Persis di bawah jendela gedung',
            'Minimal setengah hingga satu kali tinggi gedung di area terbuka bebas tiang',
            'Di bawah kanopi parkir mobil',
            'Di dekat tiang transformator listrik',
          ],
          indexJawabanBenar: 1,
          penjelasan: 'Area titik kumpul harus bebas dari jangkauan material jatuh jika dinding luar gedung mengalami keruntuhan.',
        ),
        SoalKuis(
          pertanyaan: 'Apa yang harus dilakukan jika kamu sedang berada di pantai dan merasakan gempa bumi kuat lebih dari 20 detik?',
          pilihan: [
            'Melihat air laut apakah ada ikan terdampar',
            'Berenang ke tengah laut',
            'Segera lari menjauhi pantai menuju tempat berketinggian lebih dari 20 meter',
            'Merekam ombak menggunakan ponsel',
          ],
          indexJawabanBenar: 2,
          penjelasan: 'Aturan emas 20-20-20 menyatakan gempa >20 detik di pantai merupakan indikasi kuat potensi tsunami.',
        ),
      ],
    ),
    PaketKuis(
      id: 'kuis_kebakaran',
      judul: 'Kuis 2: Taktik Menghindari Asap & Pemadaman APAR',
      kategori: 'Kebakaran',
      jumlahSoal: 5,
      batasWaktuMenit: 5,
      warnaHex: 0xFFE53935,
      daftarSoal: [
        SoalKuis(
          pertanyaan: 'Apa singkatan metode operasional penggunaan tabung APAR yang tepat?',
          pilihan: [
            'P.U.S.H (Push, Unlock, Spray, Hold)',
            'P.A.S.S (Pull, Aim, Squeeze, Sweep)',
            'F.I.R.E (Find, Inform, Run, Extinguish)',
            'S.T.O.P (Stay, Turn, Open, Protect)',
          ],
          indexJawabanBenar: 1,
          penjelasan: 'PASS: Pull pin pengaman, Aim corong ke pangkal api, Squeeze tuas semprot, Sweep sapukan dari kiri ke kanan secara merata.',
        ),
        SoalKuis(
          pertanyaan: 'Mengapa saat melintasi ruangan yang dipenuhi asap tebal disarankan untuk merangkak di lantai?',
          pilihan: [
            'Agar tidak terlihat oleh api',
            'Karena udara bersih dengan oksigen tersisa berada di lapisan 30 cm terendah',
            'Supaya bisa merayap lebih cepat dari berlari',
            'Untuk menghindari reruntuhan genteng',
          ],
          indexJawabanBenar: 1,
          penjelasan: 'Gas panas dan karbon monoksida naik ke atas karena massa jenisnya yang lebih ringan saat bersuhu tinggi.',
        ),
        SoalKuis(
          pertanyaan: 'Jenis kebakaran apa yang DILARANG dipadamkan menggunakan media air biasa?',
          pilihan: [
            'Kebakaran tumpukan kertas kardus',
            'Kebakaran ranting kayu kering',
            'Kebakaran instalasi listrik beraliran aktif dan minyak goreng panas',
            'Kebakaran kain gorden',
          ],
          indexJawabanBenar: 2,
          penjelasan: 'Air menghantarkan arus listrik (dapat menyetrum) dan pada minyak panas air menyebabkan percikan ledakan uap (boilover).',
        ),
        SoalKuis(
          pertanyaan: 'Bila pakaian yang kamu kenakan tersambar api, apa teknik penyelamatan diri yang harus dilakukan?',
          pilihan: [
            'Lari sekencang-kencangnya ke arah angin',
            'Stop, Drop, and Roll (Berhenti, Menjatuhkan diri, dan Berguling-guling)',
            'Kipas pakaian dengan buku',
            'Menepuk-nepuk api dengan tangan kosong',
          ],
          indexJawabanBenar: 1,
          penjelasan: 'Berguling-guling di lantai memutus suplai oksigen yang menyalakan kain pakaian.',
        ),
        SoalKuis(
          pertanyaan: 'Nomor telepon darurat berapakah untuk memanggil Dinas Pemadam Kebakaran di Indonesia?',
          pilihan: [
            '110',
            '112 / 113',
            '118',
            '115',
          ],
          indexJawabanBenar: 1,
          penjelasan: 'Nomor 113 adalah kontak pemadam kebakaran dan 112 adalah panggilan darurat terpadu.',
        ),
      ],
    ),
    PaketKuis(
      id: 'kuis_banjir',
      judul: 'Kuis 3: Penyelamatan & Siaga Arus Banjir',
      kategori: 'Banjir',
      jumlahSoal: 5,
      batasWaktuMenit: 5,
      warnaHex: 0xFF1E88E5,
      daftarSoal: [
        SoalKuis(
          pertanyaan: 'Langkah pertama yang harus dilakukan di rumah saat air banjir mulai meluap masuk adalah...',
          pilihan: [
            'Menonton televisi untuk memantau berita',
            'Mematikan saklar utama listrik (MCB) dan mencabut steker alat elektronik',
            'Membuka semua pintu kamar mandi',
            'Menguras air menggunakan gayung secara manual',
          ],
          indexJawabanBenar: 1,
          penjelasan: 'Tindakan paling krusial untuk mencegah kematian akibat sengatan arus listrik di genangan air.',
        ),
        SoalKuis(
          pertanyaan: 'Arus banjir setinggi berapa centimeter yang sudah mampu menumbangkan orang dewasa?',
          pilihan: [
            '5 cm',
            '15 cm (setinggi betis berarus)',
            '100 cm',
            '150 cm',
          ],
          indexJawabanBenar: 1,
          penjelasan: 'Arus air setinggi 15 cm memiliki gaya dorong hidrolik yang cukup untuk membuat orang dewasa kehilangan keseimbangan.',
        ),
        SoalKuis(
          pertanyaan: 'Penyakit mematikan yang ditularkan melalui air kencing tikus di genangan banjir adalah...',
          pilihan: [
            'Leptospirosis',
            'Asma akut',
            'Hipertensi',
            'Osteoporosis',
          ],
          indexJawabanBenar: 0,
          penjelasan: 'Bakteri Leptospira masuk melalui luka terbuka atau selaput lendir saat kontak dengan air genangan banjir tercemar kencing tikus.',
        ),
        SoalKuis(
          pertanyaan: 'Berapa lama estimasi daya tahan persediaan di dalam "Tas Siaga Bencana" yang direkomendasikan BNPB?',
          pilihan: [
            '12 Jam',
            '24 Jam',
            '72 Jam (3 Hari)',
            '30 Hari',
          ],
          indexJawabanBenar: 2,
          penjelasan: 'Masa kritis bantuan SAR biasanya membutuhkan waktu hingga 72 jam pertama pascabencana.',
        ),
        SoalKuis(
          pertanyaan: 'Jika kendaraan mobil terjebak di tengah arus banjir bandang yang terus meninggi, tindakan terbaik adalah...',
          pilihan: [
            'Tetap diam di dalam mobil dan mengunci semua pintu rapat-rapat',
            'Menginjak gas sedalam mungkin melawan arus',
            'Segera tinggalkan mobil dan evakuasi diri ke tempat yang lebih tinggi',
            'Membuka kap mesin untuk memeriksa aki',
          ],
          indexJawabanBenar: 2,
          penjelasan: 'Mobil dapat terseret arus dengan mudah saat air mencapai ketinggian 30-60 cm.',
        ),
      ],
    ),
  ];

  // ================= DAFTAR ARTIKEL BERITA & TIPS =================
  static const List<BeritaTips> daftarBerita = [
    BeritaTips(
      id: 'tips_gempa',
      judul: '5 Hal Wajib Dilakukan Saat Guncangan Gempa Bumi Tiba-Tiba',
      ringkasan: 'Kenali tindakan aman merunduk, menutup kepala, dan mencari perlindungan di bawah meja kokoh.',
      konten: '''Saat gempa bumi terjadi secara tiba-tiba, waktu respons kita hanya beberapa detik sebelum guncangan puncak datang:

1. **Drop, Cover, Hold On:** Jangan ragu untuk segera merunduk di bawah meja. Tangan satu memegang kaki meja, tangan lainnya melindungi tengkuk leher.
2. **Jauhi Kaca dan Lampu Gantung:** Material kaca yang pecah berhamburan adalah penyebab luka sobek terbanyak pada korban gempa di dalam ruangan.
3. **Tetap di Dalam Sampai Guncangan Berhenti:** Jangan buru-buru berlari keluar gedung saat guncangan masih aktif karena puing dinding sering jatuh di depan pintu keluar.
4. **Matikan Kompor & Sumber Api Segera:** Jika kamu sedang memasak dan posisi kompor dekat, segera matikan api untuk mencegah kebakaran sekunder.
5. **Gunakan Tangga Darurat:** Selalu hindari lift! Tangga darurat adalah sarana evakuasi vertikal teraman yang dirancang tahan api dan beban gempa.''',
      tanggal: '08 Oktober 2026',
      kategori: 'Gempa Bumi',
      ikon: 'landscape_rounded',
    ),
    BeritaTips(
      id: 'tips_kebakaran',
      judul: 'Taktik Merangkak Menembus Asap & Cara Penggunaan APAR yang Benar',
      ringkasan: 'Ketahui cara memilih jalur evakuasi aman dan membedakan jenis api sebelum memadamkan.',
      konten: '''Bahaya terbesar dalam kebakaran gedung bukanlah jilatan apinya, melainkan kepulan gas karbon monoksida (CO) dan sianida yang timbul dari pembakaran plastik dan furnitur:

1. **Merangkak Rendah di Bawah Asap:** Gas beracun dan suhu panas akan terdorong ke bagian atas plafon. Lapisan udara terbersih berada pada 20-30 cm di atas lantai.
2. **Uji Suhu Daun Pintu:** Sebelum membuka pintu rute evakuasi, tempelkan punggung tanganmu ke daun pintu atau gagang logam. Jika terasa hangat/panas, JANGAN BUKA pintu tersebut karena ada api di baliknya!
3. **Teknik PASS Pengoperasian APAR:**
   - **P (Pull):** Cabut pin pengaman yang ada di tuas tabung.
   - **A (Aim):** Arahkan selang tepat ke dasar atau pusat kobaran api, bukan ke lidah apinya.
   - **S (Squeeze):** Tekan tuas untuk menyemprotkan bubuk pemadam secara penuh.
   - **S (Sweep):** Sapukan selang secara mendatar ke kiri dan kanan hingga api padam.''',
      tanggal: '06 Oktober 2026',
      kategori: 'Kebakaran',
      ikon: 'local_fire_department_rounded',
    ),
    BeritaTips(
      id: 'tips_tas_siaga',
      judul: 'Panduan Praktis Menyusun Tas Siaga Bencana (Survival Kit 72 Jam)',
      ringkasan: 'Daftar barang penting dan dokumen esensial yang wajib tersedia di dalam ransel darurat keluarga.',
      konten: '''Tas Siaga Bencana (TSB) adalah tas ransel tahan air yang dipersiapkan untuk bertahan hidup secara mandiri selama minimal 3 hari (72 jam) sebelum bantuan tiba:

1. **Air Minum & Makanan Siap Saji:** Biskuit berkalori tinggi, makanan kaleng yang tidak perlu dimasak, dan air mineral kemasan minimal 2 liter per orang.
2. **Kotak P3K & Obat Pribadi:** Perban, alkohol antiseptik, plester luka, obat pereda nyeri, dan obat resep rutin keluarga.
3. **Alat Penerangan & Komunikasi:** Senter LED (lengkap dengan baterai cadangan), peluit darurat pemanggil SAR, dan radio saku mini atau powerbank.
4. **Dokumen Berharga:** Fotokopi KK, KTP, ijazah, polis asuransi, dan uang tunai secukupnya dalam plastik ziplock kedap air.
5. **Pakaian & Higienis:** 1 stel pakaian ganti tebal, selimut termal, jas hujan ponco, masker medis, dan hand sanitizer.''',
      tanggal: '03 Oktober 2026',
      kategori: 'Kesiapsiagaan',
      ikon: 'backpack_rounded',
    ),
  ];

  // ================= DAFTAR NOMOR DARURAT NASIONAL =================
  static const List<Map<String, String>> nomorDarurat = [
    {
      'nomor': '112',
      'instansi': 'Panggilan Darurat Nasional',
      'deskripsi': 'Layanan tunggal bebas pulsa untuk segala situasi genting di seluruh kota.',
      'ikon': 'support_agent_rounded',
      'warna': '0xFFE53935',
    },
    {
      'nomor': '115',
      'instansi': 'BASARNAS (Pencarian & Pertolongan)',
      'deskripsi': 'Operasi SAR penyelamatan korban bencana alam, reruntuhan gedung, dan laut.',
      'ikon': 'search_rounded',
      'warna': '0xFFFF7043',
    },
    {
      'nomor': '113',
      'instansi': 'Pemadam Kebakaran (Damkar)',
      'deskripsi': 'Penanganan kebakaran gedung, pemukiman, serta evakuasi satwa liar dan pohon tumbang.',
      'ikon': 'local_fire_department_rounded',
      'warna': '0xFFD32F2F',
    },
    {
      'nomor': '118',
      'instansi': 'Ambulans Gawat Darurat & PMI',
      'deskripsi': 'Pertolongan pertama medis dan evakuasi korban luka gawat darurat ke rumah sakit.',
      'ikon': 'medical_services_rounded',
      'warna': '0xFF388E3C',
    },
    {
      'nomor': '110',
      'instansi': 'Kepolisian Negara RI',
      'deskripsi': 'Pengamanan ketertiban, pencegahan penjarahan saat bencana, dan blokade zona bahaya.',
      'ikon': 'local_police_rounded',
      'warna': '0xFF1976D2',
    },
    {
      'nomor': '119',
      'instansi': 'Layanan Krisis Medis Kemenkes',
      'deskripsi': 'Pusat komando tanggap darurat kesehatan masyarakat dan wabah bencana.',
      'ikon': 'health_and_safety_rounded',
      'warna': '0xFF00796B',
    },
  ];

  // ================= ITEM TAS SIAGA BENCANA CHECKLIST =================
  static const List<Map<String, dynamic>> checklistTasSiaga = [
    {'id': 'air', 'nama': 'Air Minum Bersih (Min. 2-3 Liter)', 'kategori': 'Konsumsi'},
    {'id': 'makanan', 'nama': 'Makanan Tahan Lama / Makanan Kaleng / Biskuit Kalori', 'kategori': 'Konsumsi'},
    {'id': 'p3k', 'nama': 'Kotak P3K & Obat Pribadi Lengkap', 'kategori': 'Kesehatan'},
    {'id': 'senter', 'nama': 'Senter LED + Baterai Cadangan', 'kategori': 'Peralatan'},
    {'id': 'peluit', 'nama': 'Peluit Darurat Tanpa Bola (Sinyal SAR)', 'kategori': 'Peralatan'},
    {'id': 'powerbank', 'nama': 'Powerbank & Kabel Charger Ponsel', 'kategori': 'Komunikasi'},
    {'id': 'dokumen', 'nama': 'Dokumen Penting (KTP/KK/Ijazah dlm Kantong Kedap Air)', 'kategori': 'Dokumen'},
    {'id': 'uang', 'nama': 'Uang Tunai Pecahan Kecil', 'kategori': 'Dokumen'},
    {'id': 'masker', 'nama': 'Masker Medis / N95 & Hand Sanitizer', 'kategori': 'Kesehatan'},
    {'id': 'pakaian', 'nama': 'Pakaian Hangat Ganti & Selimut Termal', 'kategori': 'Pakaian'},
    {'id': 'jas_hujan', 'nama': 'Jas Hujan Ponco Ringan', 'kategori': 'Pakaian'},
    {'id': 'pisau', 'nama': 'Pisau Lipat Serbaguna (Multi-tool)', 'kategori': 'Peralatan'},
  ];
}
