import 'package:flutter/material.dart'; // Wajib ada untuk mengenali widget Flutter [cite: 423]

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug [cite: 432]
      home: ProfilePage(), // Halaman utama yang pertama muncul [cite: 433]
    );
  }
}

// ==========================================
// 1. HALAMAN PROFIL (SCAFFOLD LENGKAP)
// ==========================================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'), // [cite: 460]
        actions: [
          IconButton(
            icon: const Icon(Icons.search), // Eksperimen: ganti ikon [cite: 504]
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer( // Slot panel samping [cite: 453, 467]
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer dulu [cite: 689]
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GalleryHome()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                // Tugas Mandiri 5: Dialog Konfirmasi [cite: 1021]
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Konfirmasi'),
                    content: const Text('Yakin ingin buka pengaturan?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView( // Agar bisa di-scroll dan tidak overflow [cite: 534, 557]
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Profil [cite: 562]
            const Center(
              child: Column(
                children: [
                  CircleAvatar( // Foto profil bulat [cite: 569, 1004]
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Text('Valdric Abirama', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), // [cite: 577]
                  Text('Mahasiswa Teknik Informatika @ UNPAS', style: TextStyle(color: Colors.grey)), // [cite: 581]
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Baris Statistik [cite: 583, 584]
            const Row(
              children: [
                Expanded(child: StatBox(label: 'Post', value: '12')), // [cite: 586]
                Expanded(child: StatBox(label: 'Teman', value: '128')),
                Expanded(child: StatBox(label: 'Like', value: '1.2K')),
              ],
            ),
            const SizedBox(height: 24),
            // Section Cards [cite: 591, 592]
            const SectionCard(icon: Icons.info_outline, title: 'Tentang Saya', content: 'Sedang belajar Flutter Pertemuan 2.'),
            const SectionCard(icon: Icons.school, title: 'Pendidikan', content: 'Universitas Pasundan\nTeknik Informatika'),
            // Tugas Mandiri 3: Skills dengan Wrap & Chip [cite: 1019]
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Skills', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 8),
                    Wrap( // Auto pindah baris saat penuh [cite: 969, 971]
                      spacing: 8,
                      children: [
                        Chip(label: Text('Flutter')),
                        Chip(label: Text('Laravel')),
                        Chip(label: Text('UI/UX')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80), // Ruang agar tidak tertutup FAB [cite: 614]
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton( // Tombol aksi utama [cite: 453, 481]
        onPressed: () {
          // Tugas Mandiri 4: SnackBar [cite: 1020]
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Edit profil belum tersedia')),
          );
        },
        child: const Icon(Icons.edit),
      ),
      bottomNavigationBar: BottomNavigationBar( // Navigasi bawah [cite: 453, 485]
        currentIndex: 1, // Highlight di menu Profil [cite: 486]
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}

// ==========================================
// 2. HELPER WIDGETS (KOMPONEN KECIL)
// ==========================================
class StatBox extends StatelessWidget { // Komponen statistik [cite: 619]
  final String label, value;
  const StatBox({super.key, required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    const SizedBox(height: 4),
    Text(label, style: TextStyle(color: Colors.grey.shade600)),
  ]);
}

class SectionCard extends StatelessWidget { // Komponen kartu informasi [cite: 636]
  final IconData icon;
  final String title, content;
  const SectionCard({super.key, required this.icon, required this.title, required this.content});
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile( // Baris standar leading-title-subtitle [cite: 1004]
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(content),
    ),
  );
}

// ==========================================
// 3. WIDGET GALLERY (KAMUS PRIBADI)
// ==========================================
class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [ // Data list kategori widget [cite: 700]
      ('Display', Icons.image, Colors.blue),
      ('Input', Icons.edit, Colors.green),
      ('Button', Icons.smart_button, Colors.orange),
      ('Feedback', Icons.notifications, Colors.purple),
      ('Layout', Icons.dashboard, Colors.teal),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Widget Gallery')),
      body: ListView.separated( // Daftar yang efisien [cite: 549, 716]
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final (name, icon, color) = categories[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
              title: Text(name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigasi ke demo kategori masing-masing [cite: 730, 746]
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Buka kategori $name')));
              },
            ),
          );
        },
      ),
    );
  }
}