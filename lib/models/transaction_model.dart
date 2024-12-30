class TransactionItemModel {
  final int id;
  final int userId;
  final int totalPrice;
  final String status;
  final String code;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Detail> details;
  final User user;
  late bool isExpanded = false;
  final int shippingPrice;
  final dynamic notes;
  final String additionalCost;

  TransactionItemModel({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.status,
    required this.code,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.details,
    required this.user,
    required this.shippingPrice,
    required this.notes,
    required this.additionalCost,
  });

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) =>
      TransactionItemModel(
        id: json['id'],
        userId: json['user_id'],
        totalPrice: json['total_price'],
        status: json['status'],
        code: json['code'],
        address: json['address'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        details:
            List<Detail>.from(json['details'].map((x) => Detail.fromJson(x))),
        user: User.fromJson(
          json['user'],
        ),
        shippingPrice: json['shipping_price'],
        notes: json['notes'],
        additionalCost: json['additional_cost'],
      );

  // copyWith method
  TransactionItemModel copyWith({
    int? id,
    int? userId,
    int? totalPrice,
    String? status,
    String? code,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Detail>? details,
    User? user,
    bool? isExpanded,
    int? shippingPrice,
    // ignore: unnecessary_question_mark
    dynamic? notes,
    String? additionalCost,
  }) {
    return TransactionItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      code: code ?? this.code,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      details: details ?? this.details,
      user: user ?? this.user,
      shippingPrice: shippingPrice ?? this.shippingPrice,
      notes: notes ?? this.notes,
      additionalCost: additionalCost ?? this.additionalCost,
    );
  }

  // Contoh data dalam bentuk Map<String, dynamic>
  Map<String, dynamic> transactionMap = {
    'id': 1,
    'user_id': 123,
    'total_price': 50000,
    'status': 'pending',
    'code': 'ABC123',
    'address': 'Jl. Raya No. 123',
    'created_at': '2024-12-25T10:00:00',
    'updated_at': '2024-12-25T10:00:00',
    'details': [], // Anda bisa menyesuaikan dengan data Detail
    'user': {
      'id': 123,
      'name': 'John Doe',
      'email': 'john@example.com',
    }, // Anda bisa menyesuaikan dengan data User
    'shipping_price': 10000,
    'notes': null,
    'additional_cost': '0',
  };
}

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
      );

  // copyWith method
  User copyWith({
    int? id,
    String? name,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}

class Detail {
  final int id;
  final int transactionId;
  final int variantId;
  final int quantity;
  final int price;
  final int capitalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Variant variant;

  Detail({
    required this.id,
    required this.transactionId,
    required this.variantId,
    required this.quantity,
    required this.price,
    required this.capitalPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.variant,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json['id'],
        transactionId: json['transaction_id'],
        variantId: json['variant_id'],
        quantity: json['quantity'],
        price: json['price'],
        capitalPrice: json['capital_price'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        variant: Variant.fromJson(json['variant']),
      );

  // copyWith method
  Detail copyWith({
    int? id,
    int? transactionId,
    int? variantId,
    int? quantity,
    int? price,
    int? capitalPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
    Variant? variant,
  }) {
    return Detail(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      capitalPrice: capitalPrice ?? this.capitalPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      variant: variant ?? this.variant,
    );
  }
}

class Variant {
  final int id;
  final int productId;
  final String name;
  final int price;
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

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        id: json['id'],
        productId: json['product_id'],
        name: json['name'],
        price: json['price'],
        isVisible: json['is_visible'] == 1,
        product: Product.fromJson(json['product']),
      );

  // copyWith method
  Variant copyWith({
    int? id,
    int? productId,
    String? name,
    int? price,
    bool? isVisible,
    Product? product,
  }) {
    return Variant(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      isVisible: isVisible ?? this.isVisible,
      product: product ?? this.product,
    );
  }
}

class Product {
  final int id;
  final int categoryId;
  final String name;
  final String slug;
  final String thumbnail;
  final String description;
  final String deliveryType;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.slug,
    required this.thumbnail,
    required this.description,
    required this.deliveryType,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        categoryId: json['category_id'],
        name: json['name'],
        slug: json['slug'],
        thumbnail: json['thumbnail'],
        description: json['description'],
        deliveryType: json['delivery_type'],
      );

  // copyWith method
  Product copyWith({
    int? id,
    int? categoryId,
    String? name,
    String? slug,
    String? thumbnail,
    String? description,
    String? deliveryType,
  }) {
    return Product(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      deliveryType: deliveryType ?? this.deliveryType,
    );
  }
}
