import 'package:drift/drift.dart';
import '../datasources/local/app_database.dart';

class StockRepository {
  final AppDatabase db;
  StockRepository(this.db);

  // Mengambil data secara realtime
  Stream<List<Stock>> watchAllStocks() => db.select(db.stocks).watch();

  // Tambah Barang Baru
  Future<int> insertStock(StocksCompanion stock) =>
      db.into(db.stocks).insert(stock);

  // Edit Barang
  Future<bool> updateStock(Stock stock) => db.update(db.stocks).replace(stock);

  // Hapus Barang
  Future<int> deleteStock(Stock stock) => db.delete(db.stocks).delete(stock);
}
