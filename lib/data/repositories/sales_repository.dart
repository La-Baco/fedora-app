import 'package:drift/drift.dart';
import '../datasources/local/app_database.dart';

class SalesRepository {
  final AppDatabase db;
  SalesRepository(this.db);

  // Menyimpan transaksi penjualan utuh (Penjualan + Item yang dibeli)
  Future<void> checkout({
    required double totalAmount,
    required double paymentAmount,
    required double changeAmount,
    required List<Map<String, dynamic>> items, // berisi stockId dan quantity
  }) async {
    await db.transaction(() async {
      // 1. Simpan data induk penjualan
      final saleId = await db
          .into(db.sales)
          .insert(
            SalesCompanion.insert(
              totalAmount: totalAmount,
              paymentAmount: paymentAmount,
              changeAmount: changeAmount,
              saleDate: Value(DateTime.now()),
            ),
          );

      // 2. Simpan setiap item barang dan potong stoknya
      for (var item in items) {
        final stockId = item['stockId'] as int;
        final qty = item['quantity'] as int;

        // Ambil data barang saat ini untuk mengetahui harga jual terbaru
        final stock = await (db.select(
          db.stocks,
        )..where((t) => t.id.equals(stockId))).getSingle();

        await db
            .into(db.saleItems)
            .insert(
              SaleItemsCompanion.insert(
                saleId: saleId,
                stockId: stockId,
                quantity: qty,
                price: stock.sellPrice,
              ),
            );

        // Kurangi jumlah stok di gudang barang
        await db
            .update(db.stocks)
            .replace(stock.copyWith(quantity: stock.quantity - qty));
      }
    });
  }

  // Memantau semua transaksi kasir (Untuk kebutuhan grafik dasbor nanti)
  Stream<List<Sale>> watchAllSales() => db.select(db.sales).watch();
}
