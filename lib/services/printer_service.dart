import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:intl/intl.dart';

class PrinterService {
  final BlueThermalPrinter _bluetooth = BlueThermalPrinter.instance;

  // Mendapatkan daftar perangkat bluetooth yang sudah dipairing
  Future<List<BluetoothDevice>> getBondedDevices() async {
    return await _bluetooth.getBondedDevices();
  }

  // Koneksi ke printer
  Future<void> connect(BluetoothDevice device) async {
    final isConnected = await _bluetooth.isConnected;
    if (isConnected == false) {
      await _bluetooth.connect(device);
    }
  }

  // Putus koneksi
  Future<void> disconnect() async {
    await _bluetooth.disconnect();
  }

  // Format Cetak Struk Kasir (POS)
  Future<void> printReceipt({
    required String invoiceId,
    required String paymentMethod,
    required double totalAmount,
    required List<Map<String, dynamic>> items, // Tambahan: Menerima daftar item
  }) async {
    final isConnected = await _bluetooth.isConnected;
    if (isConnected == true) {
      _bluetooth.printNewLine();
      _bluetooth.printCustom("KONTER FEDORA", 3, 1);
      _bluetooth.printCustom("Jl. Contoh Alamat No. 123", 1, 1);
      _bluetooth.printCustom("--------------------------------", 1, 1);

      _bluetooth.printLeftRight("No: $invoiceId", "", 1);
      _bluetooth.printLeftRight(
        "Tgl: ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}",
        "",
        1,
      );
      _bluetooth.printCustom("--------------------------------", 1, 1);

      // MENCETAK DAFTAR BARANG
      for (var item in items) {
        // Format: Nama Barang (Kiri)
        _bluetooth.printCustom("${item['name']}", 1, 0);
        // Format: Qty x Harga (Kiri) --------- Subtotal (Kanan)
        _bluetooth.printLeftRight(
          "  ${item['qty']}x Rp ${item['price']}",
          "Rp ${item['subtotal']}",
          1,
        );
      }

      _bluetooth.printCustom("--------------------------------", 1, 1);
      _bluetooth.printLeftRight("TOTAL:", "Rp ${totalAmount.toInt()}", 2);
      _bluetooth.printLeftRight("BAYAR:", paymentMethod, 1);
      _bluetooth.printNewLine();
      _bluetooth.printCustom("Terima Kasih", 2, 1);
      _bluetooth.printNewLine();
      _bluetooth.printNewLine();
      _bluetooth.paperCut();
    }
  }
  // Format Cetak Resi Penerimaan Service
  Future<void> printServiceTicket({
    required String serviceId,
    required String customerName,
    required String phone,
    required String unit,
    required String complaint,
  }) async {
    final isConnected = await _bluetooth.isConnected;
    if (isConnected == true) {
      _bluetooth.printNewLine();
      _bluetooth.printCustom("KONTER FEDORA", 3, 1);
      _bluetooth.printCustom("TANDA TERIMA SERVICE", 2, 1);
      _bluetooth.printCustom("--------------------------------", 1, 1);

      _bluetooth.printLeftRight("No:", serviceId, 1);
      _bluetooth.printLeftRight("Nama:", customerName, 1);
      _bluetooth.printLeftRight("HP:", phone, 1);
      _bluetooth.printLeftRight("Unit:", unit, 1);
      _bluetooth.printCustom("Keluhan:", 1, 0);
      _bluetooth.printCustom(complaint, 1, 0);

      _bluetooth.printCustom("--------------------------------", 1, 1);
      _bluetooth.printCustom("Harap bawa resi ini saat", 1, 1);
      _bluetooth.printCustom("pengambilan unit.", 1, 1);
      _bluetooth.printNewLine();
      _bluetooth.printNewLine();
      _bluetooth.paperCut();
    }
  }
}
