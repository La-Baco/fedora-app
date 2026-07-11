import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:drift/drift.dart' as drift;
import '../../../data/datasources/local/app_database.dart';
import '../../../utils/currency_formatter.dart';
import 'providers/service_provider.dart';
import '../stock/providers/stock_provider.dart';

class ServiceDetailScreen extends ConsumerStatefulWidget {
  final Service service;
  const ServiceDetailScreen({super.key, required this.service});

  @override
  ConsumerState<ServiceDetailScreen> createState() =>
      _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends ConsumerState<ServiceDetailScreen> {
  late String _currentStatus;
  List<ServiceSparepart> _usedSpareparts = [];
  double _totalSparepartCost = 0;

  final List<String> _statusOptions = [
    'Dalam Antrean',
    'Diperiksa',
    'Menunggu Sparepart',
    'Proses Perbaikan',
    'Selesai',
    'Batal',
  ];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.service.status;
    _loadSpareparts();
  }

  // Mengambil daftar sparepart yang sudah ditambahkan ke servis ini
  Future<void> _loadSpareparts() async {
    final repo = ref.read(serviceRepositoryProvider);
    final parts = await repo.getSparepartsForService(widget.service.id);

    double total = 0;
    for (var p in parts) {
      total += p.price * p.quantity;
    }

    setState(() {
      _usedSpareparts = parts;
      _totalSparepartCost = total;
    });
  }

  // Menyimpan perubahan status
  Future<void> _updateStatus(String newStatus) async {
    final repo = ref.read(serviceRepositoryProvider);
    await repo.updateService(widget.service.copyWith(status: newStatus));
    setState(() => _currentStatus = newStatus);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Status berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Fungsi Kirim Pesan WA
  Future<void> _sendWhatsApp() async {
    // Ubah angka 0 di depan menjadi 62
    String phone = widget.service.phone;
    if (phone.startsWith('0')) {
      phone = '62${phone.substring(1)}';
    }

    final totalAkhir = widget.service.serviceFee + _totalSparepartCost;
    final message =
        "Halo Kak ${widget.service.customerName},\n\n"
        "Ini dari Konter Fedora.\n"
        "Status perbaikan HP ${widget.service.phoneBrand} ${widget.service.phoneType} saat ini: *$_currentStatus*.\n"
        "Total Biaya Sementara: *${CurrencyFormat.convertToIdr(totalAkhir)}*\n\n"
        "Terima kasih.";

    final url = Uri.parse(
      "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  // Dialog untuk memilih Sparepart dari Stok
  void _showAddSparepartDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final stocksAsync = ref.watch(stocksStreamProvider);

            return stocksAsync.when(
              data: (stocks) {
                // Hanya tampilkan yang kategorinya Sparepart dan stoknya > 0
                final availableParts = stocks
                    .where((s) => s.category == 'Sparepart' && s.quantity > 0)
                    .toList();

                if (availableParts.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('Tidak ada stok sparepart tersedia.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: availableParts.length,
                  itemBuilder: (context, index) {
                    final part = availableParts[index];
                    return ListTile(
                      title: Text(part.name),
                      subtitle: Text(
                        'Stok: ${part.quantity} | Harga: ${CurrencyFormat.convertToIdr(part.sellPrice)}',
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onPressed: () async {
                          final repo = ref.read(serviceRepositoryProvider);
                          await repo.addSparepartToService(
                            ServiceSparepartsCompanion.insert(
                              serviceId: widget.service.id,
                              stockId: part.id,
                              quantity: 1, // Default potong 1 stok
                              price: part.sellPrice,
                            ),
                          );

                          if (context.mounted) Navigator.pop(context);
                          _loadSpareparts(); // Refresh daftar sparepart di layar detail
                        },
                        child: const Text('Gunakan'),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalKeseluruhan = widget.service.serviceFee + _totalSparepartCost;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Servis')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // KARTU INFO PELANGGAN
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Informasi Pelanggan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    const Divider(),
                    Text(
                      widget.service.customerName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.service.village} ${widget.service.addressDetail != null ? "- ${widget.service.addressDetail}" : ""}',
                    ),
                    Text(
                      widget.service.phone,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // KARTU INFO HP
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Perbaikan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const Divider(),
                    Text(
                      '${widget.service.phoneBrand} ${widget.service.phoneType}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Keluhan:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(widget.service.issue),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Status Saat Ini:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        DropdownButton<String>(
                          value: _currentStatus,
                          items: _statusOptions
                              .map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(
                                    s,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) _updateStatus(val);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // KARTU RINCIAN BIAYA & SPAREPART
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Rincian Biaya',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _showAddSparepartDialog,
                          icon: const Icon(Icons.add),
                          label: const Text('Sparepart'),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Biaya Jasa'),
                        Text(
                          CurrencyFormat.convertToIdr(
                            widget.service.serviceFee,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sparepart Digunakan:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    if (_usedSpareparts.isEmpty)
                      const Text(
                        '- Tidak ada',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),

                    ..._usedSpareparts.map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('- ID Barang: ${p.stockId} (x${p.quantity})'),
                            Text(
                              CurrencyFormat.convertToIdr(p.price * p.quantity),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Divider(thickness: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL BIAYA',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          CurrencyFormat.convertToIdr(totalKeseluruhan),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Aksi cetak resi thermal di tahap selanjutnya
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Fitur cetak resi akan dibuat pada tahap integrasi printer.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.print),
                  label: const Text('Cetak Resi'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _sendWhatsApp,
                  icon: const Icon(Icons.send),
                  label: const Text('Kirim WA'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Warna khas WA
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
