import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan Aplikasi')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // SEGMEN 1: PERANGKAT
          const Text(
            'Perangkat & Cetak',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.print, color: Colors.white, size: 20),
              ),
              title: const Text('Printer Bluetooth'),
              subtitle: const Text('Hubungkan printer thermal untuk nota'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Modul integrasi printer akan segera hadir.'),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // SEGMEN 2: DATABASE & KEAMANAN
          const Text(
            'Data & Keamanan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.backup, color: Colors.white, size: 20),
                  ),
                  title: const Text('Backup Data'),
                  subtitle: const Text('Simpan cadangan database ke memori'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Fitur pencadangan data sedang disiapkan.',
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.restore, color: Colors.white, size: 20),
                  ),
                  title: const Text('Restore Data'),
                  subtitle: const Text('Kembalikan data dari file cadangan'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur pemulihan data sedang disiapkan.'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // SEGMEN 3: TENTANG APLIKASI
          const Text(
            'Tentang',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.info, color: Colors.white, size: 20),
              ),
              title: Text('Versi Aplikasi'),
              subtitle: Text('Konter Fedora v1.0.0'),
            ),
          ),
        ],
      ),
    );
  }
}
