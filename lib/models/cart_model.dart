class CartItem {
  final int id;
  final int userId;
  final int variantId;
  int quantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Variant variant;
  bool isChecked;

  CartItem({
    required this.id,
    required this.userId,
    required this.variantId,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    required this.variant,
    this.isChecked = false,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      userId: json['user_id'],
      variantId: json['variant_id'],
      quantity: json['quantity'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      variant: Variant.fromJson(json['variant']),
    );
  }

  CartItem copyWith({
    int? id,
    int? userId,
    int? variantId,
    int? quantity,
    DateTime? createdAt,
    DateTime? updatedAt,
    Variant? variant,
    bool? isChecked,
  }) {
    return CartItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      variant: variant ?? this.variant,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}

class Variant {
  final int id;
  final int productId;
  final String name;
  final double price;
  final bool isVisible;
  final Product product;

  Variant({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.isVisible,
    required this.product,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'],
      productId: json['product_id'],
      name: json['name'],
      price: json['price'].toDouble(),
      isVisible: json['is_visible'] == 1,
      product: Product.fromJson(json['product']),
    );
  }
}

class Product {
  final int id;
  final String name;
  final String thumbnail;

  Product({required this.id, required this.name, required this.thumbnail});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      thumbnail: json['thumbnail'],
    );
  }
}
