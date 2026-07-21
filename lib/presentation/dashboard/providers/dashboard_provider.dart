import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/datasources/local/app_database.dart';
import '../../pos/providers/pos_provider.dart'; // Mengambil repo sales
import '../../service/providers/service_provider.dart';

// StreamProvider untuk memantau seluruh riwayat transaksi kasir
final salesHistoryStreamProvider = StreamProvider<List<Sale>>((ref) {
  final repository = ref.watch(salesRepositoryProvider);
  return repository.watchAllSales();
});

class DebtCustomer {
  final Service service;
  final double totalCost;

  DebtCustomer(this.service, this.totalCost);
}

final debtCustomersProvider = FutureProvider<List<DebtCustomer>>((ref) async {
  final servicesAsync = ref.watch(servicesStreamProvider);
  final services = servicesAsync.value ?? [];
  final debtServices = services.where((s) => s.status == 'Hutang').toList();
  
  final repository = ref.read(serviceRepositoryProvider);
  
  List<DebtCustomer> result = [];
  for (var s in debtServices) {
    final parts = await repository.getSparepartsForService(s.id);
    double partsCost = parts.fold(0, (sum, p) => sum + (p.price * p.quantity));
    result.add(DebtCustomer(s, s.serviceFee + partsCost));
  }
  return result;
});
