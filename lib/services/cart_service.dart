import 'dart:convert';
import 'package:balian/models/cart_model.dart';
import 'package:balian/shared/shared_values.dart';
import 'package:http/http.dart' as http;
import 'package:balian/services/secureStorage_service.dart';
import 'package:balian/models/addToCart_model.dart';

class CartService {
  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<Map<String, dynamic>> addToCart(AddToCartModel model) async {
    // Mendapatkan token dari SecureStorage
    final token = await _secureStorageService.getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    final url = Uri.parse('$baseUrl/cart');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode(model.toJson());

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 302) {
        return {'status': false, 'message': 'Redirect detected'};
      } else if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': false,
          'message':
              'Gagal menambahkan ke keranjang. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'status': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  Future<List<CartItem>> getCartItems() async {
    // Mendapatkan token dari SecureStorage
    final token = await _secureStorageService.getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    final url = Uri.parse('$baseUrl/cart');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Tidak langsung cast ke List
        if (data['data'] != null) {
          // Parsing daftar item dari field 'data'
          final items = data['data']['carts'] as List;
          return items.map((json) => CartItem.fromJson(json)).toList();
        } else {
          throw Exception('Data tidak ditemukan');
        }
      } else {
        throw Exception(
            'Gagal mengambil data keranjang. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Method untuk menghapus item keranjang
  Future<Map<String, dynamic>> deleteCartItems(List<int> itemIds) async {
    final token = await _secureStorageService.getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    final url = Uri.parse('$baseUrl/cart');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // Kirim data dalam format JSON untuk `DELETE` method
    final body = jsonEncode({'items': itemIds});

    try {
      final response = await http.delete(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return {'status': true, 'message': 'Item berhasil dihapus'};
      } else {
        final data = jsonDecode(response.body);
        return {
          'status': false,
          'message': data['message'] ?? 'Gagal menghapus item'
        };
      }
    } catch (e) {
      return {'status': false, 'message': 'Terjadi kesalahan: ${e.toString()}'};
    }
  }
}
