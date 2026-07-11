import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/datasources/local/app_database.dart';
import '../../../../data/repositories/sales_repository.dart';
import '../../../../main.dart';

// Provider untuk Repository
final salesRepositoryProvider = Provider<SalesRepository>((ref) {
  return SalesRepository(appDatabase);
});

// Model sederhana untuk menampung item di keranjang belanja
class CartItem {
  final Stock stock;
  int quantity;

  CartItem({required this.stock, this.quantity = 1});
}

// MENGGUNAKAN Notifier (Standar Modern Riverpod 2.0+)
class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return []; // Inisialisasi awal keranjang kosong
  }

  void addToCart(Stock stock) {
    final index = state.indexWhere((item) => item.stock.id == stock.id);

    if (index != -1) {
      // Jika barang sudah ada, tambah kuantitasnya (selama stok gudang masih cukup)
      if (state[index].quantity < stock.quantity) {
        final newState = [
          ...state,
        ]; // Buat salinan agar UI mendeteksi pembaruan
        newState[index].quantity++;
        state = newState;
      }
    } else {
      // Jika belum ada, masukkan sebagai item baru
      state = [...state, CartItem(stock: stock)];
    }
  }

  void removeFromCart(Stock stock) {
    state = state.where((item) => item.stock.id != stock.id).toList();
  }

  void updateQuantity(Stock stock, int newQty) {
    if (newQty <= 0) {
      removeFromCart(stock);
    } else if (newQty <= stock.quantity) {
      state = state.map((item) {
        if (item.stock.id == stock.id) {
          item.quantity = newQty;
        }
        return item;
      }).toList();
    }
  }

  void clearCart() {
    state = [];
  }
}

// MENGGUNAKAN NotifierProvider
final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});
