import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../../data/repositories/stock_repository.dart';
import '../../../utils/currency_formatter.dart';
import 'providers/stock_provider.dart';
import 'widgets/stock_form_bottom_sheet.dart';

// Ubah menjadi ConsumerWidget
class StockScreen extends ConsumerWidget {
  const StockScreen({super.key});

  void _showForm(BuildContext context, [Stock? stock]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StockFormBottomSheet(existingStock: stock),
    );
  }

  void _deleteStock(BuildContext context, WidgetRef ref, Stock stock) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Barang?'),
        content: Text('Apakah Anda yakin ingin menghapus ${stock.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              // Memanggil fungsi hapus dari repository via provider
              final repo = ref.read(stockRepositoryProvider);
              await repo.deleteStock(stock);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pantau data stok secara langsung (Lebih bersih dari StreamBuilder!)
    final stocksAsyncValue = ref.watch(stocksStreamProvider);

    return Scaffold(
      body: stocksAsyncValue.when(
        data: (stocks) {
          if (stocks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Stok barang masih kosong.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: stocks.length,
            itemBuilder: (context, index) {
              final stock = stocks[index];
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Icon(
                      stock.category == 'Sparepart'
                          ? Icons.build_circle
                          : Icons.headphones,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    stock.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Kategori: ${stock.category} | Stok: ${stock.quantity} pcs',
                      ),
                      Text(
                        'Harga: ${CurrencyFormat.convertToIdr(stock.sellPrice)}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.blue,
                        ),
                        onPressed: () => _showForm(context, stock),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => _deleteStock(context, ref, stock),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Terjadi kesalahan: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Barang'),
      ),
    );
  }
}
