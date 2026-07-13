import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../../utils/currency_formatter.dart';
import 'providers/service_provider.dart';
import '../stock/providers/stock_provider.dart';
import '../../../services/printer_service.dart';

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
  final PrinterService _printerService = PrinterService();

  final List<String> _statusOptions = [
    'Dalam Antrean',
    'Diperiksa',
    'Menunggu Sparepart',
    'Proses Perbaikan',
    'Selesai',
    'Sudah Diambil',
    'Batal',
  ];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.service.status;
    _loadSpareparts();
  }

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

  Future<void> _sendWhatsApp() async {
    String phone = widget.service.phone;
    if (phone.startsWith('0')) {
      // The user didn't specify a default, we assume 62 (Indonesia) for numbers starting with 0.
      phone = '62${phone.substring(1)}';
    }

    final double totalBiaya = widget.service.serviceFee + _totalSparepartCost;
    final address = widget.service.addressDetail != null && widget.service.addressDetail!.isNotEmpty 
      ? '${widget.service.addressDetail}, Desa ${widget.service.village}' 
      : 'Desa ${widget.service.village}';

    final message =
        "*KONTER FEDORA*\n\n"
        "Halo Kak ${widget.service.customerName},\n\n"
        "Kami ingin menginformasikan bahwa servis HP Anda telah selesai dan siap diambil.\n\n"
        "*Detail Servis:*\n"
        "Alamat: $address\n"
        "Perangkat: ${widget.service.phoneBrand} ${widget.service.phoneType}\n"
        "Keluhan: ${widget.service.issue}\n\n"
        "*Total Biaya:* ${CurrencyFormat.convertToIdr(totalBiaya)}\n\n"
        "Terima kasih telah mempercayakan servis HP Anda kepada kami! 🙏";

    final url = Uri.parse("whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}");
    final fallbackUrl = Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(message)}");
    
    try {
      // Coba buka aplikasi WhatsApp langsung menggunakan skema URI
      bool launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      
      // Jika gagal (mungkin karena canLaunchUrl batasan Android 11+), gunakan fallback web
      if (!launched) {
        launched = await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
        if (!launched) {
          _showErrorDialog("Tidak dapat membuka WhatsApp. Pastikan aplikasi terinstal.");
        }
      }
    } catch (e) {
      _showErrorDialog("Gagal membuka WhatsApp: $e");
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _printReceipt() async {
    final totalKeseluruhan = widget.service.serviceFee + _totalSparepartCost;
    try {
      await _printerService.printServiceTicket(
        serviceId: 'SRV-${widget.service.id}',
        customerName: widget.service.customerName,
        phone: widget.service.phone,
        unit: '${widget.service.phoneBrand} ${widget.service.phoneType}',
        complaint: widget.service.issue,
        totalCost: totalKeseluruhan,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mencetak resi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
                final availableParts = stocks
                    .where((s) => s.category == 'Sparepart' && s.quantity > 0)
                    .toList();

                if (availableParts.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('Tidak ada stok sparepart tersedia.'),
                  );
                }

                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Pilih Sparepart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: availableParts.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final part = availableParts[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(part.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('Sisa: ${part.quantity} pcs'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(CurrencyFormat.convertToIdr(part.sellPrice), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    backgroundColor: Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () async {
                                    final repo = ref.read(serviceRepositoryProvider);
                                    await repo.addSparepartToService(
                                      ServiceSparepartsCompanion.insert(
                                        serviceId: widget.service.id,
                                        stockId: part.id,
                                        quantity: 1, 
                                        price: part.sellPrice,
                                      ),
                                    );

                                    if (context.mounted) Navigator.pop(context);
                                    _loadSpareparts();
                                  },
                                  child: const Text('Gunakan'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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
    final stocksAsync = ref.watch(stocksStreamProvider);
    final stocks = stocksAsync.value ?? [];
    final totalKeseluruhan = widget.service.serviceFee + _totalSparepartCost;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Servis', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20, letterSpacing: -0.5)),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // KARTU INFO PELANGGAN
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'INFORMASI PELANGGAN',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
                        ),
                        Icon(Icons.person, color: theme.primaryColor),
                      ],
                    ),
                    const Divider(),
                    Text(
                      widget.service.customerName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text('${widget.service.village} ${widget.service.addressDetail != null ? "- ${widget.service.addressDetail}" : ""}', style: const TextStyle(color: Colors.black87)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone_outlined, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(widget.service.phone, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // KARTU INFO HP & STATUS
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DETAIL PERBAIKAN & STATUS',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
                    ),
                    const Divider(),
                    Text(
                      '${widget.service.phoneBrand} ${widget.service.phoneType}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Keluhan:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                          const SizedBox(height: 4),
                          Text(widget.service.issue),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Status Saat Ini:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _currentStatus,
                              isDense: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              items: _statusOptions
                                  .map(
                                    (s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(s, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) _updateStatus(val);
                              },
                            ),
                          ),
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
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'RINCIAN BIAYA',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
                        ),
                        ElevatedButton.icon(
                          onPressed: _showAddSparepartDialog,
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Sparepart', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: const Size(0, 36),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Biaya Jasa', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(CurrencyFormat.convertToIdr(widget.service.serviceFee), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('Sparepart Digunakan:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 8),
                    if (_usedSpareparts.isEmpty)
                      const Text('- Belum ada sparepart ditambahkan', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 13)),

                    ..._usedSpareparts.map(
                      (p) {
                        final stockOpt = stocks.where((s) => s.id == p.stockId).toList();
                        final stockName = stockOpt.isNotEmpty ? stockOpt.first.name : 'Item ${p.stockId}';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('- $stockName (x${p.quantity})'),
                              Text(CurrencyFormat.convertToIdr(p.price * p.quantity)),
                            ],
                          ),
                        );
                      }
                    ),

                    const Divider(thickness: 1, height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TOTAL BIAYA',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            CurrencyFormat.convertToIdr(totalKeseluruhan),
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80), // Padding for bottom nav
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _printReceipt,
                  icon: const Icon(Icons.print),
                  label: const Text('Cetak Resi'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: theme.primaryColor),
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
                    backgroundColor: const Color(0xFF25D366), // WA Green
                    foregroundColor: Colors.white,
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
