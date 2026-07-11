import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'data/datasources/local/app_database.dart';
import 'routes/app_router.dart'; 

// Mendeklarasikan database secara global agar mudah diakses
late AppDatabase appDatabase;

void main() {
  // Wajib dipanggil sebelum menginisialisasi hal lain di Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Membangunkan database saat aplikasi pertama kali dibuka
  appDatabase = AppDatabase();

  // Membungkus aplikasi dengan ProviderScope untuk mengaktifkan Riverpod
  runApp(const ProviderScope(child: FedoraApp()));
}

class FedoraApp extends StatelessWidget {
  const FedoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Konter Fedora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,

      // Menggunakan sistem Route modern yang sudah kita buat di app_router.dart
      initialRoute: AppRoutes.main,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
