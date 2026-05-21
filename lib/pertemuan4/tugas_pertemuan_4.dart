import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ==========================================
// MODEL DATA (DIPERLUAS DENGAN EMAIL)
// ==========================================
class Catatan {
  String judul;
  String isi;
  String kategori;
  String emailPengirim;
  DateTime dibuatPada;

  Catatan({
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.emailPengirim,
    required this.dibuatPada,
  });
}

// ==========================================
// UTAMA (APP RUNNER & ROUTING)
// ==========================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/form':
          // Bisa menerima argumen Map berupa data catatan lama dan indexnya untuk mode EDIT
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => FormCatatanPage(
                catatanLama: args?['catatan'] as Catatan?,
                indexCatatan: args?['index'] as int?,
              ),
            );
          case '/detail':
          // Menerima data Map berisi objek catatan dan index untuk navigasi ke Edit dari Detail
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(
                catatan: args['catatan'] as Catatan,
                indexCatatan: args['index'] as int,
              ),
            );
        }
        return null;
      },
    );
  }
}

// ==========================================
// HALAMAN 1: HOME PAGE (STATEFUL + SEARCH + FILTER)
// ==========================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // === STATE DATA UTAMA ===
  final List<Catatan> _semuaCatatan = [
    Catatan(
      judul: 'Belajar Flutter Dasar',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation pada Pertemuan 3 Praktikum SAB.',
      kategori: 'Kuliah',
      emailPengirim: 'valdric@unpas.ac.id',
      dibuatPada: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Catatan(
      judul: 'Tugas Besar Cashier App',
      isi: 'Selesaikan integrasi GitHub dan rapihin UI Flutter untuk project tubes_sab malam ini.',
      kategori: 'Tugas',
      emailPengirim: 'valdric.dandi@gmail.com',
      dibuatPada: DateTime.now(),
    ),
  ];

  // === STATE UNTUK FILTER & SEARCH ===
  String _kategoriFilter = 'Semua';
  final List<String> _filterOpsi = const ['Semua', 'Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  final _searchCtrl = TextEditingController();
  String _queryPencarian = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _formatTanggal(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  // Menghimpun data yang sudah disaring berdasarkan Filter Kategori & Query Search
  List<Catatan> get _catatanTerfilter {
    return _semuaCatatan.where((c) {
      final cocokKategori = _kategoriFilter == 'Semua' || c.kategori == _kategoriFilter;
      final cocokSearch = c.judul.toLowerCase().contains(_queryPencarian.toLowerCase()) ||
          c.isi.toLowerCase().contains(_queryPencarian.toLowerCase());
      return cocokKategori && cocokSearch;
    }).toList();
  }

  // Buka form untuk TAMBAH CATATAN
  Future<void> _bukaTambahForm() async {
    final hasil = await Navigator.pushNamed(context, '/form');

    if (hasil is Catatan) {
      setState(() {
        _semuaCatatan.add(hasil);
      });
      if (!mounted) return;
      _showSnackBar('Catatan "${hasil.judul}" berhasil ditambahkan!');
    }
  }

  // Buka form untuk EDIT CATATAN
  Future<void> _bukaEditForm(Catatan catatan, int indexAsli) async {
    final hasil = await Navigator.pushNamed(
        context,
        '/form',
        arguments: {'catatan': catatan, 'index': indexAsli}
    );

    if (hasil is Catatan) {
      setState(() {
        _semuaCatatan[indexAsli] = hasil;
      });
      if (!mounted) return;
      _showSnackBar('Catatan "${hasil.judul}" berhasil diperbarui!');
    }
  }

  void _hapusCatatan(int indexAsli, String judul) {
    setState(() {
      _semuaCatatan.removeAt(indexAsli);
    });
    _showSnackBar('Catatan "$judul" telah dihapus', isDelete: true);
  }

  void _showSnackBar(String pesan, {bool isDelete = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDelete ? Colors.red.shade700 : Colors.indigo.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Mahasiswa', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Dropdown Filter Kategori di AppBar
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<String>(
              value: _kategoriFilter,
              underline: const SizedBox(),
              icon: const Icon(Icons.filter_list, color: Colors.indigo),
              style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
              items: _filterOpsi.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() => _kategoriFilter = newValue);
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Real-time Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Cari catatan...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _queryPencarian.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _queryPencarian = '');
                  },
                )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() => _queryPencarian = value);
              },
            ),
          ),

          // List Catatan / Empty State
          Expanded(
            child: _catatanTerfilter.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_alt_outlined, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada catatan ditemukan',
                    style: TextStyle(fontSize: 17, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    _queryPencarian.isNotEmpty || _kategoriFilter != 'Semua'
                        ? 'Coba ubah kata kunci pencarian atau filter'
                        : 'Tekan tombol + di bawah untuk menambah',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: _catatanTerfilter.length,
              itemBuilder: (context, i) {
                final c = _catatanTerfilter[i];
                // Mencari index asli di list utama (_semuaCatatan) agar aksi edit/hapus tidak salah alamat
                final indexAsli = _semuaCatatan.indexOf(c);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.shade50,
                      child: Icon(
                        c.kategori == 'Kuliah' ? Icons.school :
                        c.kategori == 'Tugas' ? Icons.assignment :
                        c.kategori == 'Pribadi' ? Icons.person : Icons.label,
                        color: Colors.indigo,
                      ),
                    ),
                    title: Text(
                      c.judul,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('${c.kategori} • Oleh: ${c.emailPengirim}',
                            style: TextStyle(color: Colors.indigo.shade700, fontSize: 11),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(_formatTanggal(c.dibuatPada), style: const TextStyle(fontSize: 11, color: Colors.black54)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: Colors.orangeAccent),
                          onPressed: () => _bukaEditForm(c, indexAsli),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () => _hapusCatatan(indexAsli, c.judul),
                        ),
                      ],
                    ),
                    onTap: () async {
                      // Kirim data dan callback kembali ke halaman detail
                      await Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: {'catatan': c, 'index': indexAsli}
                      );
                      // Refresh halaman utama ketika pulang dari detail (siapa tahu datanya di-edit di sana)
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaTambahForm,
        label: const Text('Tambah'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

// ==========================================
// HALAMAN 2: FORM PAGE (TAMBAH & EDIT MULTI-USE + REGEX EMAIL)
// ==========================================
class FormCatatanPage extends StatefulWidget {
  final Catatan? catatanLama;
  final int? indexCatatan;

  const FormCatatanPage({super.key, this.catatanLama, this.indexCatatan});

  @override
  State<FormCatatanPage> createState() => _FormCatatanPageState();
}

class _FormCatatanPageState extends State<FormCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulCtrl;
  late TextEditingController _isiCtrl;
  late TextEditingController _emailCtrl;
  late String _kategori;

  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];
  bool get _isEditMode => widget.catatanLama != null;

  @override
  void Pentecostal() {}

  @override
  void initState() {
    super.initState();
    // Jika Mode Edit, isi field langsung dengan data lama. Jika tidak, kosongkan.
    _judulCtrl = TextEditingController(text: widget.catatanLama?.judul ?? '');
    _isiCtrl = TextEditingController(text: widget.catatanLama?.isi ?? '');
    _emailCtrl = TextEditingController(text: widget.catatanLama?.emailPengirim ?? '');
    _kategori = widget.catatanLama?.kategori ?? 'Kuliah';
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final catatanData = Catatan(
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      emailPengirim: _emailCtrl.text.trim(),
      dibuatPada: widget.catatanLama?.dibuatPada ?? DateTime.now(), // Pertahankan tgl lama kalau edit
    );

    Navigator.pop(context, catatanData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Catatan' : 'Tambah Catatan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                if (v.trim().length < 3) return 'Minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: _kategoriOpsi
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _kategori = v!),
            ),
            const SizedBox(height: 16),
            // FITUR TUGAS MANDIRI: VALIDASI EMAIL DENGAN REGEX
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Pengirim',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
                hintText: 'contoh@unpas.ac.id',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                // Pattern Regex Validasi Email standar
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(v.trim())) return 'Format email tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _isiCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi Catatan',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Isi wajib diisi' : null,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _simpan,
              icon: Icon(_isEditMode ? Icons.update : Icons.save),
              label: Text(_isEditMode ? 'Perbarui Catatan' : 'Simpan Catatan', style: const TextStyle(fontSize: 16)),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: _isEditMode ? Colors.orange.shade800 : Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// HALAMAN 3: DETAIL CATATAN PAGE (DENGAN AKSES EDIT)
