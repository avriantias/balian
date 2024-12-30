// ignore_for_file: file_names

class AddToCartModel {
  final int variantId;
  final int quantity;

  AddToCartModel({required this.variantId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      "variant_id": variantId,
      "quantity": quantity,
    };
  }
}
