import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../../utils/currency_formatter.dart';
import '../stock/providers/stock_provider.dart';
import 'providers/pos_provider.dart';

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> {
  final _payController = TextEditingController();
  double _change = 0;

  void _calculateChange(double total) {
    final pay = double.tryParse(_payController.text) ?? 0;
    setState(() {
      _change = pay - total;
    });
  }

  void _processCheckout(double total) async {
    final cart = ref.read(cartProvider);
    final pay = double.tryParse(_payController.text) ?? 0;

    if (pay < total) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Uang pembayaran kurang!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final repo = ref.read(salesRepositoryProvider);
    final items = cart
        .map((e) => {'stockId': e.stock.id, 'quantity': e.quantity})
        .toList();

    await repo.checkout(
      totalAmount: total,
      paymentAmount: pay,
      changeAmount: _change,
      items: items,
    );

    ref.read(cartProvider.notifier).clearCart();
    _payController.clear();
    setState(() => _change = 0);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaksi Berhasil Disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final stocksAsync = ref.watch(stocksStreamProvider);
    final cart = ref.watch(cartProvider);

    // Hitung total belanjaan saat ini
    double totalAmount = 0;
    for (var item in cart) {
      totalAmount += item.stock.sellPrice * item.quantity;
    }

    return Scaffold(
      body: Row(
        children: [
          // SEBELAH KIRI: Daftar Produk yang dijual (Aksesoris/Sparepart)
          Expanded(
            flex: 6,
            child: stocksAsync.when(
              data: (stocks) {
                // Tampilkan hanya barang yang stoknya masih tersedia (>0)
                final availableStocks = stocks
                    .where((s) => s.quantity > 0)
                    .toList();

                if (availableStocks.isEmpty) {
                  return const Center(
                    child: Text('Stok barang jualan kosong.'),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: availableStocks.length,
                  itemBuilder: (context, index) {
                    final item = availableStocks[index];
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () =>
                            ref.read(cartProvider.notifier).addToCart(item),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.category,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Text(
                                'Sisa: ${item.quantity} pcs',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                CurrencyFormat.convertToIdr(item.sellPrice),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),

          // SEBELAH KANAN: Panel Keranjang Belanja & Pembayaran Kasir
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(left: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Keranjang Kasir',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Divider(height: 1),

                  // Daftar Item dalam keranjang
                  Expanded(
                    child: cart.isEmpty
                        ? const Center(
                            child: Text(
                              'Keranjang Kosong',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: cart.length,
                            itemBuilder: (context, index) {
                              final item = cart[index];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                title: Text(
                                  item.stock.name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  CurrencyFormat.convertToIdr(
                                    item.stock.sellPrice,
                                  ),
                                  style: const TextStyle(fontSize: 11),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => ref
                                          .read(cartProvider.notifier)
                                          .updateQuantity(
                                            item.stock,
                                            item.quantity - 1,
                                          ),
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                        size: 18,
                                        color: Colors.green,
                                      ),
                                      onPressed: () => ref
                                          .read(cartProvider.notifier)
                                          .updateQuantity(
                                            item.stock,
                                            item.quantity + 1,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),

                  const Divider(height: 1),

                  // Bagian Hitung Pembayaran Ringkasan Ringkas
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              CurrencyFormat.convertToIdr(totalAmount),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _payController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 13),
                          decoration: const InputDecoration(
                            labelText: 'Uang Bayar',
                            prefixText: 'Rp ',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          onChanged: (_) => _calculateChange(totalAmount),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Kembalian:',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              CurrencyFormat.convertToIdr(
                                _change < 0 ? 0 : _change,
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _change < 0 ? Colors.red : Colors.blue,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: cart.isEmpty
                              ? null
                              : () => _processCheckout(totalAmount),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'BAYAR NOW',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
