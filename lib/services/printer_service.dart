import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

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
      String receipt = "";
      receipt += "KONTER FEDORA\n";
      receipt += "--------------------------------\n";
      receipt += "No   : $invoiceId\n";
      receipt += "Kasir: $cashier\n";
      receipt += "Tgl  : ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}\n";
      receipt += "--------------------------------\n";

      for (var item in items) {
        receipt += "${item['name']}\n";
        receipt += "  ${item['qty']}x Rp ${item['price']}    Rp ${item['subtotal']}\n";
      }

      receipt += "--------------------------------\n";
      receipt += "Subtotal: Rp ${totalAmount.toInt()}\n";
      if (discountAmount > 0) {
        receipt += "Diskon  : Rp ${discountAmount.toInt()}\n";
      }
      receipt += "Total   : Rp ${(totalAmount - discountAmount).toInt()}\n";
      receipt += "Bayar   : Rp ${paymentAmount.toInt()} ($paymentMethod)\n";
      receipt += "Kembali : Rp ${changeAmount.toInt()}\n\n";
      receipt += "Terima Kasih Atas Kunjungan Anda\n\n\n";

      await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: 1, text: receipt));
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
  }) async {
    bool isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected) {
      String receipt = "";
      receipt += "KONTER FEDORA\n";
      receipt += "TANDA TERIMA SERVICE\n";
      receipt += "--------------------------------\n";
      receipt += "No     : $serviceId\n";
      receipt += "Nama   : $customerName\n";
      receipt += "HP     : $phone\n";
      receipt += "Unit   : $unit\n";
      receipt += "Keluhan: $complaint\n";
      receipt += "--------------------------------\n";
      receipt += "Harap bawa resi ini saat\n";
      receipt += "pengambilan unit.\n\n\n";

      await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: 1, text: receipt));
    }
  }
}
