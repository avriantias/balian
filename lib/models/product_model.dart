import 'dart:convert';
import 'category_model.dart';

class ProductModel {
  final int id;
  final int categoryId;
  final String name;
  final String slug;
  final String thumbnail;
  final String description;
  final String deliveryType;
  final List<Variant> variants;
  final CategoryModel category;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.slug,
    required this.thumbnail,
    required this.description,
    required this.deliveryType,
    required this.variants,
    required this.category,
  });

  factory ProductModel.fromRawJson(String str) =>
      ProductModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"],
        slug: json["slug"],
        thumbnail: json["thumbnail"],
        description: json["description"],
        deliveryType: json["delivery_type"],
        variants: List<Variant>.from(
            json["variants"].map((x) => Variant.fromJson(x))),
        category: CategoryModel.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "slug": slug,
        "thumbnail": thumbnail,
        "description": description,
        "delivery_type": deliveryType,
        "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
        "category": category.toJson(),
      };
}

class Variant {
  final int id;
  final int productId;
  final String name;
  final int price;
  final int isVisible;
  final int isSayur;
  final int availableStockCount;
  final List<VariantStock> variantStocks;

  Variant({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.isVisible,
    required this.isSayur,
    required this.availableStockCount,
    required this.variantStocks,
  });

  factory Variant.fromRawJson(String str) => Variant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        id: json["id"],
        productId: json["product_id"],
        name: json["name"],
        price: json["price"],
        isVisible: json["is_visible"],
        isSayur: json["is_sayur"],
        availableStockCount: json["available_stock_count"],
        variantStocks: List<VariantStock>.from(
            json["variant_stocks"].map((x) => VariantStock.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "name": name,
        "price": price,
        "is_visible": isVisible,
        "is_sayur": isSayur,
        "available_stock_count": availableStockCount,
        "variant_stocks":
            List<dynamic>.from(variantStocks.map((x) => x.toJson())),
      };
}

class VariantStock {
  final int id;
  final int productVariantId;
  final int quantity;
  final int availableStock;

  VariantStock({
    required this.id,
    required this.productVariantId,
    required this.quantity,
    required this.availableStock,
  });

  factory VariantStock.fromRawJson(String str) =>
      VariantStock.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VariantStock.fromJson(Map<String, dynamic> json) => VariantStock(
        id: json["id"],
        productVariantId: json["product_variant_id"],
        quantity: json["quantity"],
        availableStock: json["available_stock"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_variant_id": productVariantId,
        "quantity": quantity,
        "available_stock": availableStock,
      };
}
