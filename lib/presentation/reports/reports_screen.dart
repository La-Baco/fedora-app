import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../utils/currency_formatter.dart';
import '../dashboard/providers/dashboard_provider.dart';
import '../service/providers/service_provider.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(salesHistoryStreamProvider);
    final servicesAsync = ref.watch(servicesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Transaksi', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20, letterSpacing: -0.5)),
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
      body: salesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (sales) {
          return servicesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (services) {
              // Filter servis yang hanya berstatus 'Selesai'
              final completedServices = services
                  .where((s) => s.status == 'Selesai')
                  .toList();

              if (sales.isEmpty && completedServices.isEmpty) {
                return const Center(
                  child: Text('Belum ada transaksi sama sekali.'),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Riwayat Kasir',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...sales.map(
                    (sale) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.point_of_sale,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text('Transaksi POS #${sale.id}'),
                        subtitle: Text(
                          DateFormat(
                            'dd MMM yyyy, HH:mm',
                          ).format(sale.saleDate),
                        ),
                        trailing: Text(
                          CurrencyFormat.convertToIdr(sale.totalAmount),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Divider(height: 32, thickness: 2),

                  const Text(
                    'Riwayat Servis Selesai',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...completedServices.map(
                    (service) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.build,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          '${service.customerName} - ${service.phoneBrand}',
                        ),
                        subtitle: Text(
                          DateFormat(
                            'dd MMM yyyy, HH:mm',
                          ).format(service.createdAt),
                        ),
                        trailing: Text(
                          CurrencyFormat.convertToIdr(service.serviceFee),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
