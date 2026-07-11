import 'package:drift/drift.dart';
import '../datasources/local/app_database.dart';

class ReportRepository {
  final AppDatabase db;

  ReportRepository(this.db);

  // 1. Mengambil semua data penjualan kasir (Bisa dipantau secara realtime)
  Stream<List<Sale>> watchAllSales() {
    return (db.select(db.sales)..orderBy([
          (tbl) =>
              OrderingTerm(expression: tbl.saleDate, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  // 2. Mengambil semua data servis yang HANYA berstatus 'Selesai'
  Stream<List<Service>> watchCompletedServices() {
    return (db.select(db.services)
          ..where((tbl) => tbl.status.equals('Selesai'))
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.createdAt,
              mode: OrderingMode.desc,
            ),
          ]))
        .watch();
  }

  // --- FUNGSI UNTUK MASA DEPAN (FILTER TANGGAL) ---

  // 3. Mengambil laporan kasir berdasarkan rentang tanggal tertentu (Misal: 1 minggu terakhir)
  Future<List<Sale>> getSalesByDateRange(DateTime startDate, DateTime endDate) {
    return (db.select(db.sales)
          ..where((tbl) => tbl.saleDate.isBetweenValues(startDate, endDate))
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.saleDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  // 4. Mengambil laporan servis berdasarkan rentang tanggal tertentu
  Future<List<Service>> getCompletedServicesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return (db.select(db.services)
          ..where(
            (tbl) =>
                tbl.status.equals('Selesai') &
                tbl.createdAt.isBetweenValues(startDate, endDate),
          )
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.createdAt,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }
}
