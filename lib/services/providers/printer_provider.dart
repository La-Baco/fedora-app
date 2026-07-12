import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../printer_service.dart';

final printerServiceProvider = Provider<PrinterService>((ref) {
  return PrinterService();
});

class SelectedPrinterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setPrinter(String? macAddress) {
    state = macAddress;
  }
}

final selectedPrinterProvider =
    NotifierProvider<SelectedPrinterNotifier, String?>(() {
      return SelectedPrinterNotifier();
    });
