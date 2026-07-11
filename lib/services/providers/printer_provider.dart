import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import '../printer_service.dart';

final printerServiceProvider = Provider<PrinterService>((ref) {
  return PrinterService();
});

class SelectedPrinterNotifier extends Notifier<BluetoothDevice?> {
  @override
  BluetoothDevice? build() => null;

  void setPrinter(BluetoothDevice device) {
    state = device;
  }
}

final selectedPrinterProvider =
    NotifierProvider<SelectedPrinterNotifier, BluetoothDevice?>(() {
      return SelectedPrinterNotifier();
    });
