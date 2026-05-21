import 'package:flutter/material.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          // Foto Profil dengan Container Lingkaran (Lat 2)
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade100,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
              ],
            ),
            child: const Center(
              child: Icon(Icons.person, size: 80, color: Colors.blue),
            ),
          ),
          const SizedBox(height: 16),
          // Nama dan Jabatan (Lat 1)
          const Text(
            'Valdric Abirama',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Informatics Student @ UNPAS',
            style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),
          // Kartu Detail (Lat 2 & 3)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.email, 'Email', 'valdric@unpas.ac.id'),
                  const Divider(),
                  _buildInfoRow(Icons.phone, 'Phone', '+62 812 3456 7890'),
                  const Divider(),
                  _buildInfoRow(Icons.location_on, 'Location', 'Bandung, Indonesia'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk Baris Informasi (Lat 3: Row)
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}