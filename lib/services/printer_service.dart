import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;


class PrinterService {
  Future<List<BluetoothInfo>> getBondedDevices() async {
    return await PrintBluetoothThermal.pairedBluetooths;
  }

  Future<void> connect(String macAddress) async {
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (!connectionStatus) {
      await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
    }
  }

  Future<void> disconnect() async {
    await PrintBluetoothThermal.disconnect;
  }

  Future<void> printReceipt({
    required String invoiceId,
    required String cashier,
    required String paymentMethod,
    required double totalAmount,
    required double paymentAmount,
    required double changeAmount,
    required double discountAmount,
    required List<Map<String, dynamic>> items,
  }) async {
    bool isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected) {
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);
      List<int> bytes = [];

      try {
        final ByteData data = await rootBundle.load('assets/logo-bg.png');
        final Uint8List imgBytes = data.buffer.asUint8List();
        final img.Image? image = img.decodeImage(imgBytes);
        if (image != null) {
          final img.Image resized = img.copyResize(image, width: 200); 
          bytes += generator.image(resized, align: PosAlign.center);
        }
      } catch (e) {
        debugPrint("Error loading image: $e");
      }

      bytes += generator.text("KONTER FEDORA",
          styles: const PosStyles(
            align: PosAlign.center,
            bold: true,
          ));
      bytes += generator.text("--------------------------------");
      bytes += generator.text("No   : $invoiceId");
      bytes += generator.text("Kasir: $cashier");
      bytes += generator.text("Tgl  : ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}");
      bytes += generator.text("--------------------------------");

      for (var item in items) {
        bytes += generator.text("${item['name']}");
        bytes += generator.text("  ${item['qty']}x Rp ${item['price']}    Rp ${item['subtotal']}");
      }

      bytes += generator.text("--------------------------------");
      bytes += generator.text("Subtotal: Rp ${totalAmount.toInt()}");
      if (discountAmount > 0) {
        bytes += generator.text("Diskon  : Rp ${discountAmount.toInt()}");
      }
      bytes += generator.text("Total   : Rp ${(totalAmount - discountAmount).toInt()}");
      bytes += generator.text("Bayar   : Rp ${paymentAmount.toInt()} ($paymentMethod)");
      bytes += generator.text("Kembali : Rp ${changeAmount.toInt()}");
      bytes += generator.feed(1);
      bytes += generator.text("Simpan Resi ini", styles: const PosStyles(align: PosAlign.center));
      bytes += generator.text("Sebagai Bukti Transaksi Sah", styles: const PosStyles(align: PosAlign.center));
      bytes += generator.text("*** TERIMA KASIH ***", styles: const PosStyles(align: PosAlign.center));
      bytes += generator.feed(3);

      await PrintBluetoothThermal.writeBytes(bytes);
    } else {
      debugPrint("Printer tidak terkoneksi.");
    }
  }

  Future<void> printServiceTicket({
    required String serviceId,
    required String customerName,
    required String phone,
    required String unit,
    required String complaint,
    required double totalCost,
  }) async {
    bool isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected) {
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);
      List<int> bytes = [];

      try {
        final ByteData data = await rootBundle.load('assets/logo-bg.png');
        final Uint8List imgBytes = data.buffer.asUint8List();
        final img.Image? image = img.decodeImage(imgBytes);
        if (image != null) {
          final img.Image resized = img.copyResize(image, width: 200); 
          bytes += generator.image(resized, align: PosAlign.center);
        }
      } catch (e) {
        debugPrint("Error loading image: $e");
      }

      bytes += generator.text("KONTER FEDORA",
          styles: const PosStyles(
            align: PosAlign.center,
            bold: true,
          ));
      bytes += generator.text("TANDA TERIMA SERVICE", styles: const PosStyles(align: PosAlign.center));
      bytes += generator.text("--------------------------------");
      bytes += generator.text("No     : $serviceId");
      bytes += generator.text("Tgl    : ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}");
      bytes += generator.text("Nama   : $customerName");
      bytes += generator.text("HP     : $phone");
      bytes += generator.text("Unit   : $unit");
      bytes += generator.text("Keluhan: $complaint");
      bytes += generator.text("Total  : Rp ${totalCost.toInt()}");
      bytes += generator.text("--------------------------------");
      bytes += generator.text("Simpan Resi ini", styles: const PosStyles(align: PosAlign.center));
      bytes += generator.text("Sebagai Bukti Transaksi Sah", styles: const PosStyles(align: PosAlign.center));
      bytes += generator.text("*** TERIMA KASIH ***", styles: const PosStyles(align: PosAlign.center));
      bytes += generator.feed(3);

      await PrintBluetoothThermal.writeBytes(bytes);
    }
  }
}
