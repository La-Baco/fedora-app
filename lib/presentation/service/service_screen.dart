import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../utils/currency_formatter.dart';
import 'providers/service_provider.dart';
import 'add_service_screen.dart';
import 'service_detail_screen.dart'; 

class ServiceScreen extends ConsumerStatefulWidget {
  const ServiceScreen({super.key});

  @override
  ConsumerState<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends ConsumerState<ServiceScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedVillage = 'Semua';
  String _selectedBrand = 'Semua';

  final List<String> _villages = [
    'Semua', 'Ketupat', 'Jungkat', 'Kropoh', 'Alasmalang', 
    'Poteran', 'Brakas', 'Tonduk', 'Gua-Gua'
  ];

  final List<String> _brands = [
    'Semua', 'Oppo', 'Samsung', 'Xiaomi', 'Asus', 
    'Advan', 'Infinix', 'Realme', 'Apple', 'Poco', 
    'Vivo', 'Honor', 'Nokia', 'Redmi', 'Tecno', 
    'Itel', 'Huawei', 'Lainnya'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Dalam Antrean':
      case 'Menunggu Sparepart':
        return Colors.orange;
      case 'Diperiksa':
      case 'Proses Perbaikan':
        return Colors.blue;
      case 'Selesai':
        return Colors.green;
      case 'Sudah Diambil':
        return Colors.grey;
      case 'Hutang':
        return Colors.redAccent;
      case 'Batal':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  double _getStatusProgress(String status) {
    switch (status) {
      case 'Dalam Antrean': return 0.2;
      case 'Diperiksa': return 0.4;
      case 'Menunggu Sparepart': return 0.5;
      case 'Proses Perbaikan': return 0.7;
      case 'Selesai': return 1.0;
      case 'Sudah Diambil': return 1.0;
      case 'Hutang': return 1.0;
      case 'Batal': return 0.0;
      default: return 0.1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsyncValue = ref.watch(servicesStreamProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Layanan Servis', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 24, letterSpacing: -0.5)),
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
      body: servicesAsyncValue.when(
        data: (services) {
          if (services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.build_circle_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada antrean servis.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          // Sort by date descending
          var sortedServices = List.from(services)..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          // Filters
          if (_searchQuery.isNotEmpty) {
            sortedServices = sortedServices.where((s) => 
              s.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.issue.toLowerCase().contains(_searchQuery.toLowerCase())
            ).toList();
          }
          if (_selectedVillage != 'Semua') {
            sortedServices = sortedServices.where((s) => s.village == _selectedVillage).toList();
          }
          if (_selectedBrand != 'Semua') {
            sortedServices = sortedServices.where((s) => s.phoneBrand == _selectedBrand).toList();
          }

          return Column(
            children: [
              // FILTER BAR
              Container(
                padding: const EdgeInsets.all(16),
                color: theme.colorScheme.surface,
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari nama pelanggan atau keluhan...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: theme.scaffoldBackgroundColor,
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
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedVillage,
                            decoration: InputDecoration(
                              labelText: 'Filter Desa',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: _villages.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                            onChanged: (val) => setState(() => _selectedVillage = val!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedBrand,
                            decoration: InputDecoration(
                              labelText: 'Filter Merek',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: _brands.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                            onChanged: (val) => setState(() => _selectedBrand = val!),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // LIST
              Expanded(
                child: sortedServices.isEmpty 
                  ? Center(child: Text('Tidak ada servis yang cocok.', style: TextStyle(color: Colors.grey.shade600)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: sortedServices.length,
            itemBuilder: (context, index) {
              final service = sortedServices[index];
              Color statusColor = _getStatusColor(service.status);
              double progress = _getStatusProgress(service.status);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ServiceDetailScreen(service: service),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                service.customerName,
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    service.status,
                                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => AddServiceScreen(service: service)),
                                      );
                                    } else if (value == 'hapus') {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Hapus Servis?'),
                                          content: Text('Anda yakin ingin menghapus data servis ${service.customerName}?'),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true), 
                                              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        await ref.read(serviceRepositoryProvider).deleteService(service);
                                      }
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, size: 20),
                                          SizedBox(width: 8),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'hapus',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, size: 20, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text('Hapus', style: TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.phone_android, size: 16, color: theme.primaryColor),
                            const SizedBox(width: 4),
                            Text(
                              '${service.phoneBrand} ${service.phoneType}',
                              style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            Text(
                              DateFormat('dd MMM yyyy').format(service.createdAt),
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Keluhan: ${service.issue}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey.shade200,
                            color: statusColor,
                            minHeight: 6,
                          ),
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  service.village,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Text(
                              CurrencyFormat.convertToIdr(service.serviceFee),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Terjadi kesalahan: $error')),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddServiceScreen()),
          );
        },
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
              Text('Terima Servis', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
