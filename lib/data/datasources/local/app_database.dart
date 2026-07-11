import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'app_database.g.dart';

// --- TABEL STOK BARANG ---
class Stocks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get category => text()(); // Baru: 'Aksesoris' atau 'Sparepart'
  IntColumn get quantity => integer().withDefault(const Constant(0))();
  RealColumn get capitalPrice => real()();
  RealColumn get sellPrice => real()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// --- TABEL PELANGGAN SERVIS ---
class Services extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get customerName => text()();
  TextColumn get village => text()(); // Baru: Dropdown Desa
  TextColumn get addressDetail => text().nullable()();
  TextColumn get phone => text()();
  TextColumn get phoneBrand => text()(); // Baru: Dropdown Merek HP
  TextColumn get phoneType => text()();
  TextColumn get issue => text()();
  RealColumn get serviceFee => real().withDefault(const Constant(0.0))();
  TextColumn get status =>
      text().withDefault(const Constant('Menunggu Sparepart'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// --- TABEL RELASI: SPAREPART YANG DIGUNAKAN DI SERVIS ---
class ServiceSpareparts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serviceId => integer().references(Services, #id)();
  IntColumn get stockId => integer().references(Stocks, #id)();
  IntColumn get quantity => integer()();
  RealColumn get price => real()(); // Harga jual sparepart saat itu
}

// --- TABEL TRANSAKSI KASIR (POS) ---
class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get totalAmount => real()();
  RealColumn get paymentAmount => real()(); // Uang bayar
  RealColumn get changeAmount => real()(); // Kembalian
  DateTimeColumn get saleDate => dateTime().withDefault(currentDateAndTime)();
}

class SaleItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer().references(Sales, #id)();
  IntColumn get stockId => integer().references(Stocks, #id)();
  IntColumn get quantity => integer()();
  RealColumn get price => real()();
}

// --- TABEL PENGATURAN TOKO ---
class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get storeName =>
      text().withDefault(const Constant('Konter Fedora'))();
  TextColumn get storeAddress => text().nullable()();
  TextColumn get storePhone => text().nullable()();
}

@DriftDatabase(
  tables: [Stocks, Services, ServiceSpareparts, Sales, SaleItems, Settings],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // Naikkan versi skema
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'fedora_db.sqlite'));
    return NativeDatabase(file);
  });
}
