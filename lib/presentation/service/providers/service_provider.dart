import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/datasources/local/app_database.dart';
import '../../../../data/repositories/service_repository.dart';
import '../../../../main.dart'; // Untuk memanggil appDatabase global

// Provider untuk Repository Servis
final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository(appDatabase);
});

// StreamProvider untuk menampilkan daftar antrean servis di layar utama
final servicesStreamProvider = StreamProvider<List<Service>>((ref) {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.watchAllServices();
});
