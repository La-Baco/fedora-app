import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../utils/currency_formatter.dart';
import '../service/providers/service_provider.dart';
import '../stock/providers/stock_provider.dart';
import 'providers/dashboard_provider.dart';
import '../service/service_detail_screen.dart';

enum DashboardFilter { today, week, month, allTime }

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  DashboardFilter _currentFilter = DashboardFilter.allTime;

  bool _isWithinFilter(DateTime date, DashboardFilter filter) {
    final now = DateTime.now();
    switch (filter) {
      case DashboardFilter.today:
        return date.year == now.year && date.month == now.month && date.day == now.day;
      case DashboardFilter.week:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return date.isAfter(startOfWeek.subtract(const Duration(days: 1)));
      case DashboardFilter.month:
        return date.year == now.year && date.month == now.month;
      case DashboardFilter.allTime:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesStreamProvider);
    final salesAsync = ref.watch(salesHistoryStreamProvider);
    final stocksAsync = ref.watch(stocksStreamProvider);
    final debtAsync = ref.watch(debtCustomersProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Clean off-white background
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/logo.jpeg',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.storefront, color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'KONTER FEDORA',
              style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5, fontSize: 18),
            ),
          ],
        ),
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
        actionsIconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () => Navigator.pushNamed(context, '/report'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: servicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (allServices) {
          return salesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (allSales) {
              return stocksAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
                data: (allStocks) {
                  // FILTER DATA
                  final services = allServices.where((s) => _isWithinFilter(s.createdAt, _currentFilter)).toList();
                  final sales = allSales.where((s) => _isWithinFilter(s.saleDate, _currentFilter)).toList();

                  // KALKULASI DATA
                  double totalSales = sales.fold(0, (sum, item) => sum + item.totalAmount);
                  double totalServiceFee = services.where((s) => s.status == 'Selesai').fold(0, (sum, item) => sum + item.serviceFee);
                  double totalRevenue = totalSales + totalServiceFee;
                  
                  int totalServisCount = services.length;
                  int totalSalesCount = sales.length;
                  int uniqueCustomers = services.map((e) => e.customerName).toSet().length;
                  
                  int lowStockCount = allStocks.where((s) => s.quantity < 5).length;
                  int totalItemsCount = allStocks.fold(0, (sum, item) => sum + item.quantity);

                  // PIE CHART DATA (Merek HP)
                  Map<String, int> brandCount = {};
                  Map<String, int> villageCount = {};
                  for (var s in services) {
                    brandCount[s.phoneBrand] = (brandCount[s.phoneBrand] ?? 0) + 1;
                    villageCount[s.village] = (villageCount[s.village] ?? 0) + 1;
                  }
                  var sortedVillages = villageCount.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

                  // LINE CHART DATA
                  Map<int, double> dailyRevenue = {};
                  for (var sale in sales) {
                    dailyRevenue[sale.saleDate.day] = (dailyRevenue[sale.saleDate.day] ?? 0) + sale.totalAmount;
                  }
                  for (var s in services.where((s) => s.status == 'Selesai')) {
                    dailyRevenue[s.createdAt.day] = (dailyRevenue[s.createdAt.day] ?? 0) + s.serviceFee;
                  }
                  
                  var sortedDays = dailyRevenue.keys.toList()..sort();
                  List<FlSpot> spots = [];
                  double maxRevenue = 0;
                  for (int i = 0; i < sortedDays.length; i++) {
                    double val = dailyRevenue[sortedDays[i]]!;
                    spots.add(FlSpot(i.toDouble(), val));
                    if (val > maxRevenue) maxRevenue = val;
                  }
                  if (maxRevenue == 0) maxRevenue = 100000;

                  return RefreshIndicator(
                    onRefresh: () async {},
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // SUMMARY REVENUE
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFD72323), Color(0xFF1A1A1A)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFD72323).withOpacity(0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total Pendapatan', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(CurrencyFormat.convertToIdr(totalRevenue), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // FILTER CHIPS
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: DashboardFilter.values.map((filter) {
                                final isSelected = _currentFilter == filter;
                                String label = '';
                                switch(filter) {
                                  case DashboardFilter.today: label = 'Hari Ini'; break;
                                  case DashboardFilter.week: label = 'Minggu Ini'; break;
                                  case DashboardFilter.month: label = 'Bulan Ini'; break;
                                  case DashboardFilter.allTime: label = 'Semua'; break;
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ChoiceChip(
                                    selected: isSelected,
                                    label: Text(label, style: TextStyle(
                                      color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    )),
                                    onSelected: (val) {
                                      setState(() {
                                        _currentFilter = filter;
                                      });
                                    },
                                    selectedColor: theme.primaryColor,
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    side: BorderSide(color: isSelected ? theme.primaryColor : Colors.grey.shade300),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // SUMMARY CARDS GRID
                          GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 1.5,
                            children: [
                              _buildDashboardCard(context, 'Total Pendapatan', CurrencyFormat.convertToIdr(totalRevenue), Icons.account_balance_wallet, theme.primaryColor),
                              _buildDashboardCard(context, 'Total Penjualan', '$totalSalesCount Trx', Icons.shopping_cart, Colors.orange),
                              _buildDashboardCard(context, 'Total Servis', '$totalServisCount Unit', Icons.build_circle, Colors.blue),
                              _buildDashboardCard(context, 'Pelanggan', '$uniqueCustomers Orang', Icons.people, Colors.purple),
                              _buildDashboardCard(context, 'Stok Menipis', '$lowStockCount Barang', Icons.warning, Colors.red),
                              _buildDashboardCard(context, 'Jumlah Barang', '$totalItemsCount Unit', Icons.inventory_2, Colors.teal),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // LINE CHART (Pendapatan)
                          const Text('Grafik Pendapatan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Card(
                            elevation: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                height: 200,
                                child: spots.isEmpty 
                                  ? const Center(child: Text('Belum ada data pendapatan'))
                                  : LineChart(
                                    LineChartData(
                                      gridData: const FlGridData(show: false),
                                      titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 70,
                                            interval: maxRevenue > 0 ? (maxRevenue / 4).ceilToDouble() : 1,
                                            getTitlesWidget: (value, meta) {
                                              if (value == 0) return const SizedBox.shrink();
                                              return Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: Text(
                                                  NumberFormat('#,##0', 'id_ID').format(value), 
                                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                                  textAlign: TextAlign.right,
                                                ),
                                              );
                                            },
                                          )
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 30,
                                            interval: spots.length > 5 ? (spots.length / 5).ceilToDouble() : 1,
                                            getTitlesWidget: (value, meta) {
                                              if (value.toInt() >= 0 && value.toInt() < sortedDays.length) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: Text('Tgl ${sortedDays[value.toInt()]}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                                );
                                              }
                                              return const SizedBox.shrink();
                                            }
                                          )
                                        ),
                                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      minX: 0,
                                      maxX: spots.length.toDouble() - 1,
                                      minY: 0,
                                      maxY: maxRevenue * 1.2,
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: spots,
                                          isCurved: true,
                                          color: theme.primaryColor,
                                          barWidth: 4,
                                          isStrokeCapRound: true,
                                          dotData: const FlDotData(show: false),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            gradient: LinearGradient(
                                              colors: [
                                                theme.primaryColor.withOpacity(0.3),
                                                theme.primaryColor.withOpacity(0.0),
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // PIE CHART
                          if (brandCount.isNotEmpty) ...[
                            const Text('Tren Merek HP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            Card(
                              elevation: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 150,
                                        child: PieChart(
                                          PieChartData(
                                            sectionsSpace: 2,
                                            centerSpaceRadius: 30,
                                            sections: brandCount.entries.toList().asMap().entries.map((entry) {
                                              final colors = [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.teal];
                                              return PieChartSectionData(
                                                color: colors[entry.key % colors.length],
                                                value: entry.value.value.toDouble(),
                                                title: '${entry.value.value}',
                                                radius: 40,
                                                titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: brandCount.entries.toList().asMap().entries.map((entry) {
                                        final colors = [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.teal];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4),
                                          child: Row(
                                            children: [
                                              Container(width: 12, height: 12, color: colors[entry.key % colors.length]),
                                              const SizedBox(width: 8),
                                              Text(entry.value.key, style: const TextStyle(fontSize: 12)),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),
                          
                          // VILLAGE TREND
                          if (sortedVillages.isNotEmpty) ...[
                            const Text('Tren Servis per Desa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade100, width: 1.5),
                              ),
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: sortedVillages.length > 5 ? 5 : sortedVillages.length, // Tampilkan Top 5
                                separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
                                itemBuilder: (context, index) {
                                  var entry = sortedVillages[index];
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                                    leading: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: index == 0 ? Colors.amber.withOpacity(0.15) : (index == 1 ? Colors.grey.withOpacity(0.15) : (index == 2 ? Colors.brown.withOpacity(0.15) : theme.primaryColor.withOpacity(0.05))),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(child: Text('${index + 1}', style: TextStyle(color: index == 0 ? Colors.amber.shade700 : (index == 1 ? Colors.grey.shade700 : (index == 2 ? Colors.brown.shade600 : theme.primaryColor)), fontWeight: FontWeight.w900, fontSize: 16))),
                                    ),
                                    title: Text('Desa ${entry.key}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text('${entry.value} Servis', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                          
                          const SizedBox(height: 24),
                          
                          // DEBT CUSTOMERS
                          debtAsync.when(
                            data: (debts) {
                              if (debts.isEmpty) return const SizedBox.shrink();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Daftar Hutang Pelanggan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                                  const SizedBox(height: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.redAccent.shade100, width: 1.5),
                                    ),
                                    child: ListView.separated(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: debts.length,
                                      separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
                                      itemBuilder: (context, index) {
                                        final debt = debts[index];
                                        return ListTile(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                          leading: Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            child: const Icon(Icons.money_off, color: Colors.redAccent, size: 24),
                                          ),
                                          title: Text(debt.service.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                                                  const SizedBox(width: 4),
                                                  Expanded(child: Text('Desa ${debt.service.village}', style: TextStyle(fontSize: 13, color: Colors.grey.shade600))),
                                                ],
                                              ),
                                              const SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  const Icon(Icons.phone_outlined, size: 14, color: Colors.grey),
                                                  const SizedBox(width: 4),
                                                  Text(debt.service.phone, style: TextStyle(fontSize: 13, color: Colors.blue.shade600)),
                                                ],
                                              ),
                                              const SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                                                  const SizedBox(width: 4),
                                                  Text(DateFormat('dd MMM yyyy, HH:mm').format(debt.service.createdAt), style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                                                ],
                                              ),
                                            ],
                                          ),
                                          trailing: Text(
                                            CurrencyFormat.convertToIdr(debt.totalCost),
                                            style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.redAccent, fontSize: 14),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ServiceDetailScreen(service: debt.service),
                                              ),
                                            );
                                          }
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              );
                            },
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (err, stack) => const SizedBox.shrink(),
                          ),
                          
                          // RECENT ACTIVITIES
                          const Text('Aktivitas Terakhir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          _buildRecentActivitiesList(services.take(5).toList(), sales.take(5).toList(), theme),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildRecentActivitiesList(List<dynamic> recentServices, List<dynamic> recentSales, ThemeData theme) {
    List<dynamic> combined = [...recentServices, ...recentSales];
    // Sort combined by date descending
    combined.sort((a, b) {
      DateTime dateA = a.runtimeType.toString() == 'Service' ? a.createdAt : a.saleDate;
      DateTime dateB = b.runtimeType.toString() == 'Sale' ? b.saleDate : b.createdAt;
      return dateB.compareTo(dateA);
    });

    if (combined.isEmpty) {
      return Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100, width: 1.5)),
        padding: const EdgeInsets.all(32),
        child: const Center(child: Text('Belum ada aktivitas.', style: TextStyle(color: Colors.grey))),
      );
    }

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100, width: 1.5)),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: combined.length > 5 ? 5 : combined.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
        itemBuilder: (context, index) {
          var item = combined[index];
          bool isService = item.runtimeType.toString() == 'Service';
          
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (isService ? Colors.blue : Colors.green).withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(isService ? Icons.build_circle : Icons.point_of_sale, color: isService ? Colors.blue : Colors.green, size: 24),
            ),
            title: Text(isService ? 'Servis: ${item.phoneBrand}' : 'Penjualan Kasir', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            subtitle: Text(
              isService ? '${item.customerName} • ${DateFormat('dd MMM, HH:mm').format(item.createdAt)}' : DateFormat('dd MMM, HH:mm').format(item.saleDate),
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isService ? (item.status == 'Selesai' ? CurrencyFormat.convertToIdr(item.serviceFee) : item.status) : CurrencyFormat.convertToIdr(item.totalAmount),
                  style: TextStyle(
                    fontWeight: FontWeight.w900, 
                    color: isService ? (item.status == 'Selesai' ? Colors.black87 : Colors.orange) : Colors.green,
                    fontSize: 14
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
