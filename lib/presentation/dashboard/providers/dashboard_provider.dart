import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/datasources/local/app_database.dart';
import '../../pos/providers/pos_provider.dart'; // Mengambil repo sales

// StreamProvider untuk memantau seluruh riwayat transaksi kasir
final salesHistoryStreamProvider = StreamProvider<List<Sale>>((ref) {
  final repository = ref.watch(salesRepositoryProvider);
  return repository.watchAllSales();
});
