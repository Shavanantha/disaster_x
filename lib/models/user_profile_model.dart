class UserProfile {
  final String nama;
  final String nim;
  final String sekolah;
  final String kelas;
  final bool isGuest;

  const UserProfile({
    required this.nama,
    required this.nim,
    required this.sekolah,
    required this.kelas,
    this.isGuest = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'nim': nim,
      'sekolah': sekolah,
      'kelas': kelas,
      'isGuest': isGuest,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      nama: map['nama'] as String? ?? 'Shava Phiyan Anantha',
      nim: map['nim'] as String? ?? '2413025047',
      sekolah: map['sekolah'] as String? ?? 'Universitas Lampung',
      kelas: map['kelas'] as String? ?? 'Mobile Programming A',
      isGuest: map['isGuest'] as bool? ?? false,
    );
  }

  UserProfile copyWith({
    String? nama,
    String? nim,
    String? sekolah,
    String? kelas,
    bool? isGuest,
  }) {
    return UserProfile(
      nama: nama ?? this.nama,
      nim: nim ?? this.nim,
      sekolah: sekolah ?? this.sekolah,
      kelas: kelas ?? this.kelas,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}

class RiwayatSkorItem {
  final String id;
  final String judul;
  final String kategori; // 'Kuis' atau 'Simulasi'
  final int skor;
  final int skorMaksimal;
  final String tanggal;
  final String status;

  const RiwayatSkorItem({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.skor,
    required this.skorMaksimal,
    required this.tanggal,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'kategori': kategori,
      'skor': skor,
      'skorMaksimal': skorMaksimal,
      'tanggal': tanggal,
      'status': status,
    };
  }

  factory RiwayatSkorItem.fromMap(Map<String, dynamic> map) {
    return RiwayatSkorItem(
      id: map['id'] as String? ?? '',
      judul: map['judul'] as String? ?? '',
      kategori: map['kategori'] as String? ?? 'Kuis',
      skor: map['skor'] as int? ?? 0,
      skorMaksimal: map['skorMaksimal'] as int? ?? 100,
      tanggal: map['tanggal'] as String? ?? '',
      status: map['status'] as String? ?? 'Selesai',
    );
  }
}
