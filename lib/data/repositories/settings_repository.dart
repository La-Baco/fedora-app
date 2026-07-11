import 'dart:io';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../datasources/local/app_database.dart';

class SettingsRepository {
  final AppDatabase _db;
  SettingsRepository(this._db);

  // --- CRUD Profil Toko ---
  Future<Setting> getStoreSettings() async {
    final settings = await _db.select(_db.settings).get();
    if (settings.isEmpty) {
      // Jika kosong, buat data default pertama kali
      final defaultSetting = SettingsCompanion.insert(
        storeName: const Value('Konter Fedora'),
        storeAddress: const Value('Jl. Contoh Alamat No. 123'),
        storePhone: const Value('08123456789'),
      );
      await _db.into(_db.settings).insert(defaultSetting);
      return await (_db.select(_db.settings)..limit(1)).getSingle();
    }
    return settings.first;
  }

  Future<void> updateStoreSettings(Setting setting) async {
    await _db.update(_db.settings).replace(setting);
  }

  // --- LOGIKA BACKUP & RESTORE DATABASE ---

  // Mendapatkan lokasi file database aktif
  Future<File> _getDbFile() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    return File(p.join(dbFolder.path, 'konter_manager.sqlite'));
  }

  // Melakukan Backup (Mengkopi DB ke lokasi yang dipilih)
  Future<String> backupDatabase(String destinationPath) async {
    try {
      final dbFile = await _getDbFile();
      if (await dbFile.exists()) {
        final backupFile = File(
          p.join(
            destinationPath,
            'konter_backup_${DateTime.now().millisecondsSinceEpoch}.sqlite',
          ),
        );
        await dbFile.copy(backupFile.path);
        return backupFile.path;
      }
      throw Exception('Database aktif tidak ditemukan.');
    } catch (e) {
      throw Exception('Gagal Backup: $e');
    }
  }

  // Melakukan Restore (Menimpa DB lama dengan DB dari file backup)
  Future<void> restoreDatabase(String backupFilePath) async {
    try {
      final dbFile = await _getDbFile();
      final selectedBackup = File(backupFilePath);

      if (await selectedBackup.exists()) {
        // Hapus koneksi database saat ini (disarankan hot restart setelah ini)
        await dbFile.delete();
        await selectedBackup.copy(dbFile.path);
      } else {
        throw Exception('File backup tidak valid.');
      }
    } catch (e) {
      throw Exception('Gagal Restore: $e');
    }
  }
}
