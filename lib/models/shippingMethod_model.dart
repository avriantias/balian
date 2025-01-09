// ignore_for_file: file_names

class ShippingMethod {
  final int id;
  final String name;
  final int cost;
  final String description;

  ShippingMethod({
    required this.id,
    required this.name,
    required this.cost,
    required this.description,
  });

  factory ShippingMethod.fromJson(Map<String, dynamic> json) {
    return ShippingMethod(
      id: json['id'],
      name: json['name'],
      cost: json['cost'],
      description: json['description'],
    );
  }
}
