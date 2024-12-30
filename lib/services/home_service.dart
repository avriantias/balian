import 'dart:convert';
import 'dart:io';

import 'package:balian/models/category_model.dart';
import 'package:balian/models/home.dart';
import 'package:balian/models/product_model.dart';
import 'package:balian/shared/shared_values.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductServices extends ChangeNotifier {
  Future<HomeModel> getAllProduct() async {
    HomeModel temp = HomeModel(category: [], product: []);
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/home'),
      );
      Map<String, dynamic> rawdata = jsonDecode(res.body);

      if (rawdata['code'] == 200 && rawdata['status'] == "success") {
        if (rawdata['data']['categories'] != null &&
            rawdata['data']['categories'] is List) {
          List<dynamic> categori = rawdata['data']['categories'];
          temp.category!.add(CategoryModel(
              id: 0,
              name: 'Semua Jenis',
              slug: 'semua-jenis',
              image:
                  'https://uws.fsnthrds.com/storage/images/EUXd62wBJbrKWB6qS8KBrvzONGlVeOK2iPXJ2ktU.png',
              banner:
                  'https://uws.fsnthrds.com/storage/images/3ynnqOyMFgLovDpOwx7caBRARLzJBqF07UQZVB9I.png'));
          for (var element in categori) {
            temp.category!.add(CategoryModel.fromJson(element));
          }
        }

        if (rawdata['data']['products'] != null &&
            rawdata['data']['products'] is List) {
          List<dynamic> product = rawdata['data']['products'];
          for (var element in product) {
            temp.product!.add(ProductModel.fromJson(element));
          }
        }

        return temp;
      } else {
        throw rawdata['message'];
      }
    } catch (e) {
      throw e is SocketException ? 'Tidak Terkoneksi Server' : e.toString();
    }
  }
}