// ==========================================
class DetailCatatanPage extends StatefulWidget {
  final Catatan catatan;
  final int indexCatatan;

  const DetailCatatanPage({super.key, required this.catatan, required this.indexCatatan});

  @override
  State<DetailCatatanPage> createState() => _DetailCatatanPageState();
}

class _DetailCatatanPageState extends State<DetailCatatanPage> {
  late Catatan _currentCatatan;

  @override
  void initState() {
    super.initState();
    _currentCatatan = widget.catatan;
  }

  String formatDetailTanggal(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} pukul ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          // Bisa langsung lompat ke form edit dari halaman detail
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final hasil = await Navigator.pushNamed(
                  context,
                  '/form',
                  arguments: {'catatan': _currentCatatan, 'index': widget.indexCatatan}
              );

              if (hasil is Catatan) {
                setState(() {
                  _currentCatatan = hasil; // Update UI detail setempat
                });
                // Kabari halaman Home kalau data di dalam sini berubah
                if (!mounted) return;
                final route = ModalRoute.of(context);
                if (route != null) {
                  // Memicu trigger passing balik data tak langsung lewat route argument objek utama
                  route.settings.arguments.toString();
                }
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentCatatan.judul,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Chip(
                  label: Text(_currentCatatan.kategori),
                  backgroundColor: Colors.indigo.shade50,
                  side: BorderSide(color: Colors.indigo.shade100),
                  labelStyle: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                ),
                Text(
                  formatDetailTanggal(_currentCatatan.dibuatPada),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.account_circle, size: 18, color: Colors.black54),
                const SizedBox(width: 6),
                Text('Kontak: ${_currentCatatan.emailPengirim}', style: const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
            const Divider(height: 40, thickness: 1.2),
            Text(
              _currentCatatan.isi,
              style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
            ),
            const SizedBox(height: 40),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali ke Daftar'),
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            )
          ],
        ),
      ),
    );
  }
}