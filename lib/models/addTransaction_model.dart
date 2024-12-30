// ignore_for_file: file_names

class TransactionModel {
  final int totalPrice;
  final List<int> checkedItems;
  final Map<String, int> quantities;
  final int shippingPrice;
  final int appFee;
  final String? notes;

  TransactionModel({
    required this.totalPrice,
    required this.checkedItems,
    required this.quantities,
    required this.shippingPrice,
    required this.appFee,
    this.notes,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      totalPrice: json['total_price']?.toDouble() ?? 0.0,
      checkedItems: List<int>.from(json['checked_items'] ?? []),
      quantities: Map<String, int>.from(json['quantities'] ?? {}),
      shippingPrice: json['shipping_price']?.toDouble() ?? 0.0,
      appFee: json['app_fee']?.toDouble() ?? 0.0,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_price': totalPrice,
      'checked_items': checkedItems,
      'quantities': quantities,
      'shipping_price': shippingPrice,
      'app_fee': appFee,
      'notes': notes,
    };
  }
}
