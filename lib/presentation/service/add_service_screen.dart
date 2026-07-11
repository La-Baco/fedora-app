import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../data/datasources/local/app_database.dart';
import 'providers/service_provider.dart';

class AddServiceScreen extends ConsumerStatefulWidget {
  const AddServiceScreen({super.key});

  @override
  ConsumerState<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends ConsumerState<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk input teks
  final _nameController = TextEditingController();
  final _addressDetailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _phoneTypeController = TextEditingController();
  final _issueController = TextEditingController();
  final _serviceFeeController = TextEditingController();

  // Dropdown Selections
  String? _selectedVillage;
  String? _selectedBrand;

  // Daftar Opsi Sesuai Permintaan Anda
  final List<String> _villages = [
    'Ketupat',
    'Jungkat',
    'Kropoh',
    'Alasmalang',
    'Poteran',
    'Brakas',
    'Tonduk',
    'Gua-Gua',
  ];

  final List<String> _brands = [
    'Oppo',
    'Samsung',
    'Xiaomi',
    'Asus',
    'Advan',
    'Infinix',
    'Realme',
    'Lainnya',
  ];

  Future<void> _saveService() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedVillage == null || _selectedBrand == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih Desa dan Merek HP terlebih dahulu!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final repo = ref.read(serviceRepositoryProvider);

      // Simpan data servis ke database
      await repo.insertService(
        ServicesCompanion.insert(
          customerName: _nameController.text,
          village: _selectedVillage!,
          addressDetail: drift.Value(_addressDetailController.text),
          phone: _phoneController.text,
          phoneBrand: _selectedBrand!,
          phoneType: _phoneTypeController.text,
          issue: _issueController.text,
          serviceFee: drift.Value(
            double.tryParse(_serviceFeeController.text) ?? 0.0,
          ),
          status: const drift.Value('Dalam Antrean'), // Status default
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data Servis Berhasil Disimpan!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terima Servis Baru')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- SECTION 1: DATA PELANGGAN ---
              const Text(
                'Informasi Pelanggan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pelanggan',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedVillage,
                decoration: const InputDecoration(
                  labelText: 'Desa',
                  prefixIcon: Icon(Icons.map_outlined),
                ),
                items: _villages
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedVillage = val),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _addressDetailController,
                decoration: const InputDecoration(
                  labelText: 'Detail Alamat (Opsional)',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'No. WhatsApp / Telepon',
                  prefixText: '+62 ',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 32),

              // --- SECTION 2: DATA HP & KELUHAN ---
              const Text(
                'Detail Perangkat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedBrand,
                      decoration: const InputDecoration(
                        labelText: 'Merek HP',
                        prefixIcon: Icon(Icons.smartphone_outlined),
                      ),
                      items: _brands
                          .map(
                            (b) => DropdownMenuItem(value: b, child: Text(b)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _selectedBrand = val),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneTypeController,
                      decoration: const InputDecoration(labelText: 'Tipe HP'),
                      validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _issueController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Keluhan / Kerusakan',
                  prefixIcon: Icon(Icons.build_outlined),
                ),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 32),

              // --- SECTION 3: BIAYA JASA ---
              const Text(
                'Estimasi Biaya',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _serviceFeeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Biaya Jasa (Tanpa Sparepart)',
                  prefixText: 'Rp ',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 24),

              // Note: Tombol Tambah Sparepart akan diletakkan di halaman Detail Servis
              // setelah pelanggan setuju memasukkan HP-nya ke dalam antrean.
              ElevatedButton(
                onPressed: _saveService,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                child: const Text(
                  'SIMPAN & MASUKKAN ANTREAN',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
