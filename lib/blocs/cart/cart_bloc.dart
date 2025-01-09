import 'package:balian/blocs/cart/cart_event.dart';
import 'package:balian/blocs/cart/cart_state.dart';
import 'package:balian/models/addToCart_model.dart';
import 'package:balian/models/cart_model.dart';
import 'package:balian/services/cart_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService cartService;
  List<CartItem> items = [];
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  CartBloc({required this.cartService}) : super(CartInitial()) {
    on<AddToCartEvent>((event, emit) async {
      emit(CartLoading());

      try {
        // Panggil service untuk menambahkan ke keranjang
        final response = await cartService.addToCart(
          AddToCartModel(
            variantId: event.variantId,
            quantity: event.quantity,
          ),
        );

        // Validasi respons dari API
        if (response['status'] == 'success') {
          // Periksa apakah 'status' adalah 'success'
          emit(CartSuccess(
            message: response['message'] ??
                'Produk berhasil ditambahkan ke keranjang.',
          ));
        } else {
          emit(CartFailure(
            error: response['message'] ??
                'Terjadi kesalahan saat menambahkan produk.',
          ));
        }
      } catch (e) {
        emit(CartFailure(error: 'Silahkan isi alamat terlebih dahulu!!!'));
      }
    });

    // Event untuk mengambil data keranjang
    on<FetchCartItemsEvent>((event, emit) async {
      emit(CartLoading());

      try {
        // Ambil token dari SecureStorage
        String? token = await secureStorage.read(key: 'token');

        if (token == null) {
          emit(CartFailure(error: 'Token tidak ditemukan'));
          return;
        }

        // Panggil service untuk mengambil data keranjang tanpa menyertakan token
        final items = await cartService.getCartItems();

        emit(
          CartItemsLoaded(
            items: items.carts,
            shippingMethods: items.shippingMethods,
          ),
        );
      } catch (e) {
        emit(CartFailure(
            error: 'Gagal mengambil data keranjang: ${e.toString()}'));
      }
    });

    on<DeleteCartItemsEvent>((event, emit) async {
      emit(CartLoading());
      try {
        final response = await cartService.deleteCartItems(event.itemIds);

        if (response['status'] == true) {
          // Fetch data keranjang terbaru setelah penghapusan
          final updatedItems = await cartService.getCartItems();
          emit(CartItemsLoaded(
            items: updatedItems.carts,
            shippingMethods: updatedItems.shippingMethods,
          ));
        } else {
          emit(CartFailure(
              error: response['message'] ?? 'Gagal menghapus item'));
        }
      } catch (e) {
        emit(CartFailure(error: 'Gagal menghapus item: ${e.toString()}'));
      }
    });
  }
}
