import 'package:balian/models/cart_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartSuccess extends CartState {
  final String message;

  CartSuccess({required this.message});
}

class CartFailure extends CartState {
  final String error;

  CartFailure({required this.error});
}

class CartItemsLoaded extends CartState {
  final List<CartItem> items;

  CartItemsLoaded({required this.items});
}

class CartItemsDeleted extends CartState {
  final String message;

  CartItemsDeleted({required this.message});
}
