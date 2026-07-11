import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../utils/currency_formatter.dart';
import '../service/providers/service_provider.dart';
import 'providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesStreamProvider);
    final salesAsync = ref.watch(salesHistoryStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dasbor Fedora'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Lihat Laporan Lengkap',
            onPressed: () {
              Navigator.pushNamed(context, '/report');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Pengaturan',
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: servicesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (services) {
            return salesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (sales) {
                // --- KALKULASI DATA ---
                // 1. Total Pendapatan Kasir
                double totalSales = sales.fold(
                  0,
                  (sum, item) => sum + item.totalAmount,
                );

                // 2. Total Pendapatan Servis (Hanya yang statusnya 'Selesai')
                double totalServiceFee = services
                    .where((s) => s.status == 'Selesai')
                    .fold(0, (sum, item) => sum + item.serviceFee);

                // 3. Menghitung Demografi Desa Terbanyak
                Map<String, int> villageCount = {};
                for (var s in services) {
                  villageCount[s.village] = (villageCount[s.village] ?? 0) + 1;
                }
                var sortedVillages = villageCount.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));

                // 4. Menghitung Tren Merek HP
                Map<String, int> brandCount = {};
                for (var s in services) {
                  brandCount[s.phoneBrand] =
                      (brandCount[s.phoneBrand] ?? 0) + 1;
                }

                // --- WARNA UNTUK GRAFIK ---
                final List<Color> pieColors = [
                  Colors.blue,
                  Colors.red,
                  Colors.green,
                  Colors.orange,
                  Colors.purple,
                  Colors.teal,
                  Colors.amber,
                  Colors.indigo,
                ];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Ringkasan Keuangan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // KARTU PENDAPATAN
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              context,
                              'Penjualan Kasir',
                              CurrencyFormat.convertToIdr(totalSales),
                              Icons.point_of_sale,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSummaryCard(
                              context,
                              'Pendapatan Servis',
                              CurrencyFormat.convertToIdr(totalServiceFee),
                              Icons.build_circle,
                              Colors.blue,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Text(
                        'Tren Merek HP',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // GRAFIK PIE MEREK HP
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: brandCount.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text('Belum ada data.'),
                                  ),
                                )
                              : SizedBox(
                                  height: 200,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: PieChart(
                                          PieChartData(
                                            sectionsSpace: 2,
                                            centerSpaceRadius: 40,
                                            sections: brandCount.entries
                                                .toList()
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                                  int idx = entry.key;
                                                  var e = entry.value;
                                                  return PieChartSectionData(
                                                    color:
                                                        pieColors[idx %
                                                            pieColors.length],
                                                    value: e.value.toDouble(),
                                                    title: '${e.value}',
                                                    radius: 50,
                                                    titleStyle: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  );
                                                })
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                      // Keterangan Grafik (Legend)
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: brandCount.entries
                                                .toList()
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                                  int idx = entry.key;
                                                  var e = entry.value;
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 4,
                                                          horizontal: 8,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 12,
                                                          height: 12,
                                                          color:
                                                              pieColors[idx %
                                                                  pieColors
                                                                      .length],
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            e.key,
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 12,
                                                                ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                })
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Text(
                        'Top Demografi Desa',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // DAFTAR DESA
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: sortedVillages.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: Text('Belum ada data pelanggan.'),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: sortedVillages.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final village = sortedVillages[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.1),
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      village.key,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Text(
                                      '${village.value} Servis',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(16),
      ),
      color: color.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
