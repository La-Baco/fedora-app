import 'package:intl/intl.dart';

class CurrencyFormat {
  // Angka 2 yang salah ketik sudah dihapus di bawah ini
  static String convertToIdr(dynamic number) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(number);
  }
}
