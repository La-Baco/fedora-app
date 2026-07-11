import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../data/datasources/local/app_database.dart';
import '../../../../data/repositories/stock_repository.dart';
import '../../../../main.dart'; // Untuk memanggil appDatabase global

class StockFormBottomSheet extends StatefulWidget {
  final Stock?
  existingStock; // Jika null berarti Tambah Baru, jika ada isinya berarti Edit

  const StockFormBottomSheet({super.key, this.existingStock});

  @override
  State<StockFormBottomSheet> createState() => _StockFormBottomSheetState();
}

class _StockFormBottomSheetState extends State<StockFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();
  final _capitalPriceController = TextEditingController();
  final _sellPriceController = TextEditingController();

  String _selectedCategory = 'Aksesoris';
  final List<String> _categories = ['Aksesoris', 'Sparepart'];

  @override
  void initState() {
    super.initState();
    // Jika sedang mode Edit, isi form dengan data yang sudah ada
    if (widget.existingStock != null) {
      _nameController.text = widget.existingStock!.name;
      _selectedCategory = widget.existingStock!.category;
      _qtyController.text = widget.existingStock!.quantity.toString();
      _capitalPriceController.text = widget.existingStock!.capitalPrice
          .toInt()
          .toString();
      _sellPriceController.text = widget.existingStock!.sellPrice
          .toInt()
          .toString();
    }
  }

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      final repo = StockRepository(appDatabase);

      if (widget.existingStock == null) {
        // Mode Tambah Baru
        await repo.insertStock(
          StocksCompanion.insert(
            name: _nameController.text,
            category: _selectedCategory,
            quantity: drift.Value(int.parse(_qtyController.text)),
            capitalPrice: double.parse(_capitalPriceController.text),
            sellPrice: double.parse(_sellPriceController.text),
          ),
        );
      } else {
        // Mode Edit
        await repo.updateStock(
          widget.existingStock!.copyWith(
            name: _nameController.text,
            category: _selectedCategory,
            quantity: int.parse(_qtyController.text),
            capitalPrice: double.parse(_capitalPriceController.text),
            sellPrice: double.parse(_sellPriceController.text),
            updatedAt: DateTime.now(),
          ),
        );
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.existingStock == null
                    ? 'Tambah Barang Baru'
                    : 'Edit Barang',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                  prefixIcon: Icon(Icons.inventory_2_outlined),
                ),
                validator: (val) =>
                    val!.isEmpty ? 'Nama barang tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _categories
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Stok',
                  prefixIcon: Icon(Icons.format_list_numbered),
                ),
                validator: (val) => val!.isEmpty ? 'Isi jumlah stok' : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _capitalPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Harga Modal',
                        prefixText: 'Rp ',
                      ),
                      validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _sellPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Harga Jual',
                        prefixText: 'Rp ',
                      ),
                      validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _saveData,
                child: const Text('SIMPAN BARANG'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
