import 'package:drift/drift.dart';
import '../datasources/local/app_database.dart';

class ServiceRepository {
  final AppDatabase db;
  ServiceRepository(this.db);

  // Pantau semua data servis dari yang terbaru
  Stream<List<Service>> watchAllServices() {
    return (db.select(db.services)..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  // Tambah servis baru
  Future<int> insertService(ServicesCompanion service) =>
      db.into(db.services).insert(service);

  // Edit/Update status servis
  Future<bool> updateService(Service service) =>
      db.update(db.services).replace(service);

  // Hapus servis (opsional, biasanya untuk admin)
  Future<int> deleteService(Service service) =>
      db.delete(db.services).delete(service);

  // --- FUNGSI KHUSUS UNTUK SPAREPART ---
  // Menyimpan sparepart yang digunakan ke dalam tabel relasi
  Future<void> addSparepartToService(ServiceSparepartsCompanion entry) async {
    await db.into(db.serviceSpareparts).insert(entry);

    // Potong otomatis stok barang di tabel Stocks
    final stock = await (db.select(
      db.stocks,
    )..where((t) => t.id.equals(entry.stockId.value))).getSingle();
    final newQuantity = stock.quantity - entry.quantity.value;

    await db.update(db.stocks).replace(stock.copyWith(quantity: newQuantity));
  }

  // Mengambil daftar sparepart yang dipakai pada servis tertentu
  Future<List<ServiceSparepart>> getSparepartsForService(int serviceId) {
    return (db.select(
      db.serviceSpareparts,
    )..where((t) => t.serviceId.equals(serviceId))).get();
  }
}
