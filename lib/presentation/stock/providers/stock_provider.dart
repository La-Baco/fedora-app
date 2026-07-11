import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/datasources/local/app_database.dart';
import '../../../../data/repositories/stock_repository.dart';
import '../../../../main.dart'; // Untuk mengambil appDatabase global

// Provider untuk menjembatani Repository
final stockRepositoryProvider = Provider<StockRepository>((ref) {
  return StockRepository(appDatabase);
});

// StreamProvider untuk memantau perubahan data stok secara otomatis (Real-time)
final stocksStreamProvider = StreamProvider<List<Stock>>((ref) {
  final repository = ref.watch(stockRepositoryProvider);
  return repository.watchAllStocks();
});
