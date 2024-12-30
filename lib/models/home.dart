import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:balian/models/category_model.dart';
import 'package:balian/models/product_model.dart';

class HomeModel extends ChangeNotifier {
  List<ProductModel>? product;
  List<CategoryModel>? category;

  HomeModel({required this.category, required this.product});

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        category: (json['category'] as List)
            .map((i) => CategoryModel.fromJson(i))
            .toList(),
        product: (json['product'] as List)
            .map((i) => ProductModel.fromJson(i))
            .toList(),
      );
}
