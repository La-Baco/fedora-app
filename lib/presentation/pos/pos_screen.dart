import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../../utils/currency_formatter.dart';
import '../stock/providers/stock_provider.dart';
import 'providers/pos_provider.dart';
import '../../../services/printer_service.dart';

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> {
  final _searchController = TextEditingController();
  final _payController = TextEditingController();
  final _printerService = PrinterService();
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  double _change = 0;

  @override
  void dispose() {
    _searchController.dispose();
    _payController.dispose();
    super.dispose();
  }

  void _calculateChange(double total) {
    final pay = double.tryParse(_payController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    setState(() {
      _change = pay - total;
    });
  }

  void _showCheckoutDialog(double total) {
    _payController.clear();
    setState(() => _change = -total);
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Pembayaran Kasir'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Belanja:', style: TextStyle(fontSize: 16)),
                      Text(CurrencyFormat.convertToIdr(total), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _payController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      labelText: 'Uang Tunai (Rp)',
                      prefixIcon: Icon(Icons.money),
                    ),
                    onChanged: (val) {
                      final payString = val.replaceAll(RegExp(r'[^0-9]'), '');
                      final pay = double.tryParse(payString) ?? 0;
                      setDialogState(() {
                        _change = pay - total;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _change >= 0 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_change >= 0 ? 'Kembalian:' : 'Kurang:', style: const TextStyle(fontSize: 16)),
                        Text(
                          CurrencyFormat.convertToIdr(_change.abs()),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _change >= 0 ? Colors.green : Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: _change >= 0 ? () {
                    Navigator.pop(context);
                    _processCheckout(total);
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Selesaikan Pembayaran'),
                ),
              ],
            );
          }
        );
      }
    );
  }

  void _processCheckout(double total) async {
    final cart = ref.read(cartProvider);
    final payString = _payController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final pay = double.tryParse(payString) ?? 0;

    final repo = ref.read(salesRepositoryProvider);
    final items = cart.map((e) => {'stockId': e.stock.id, 'quantity': e.quantity}).toList();
    
    // Siapkan data untuk printer
    final printerItems = cart.map((e) => {
      'name': e.stock.name,
      'qty': e.quantity,
      'price': e.stock.sellPrice,
      'subtotal': e.stock.sellPrice * e.quantity
    }).toList();
    final double finalChange = _change;

    try {
      await repo.checkout(
        totalAmount: total,
        paymentAmount: pay,
        changeAmount: finalChange,
        items: items,
      );

      // 1. Kosongkan Keranjang Langsung
      ref.read(cartProvider.notifier).clearCart();
      _payController.clear();
      setState(() => _change = 0);

      // 2. Tutup BottomSheet Keranjang Jika di Mobile
      if (mounted) {
        final isDesktop = MediaQuery.of(context).size.width >= 800;
        if (!isDesktop && Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        // 3. Tampilkan Pop Up Sukses dengan Tombol Cetak
        _showSuccessDialog(finalChange, printerItems, total, pay);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memproses pembayaran: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showSuccessDialog(double change, List<Map<String, dynamic>> printerItems, double total, double pay) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 64),
            SizedBox(height: 16),
            Text('Pembayaran Berhasil!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Kembalian:'),
            const SizedBox(height: 8),
            Text(CurrencyFormat.convertToIdr(change.abs()), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.green)),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
            child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _printerService.printReceipt(
                  invoiceId: 'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  cashier: 'Admin',
                  paymentMethod: 'Tunai',
                  totalAmount: total,
                  paymentAmount: pay,
                  changeAmount: change.abs(),
                  discountAmount: 0,
                  items: printerItems
                );
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mencetak: $e')));
                }
              }
            },
            icon: const Icon(Icons.print),
            label: const Text('Cetak Resi', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      )
    );
  }

  Widget _buildProductGrid(BuildContext context, ThemeData theme, AsyncValue<List<Stock>> stocksAsync) {
    return Column(
      children: [
        // SEARCH & FILTER BAR
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari Produk / Scan Barcode...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: theme.scaffoldBackgroundColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  suffixIcon: _searchQuery.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.clear), 
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        }
                      ) 
                    : null,
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Semua', 'Aksesoris', 'Sparepart'].map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(cat, style: TextStyle(
                          color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        )),
                        selected: isSelected,
                        onSelected: (val) => setState(() => _selectedCategory = cat),
                        selectedColor: theme.primaryColor,
                        backgroundColor: theme.scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        side: BorderSide(color: isSelected ? theme.primaryColor : Colors.grey.shade300),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        // GRID PRODUK
        Expanded(
          child: stocksAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (stocks) {
              var filteredStocks = stocks.where((s) => s.quantity > 0).toList();
              if (_selectedCategory != 'Semua') {
                filteredStocks = filteredStocks.where((s) => s.category == _selectedCategory).toList();
              }
              if (_searchQuery.isNotEmpty) {
                filteredStocks = filteredStocks.where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
              }

              if (filteredStocks.isEmpty) return const Center(child: Text('Barang tidak ditemukan.'));

              return LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 800 ? 5 : (constraints.maxWidth > 500 ? 4 : 2);
                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 1.15,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredStocks.length,
                    itemBuilder: (context, index) {
                      final item = filteredStocks[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade100, width: 1.5),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              ref.read(cartProvider.notifier).addToCart(item);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${item.name} ditambahkan!'),
                                  duration: const Duration(milliseconds: 600),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFF1A1A1A),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: theme.primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(item.category, style: TextStyle(color: theme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                      Icon(
                                        item.category == 'HP Baru' ? Icons.smartphone 
                                          : (item.category == 'Aksesoris' ? Icons.headphones : Icons.build),
                                        size: 18,
                                        color: Colors.grey.shade400,
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text('Sisa stok: ${item.quantity}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(CurrencyFormat.convertToIdr(item.sellPrice), style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.green, fontSize: 15, letterSpacing: -0.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Color(0xFFD72323), Color(0xFF1A1A1A)],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.add, color: Colors.white, size: 18),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              );
            },
          ),
        ),
      ],
    );
  }
          
  Widget _buildCart(BuildContext context, ThemeData theme, List<CartItem> cart, double totalAmount) {
    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A1A1A), Color(0xFFD72323)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            width: double.infinity,
            child: Row(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Keranjang Belanja', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                  child: Text('${cart.length} Item', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Expanded(
            child: cart.isEmpty 
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Keranjang Masih Kosong', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                )
              : ListView.separated(
                  itemCount: cart.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = cart[index];
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.stock.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text(CurrencyFormat.convertToIdr(item.stock.sellPrice), style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: theme.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 18),
                                  onPressed: () => ref.read(cartProvider.notifier).updateQuantity(item.stock, item.quantity - 1),
                                ),
                                Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 18),
                                  onPressed: () => ref.read(cartProvider.notifier).updateQuantity(item.stock, item.quantity + 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          ),
          
          // CHECKOUT BAR GLASSMORPHISM
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), offset: const Offset(0, -10), blurRadius: 24)],
                  border: Border(top: BorderSide(color: Colors.white.withOpacity(0.5), width: 1.5)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Tagihan', style: TextStyle(fontSize: 16, color: Colors.grey)),
                        Text(CurrencyFormat.convertToIdr(totalAmount), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.red)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: cart.isEmpty ? null : () => _showCheckoutDialog(totalAmount),
                        icon: const Icon(Icons.point_of_sale),
                        label: const Text('PROSES PEMBAYARAN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stocksAsync = ref.watch(stocksStreamProvider);
    final cart = ref.watch(cartProvider);
    final theme = Theme.of(context);
    double totalAmount = cart.fold(0, (sum, item) => sum + (item.stock.sellPrice * item.quantity));
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: isDesktop ? null : AppBar(
        title: const Text('Kasir', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 24, letterSpacing: -0.5)),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFD72323), Color(0xFF1A1A1A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        actionsIconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${cart.length}'),
              isLabelVisible: cart.isNotEmpty,
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: Consumer(
                    builder: (context, ref, _) {
                      final currentCart = ref.watch(cartProvider);
                      double currentTotal = currentCart.fold(0, (sum, item) => sum + (item.stock.sellPrice * item.quantity));
                      return _buildCart(context, theme, currentCart, currentTotal);
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 6,
            child: _buildProductGrid(context, theme, stocksAsync),
          ),
          if (isDesktop)
            Expanded(
              flex: 4,
              child: _buildCart(context, theme, cart, totalAmount),
            ),
        ],
      ),
    );
  }
}
