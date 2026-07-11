import 'package:flutter/material.dart';
import 'stock/stock_screen.dart';
import 'service/service_screen.dart';
import 'pos/pos_screen.dart';
import 'dashboard/dashboard_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Daftar layar (halaman) yang akan ditukar-tukar saat menu bawah diklik.
  // Untuk sementara kita isi dengan "Placeholder" (Layar Kosong) sebelum kita buat desain aslinya.
  final List<Widget> _screens = [
    const Center(child: Text('Layar Dasbor & Analitik (Segera Hadir)')),
    const Center(child: Text('Layar POS Kasir (Segera Hadir)')),
    const Center(child: Text('Layar Manajemen Servis (Segera Hadir)')),
    const Center(child: Text('Layar Stok Barang (Segera Hadir)')),
    const StockScreen(),
    const ServiceScreen(),
    const PosScreen(),
    const DashboardScreen(),
  ];

  // Fungsi untuk mengubah layar saat ikon diklik
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar di sini akan berlaku untuk semua layar secara otomatis
      appBar: AppBar(title: const Text('Konter Fedora')),

      // Menampilkan layar sesuai urutan menu yang diklik
      body: _screens[_currentIndex],

      // Desain Navigasi Bawah Modern (Material 3)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTap,
        backgroundColor: Colors.white,
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dasbor',
          ),
          NavigationDestination(
            icon: Icon(Icons.point_of_sale_outlined),
            selectedIcon: Icon(Icons.point_of_sale),
            label: 'Kasir',
          ),
          NavigationDestination(
            icon: Icon(Icons.build_outlined),
            selectedIcon: Icon(Icons.build),
            label: 'Servis',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Stok',
          ),
        ],
      ),
    );
  }
}
