import 'package:flutter/material.dart';
import 'dashboard/dashboard_screen.dart';
import 'pos/pos_screen.dart';
import 'service/service_screen.dart';
import 'stock/stock_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Menghubungkan semua halaman yang sudah selesai dibuat
  final List<Widget> _screens = [
    const DashboardScreen(),
    const PosScreen(),
    const ServiceScreen(),
    const StockScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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
            icon: Icon(Icons.build_circle_outlined), 
            selectedIcon: Icon(Icons.build_circle), 
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