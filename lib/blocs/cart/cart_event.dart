abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final int variantId;
  final int quantity;

  AddToCartEvent({required this.variantId, required this.quantity});
}

class FetchCartItemsEvent extends CartEvent {}

class DeleteCartItemsEvent extends CartEvent {
  final List<int> itemIds;

  DeleteCartItemsEvent({required this.itemIds});
}
