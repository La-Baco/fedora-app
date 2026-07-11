import 'package:flutter/material.dart';
import '../presentation/main_screen.dart';
import '../presentation/service/add_service_screen.dart';
import '../presentation/service/service_detail_screen.dart';
import '../presentation/reports/reports_screen.dart';
import '../presentation/settings/settings_screen.dart'; // Import layar setting
import '../data/datasources/local/app_database.dart'; // Untuk model Service

class AppRoutes {
  // Deklarasi nama-nama rute
  static const String main = '/';
  static const String addService = '/add-service';
  static const String serviceDetail = '/service-detail';
  static const String report = '/report';
  static const String settings = '/settings'; // Rute baru untuk Settings

  // Fungsi pengatur lalu lintas halaman
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return MaterialPageRoute(builder: (_) => const MainScreen());

      case addService:
        return MaterialPageRoute(builder: (_) => const AddServiceScreen());

      case serviceDetail:
        // Menangkap data service yang dikirim saat navigasi
        final service = settings.arguments as Service;
        return MaterialPageRoute(
          builder: (_) => ServiceDetailScreen(service: service),
        );

      case report:
        return MaterialPageRoute(builder: (_) => const ReportScreen());

      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      default:
        // Halaman *error* jika rute tidak ditemukan
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Halaman tidak ditemukan!')),
          ),
        );
    }
  }
}
