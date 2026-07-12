import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../../data/repositories/stock_repository.dart';
import '../../../utils/currency_formatter.dart';
import 'providers/stock_provider.dart';
import 'widgets/stock_form_bottom_sheet.dart';

class StockScreen extends ConsumerStatefulWidget {
  const StockScreen({super.key});

  @override
  ConsumerState<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends ConsumerState<StockScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  String _sortBy = 'Nama (A-Z)';

  final List<String> _categories = ['Semua', 'Aksesoris', 'Sparepart'];
  final List<String> _sortOptions = ['Nama (A-Z)', 'Nama (Z-A)', 'Stok Paling Sedikit', 'Stok Paling Banyak'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  void _deleteStock(BuildContext context, Stock stock) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Barang?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin menghapus ${stock.name}? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
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
  Widget build(BuildContext context) {
    final stocksAsyncValue = ref.watch(stocksStreamProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Stok', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 24, letterSpacing: -0.5)),
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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Filter & Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari barang...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: theme.scaffoldBackgroundColor,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    suffixIcon: _searchQuery.isNotEmpty 
                      ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        })
                      : null,
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Kategori',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                        items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (val) => setState(() => _selectedCategory = val!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _sortBy,
                        decoration: InputDecoration(
                          labelText: 'Urutkan',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                        items: _sortOptions.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13)))).toList(),
                        onChanged: (val) => setState(() => _sortBy = val!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Daftar Stok
          Expanded(
            child: stocksAsyncValue.when(
              data: (stocks) {
                // Filter
                var filteredStocks = stocks;
                if (_selectedCategory != 'Semua') {
                  filteredStocks = filteredStocks.where((s) => s.category == _selectedCategory).toList();
                }
                if (_searchQuery.isNotEmpty) {
                  filteredStocks = filteredStocks.where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
                }

                // Sort
                filteredStocks = List.from(filteredStocks);
                if (_sortBy == 'Nama (A-Z)') {
                  filteredStocks.sort((a, b) => a.name.compareTo(b.name));
                } else if (_sortBy == 'Nama (Z-A)') {
                  filteredStocks.sort((a, b) => b.name.compareTo(a.name));
                } else if (_sortBy == 'Stok Paling Sedikit') {
                  filteredStocks.sort((a, b) => a.quantity.compareTo(b.quantity));
                } else if (_sortBy == 'Stok Paling Banyak') {
                  filteredStocks.sort((a, b) => b.quantity.compareTo(a.quantity));
                }

                if (filteredStocks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text('Tidak ada barang ditemukan.', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                      ],
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 800) {
                      // DESKTOP: DATA TABLE
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(theme.primaryColor.withOpacity(0.05)),
                            columns: const [
                              DataColumn(label: Text('Nama Barang', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Stok', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Harga Jual', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: filteredStocks.map((stock) {
                              final bool isOutOfStock = stock.quantity == 0;
                              final bool isLowStock = stock.quantity > 0 && stock.quantity <= 5;
                              
                              return DataRow(
                                cells: [
                                  DataCell(Text(stock.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                                  DataCell(Text(stock.category)),
                                  DataCell(
                                    Row(
                                      children: [
                                        Text('${stock.quantity} pcs', style: TextStyle(fontWeight: FontWeight.bold, color: isOutOfStock || isLowStock ? Colors.red : Colors.black87)),
                                        const SizedBox(width: 8),
                                        if (isOutOfStock)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                            child: const Text('HABIS', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                                          )
                                        else if (isLowStock)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                            child: const Text('MENIPIS', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                                          )
                                      ],
                                    ),
                                  ),
                                  DataCell(Text(CurrencyFormat.convertToIdr(stock.sellPrice), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue, size: 20), onPressed: () => _showForm(context, stock)),
                                        IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 20), onPressed: () => _deleteStock(context, stock)),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    } else {
                      // MOBILE: LIST VIEW
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredStocks.length,
                        itemBuilder: (context, index) {
                          final stock = filteredStocks[index];
                          final bool isOutOfStock = stock.quantity == 0;
                          final bool isLowStock = stock.quantity > 0 && stock.quantity <= 5;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              leading: CircleAvatar(
                                backgroundColor: isOutOfStock ? Colors.red.withOpacity(0.1) : (isLowStock ? Colors.orange.withOpacity(0.1) : theme.colorScheme.primaryContainer),
                                child: Icon(
                                  stock.category == 'Sparepart' ? Icons.build_circle : Icons.headphones,
                                  color: isOutOfStock ? Colors.red : (isLowStock ? Colors.orange : theme.colorScheme.primary),
                                ),
                              ),
                              title: Text(
                                stock.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: theme.primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(stock.category, style: TextStyle(fontSize: 10, color: theme.primaryColor, fontWeight: FontWeight.bold)),
                                      ),
                                      const SizedBox(width: 8),
                                      if (isOutOfStock)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text('STOK HABIS', style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold)),
                                        )
                                      else if (isLowStock)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text('STOK MENIPIS', style: TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.bold)),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Sisa Stok: ${stock.quantity} pcs', style: TextStyle(fontWeight: (isLowStock || isOutOfStock) ? FontWeight.bold : FontWeight.normal, color: (isLowStock || isOutOfStock) ? Colors.red : Colors.black87)),
                                  Text(
                                    'Harga: ${CurrencyFormat.convertToIdr(stock.sellPrice)}',
                                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                                        onPressed: () => _showForm(context, stock),
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.all(4),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                                        onPressed: () => _deleteStock(context, stock),
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.all(4),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Terjadi kesalahan: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: InkWell(
        onTap: () => _showForm(context),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFD72323), Color(0xFF1A1A1A)]),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: const Color(0xFFD72323).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: Colors.white),
              SizedBox(width: 8),
              Text('Tambah Barang', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
