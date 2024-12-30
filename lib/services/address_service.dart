import 'dart:convert';
import 'package:balian/models/addAddress_model.dart';
import 'package:balian/shared/shared_values.dart';
import 'package:http/http.dart' as http;
import 'package:balian/models/address_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddressService {
  final _storage = const FlutterSecureStorage();

  Future<List<AddressModel>> getAddresses() async {
    // Ambil token dari SecureStorage
    String? token = await _storage.read(key: 'token');

    // Request ke API
    final response = await http.get(
      Uri.parse('$baseUrl/user-address'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // Decode response body
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Ambil daftar alamat dari key "data"
      final List<dynamic> data = jsonResponse['data'];

      // Mapping ke model
      return data.map((json) => AddressModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load addresses: ${response.body}');
    }
  }

  Future<void> addAddress(AddAddressModel address, String token) async {
    String? token = await _storage.read(key: 'token');

    final url = Uri.parse('$baseUrl/user-address');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(address.toJson()),
      );

      if (response.statusCode == 201) {
        // Sukses
        return;
      } else {
        // Gagal, menampilkan informasi lebih lanjut
        throw Exception(
            'Failed to add address. Status code: ${response.statusCode}. Body: ${response.body}');
      }
    } catch (e) {
      // Tangani error jaringan atau kesalahan lain
      throw Exception('Error occurred while adding address: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getDistricts() async {
    String? token =
        await _storage.read(key: 'token'); // Ambil token dari SecureStorage

    final response = await http.get(
      Uri.parse('$baseUrl/districts'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['data'].map((item) {
        return {
          'districtName': item['name'],
          'districtId': item['id'],
          'subdistricts':
              item['subdistricts'], // Subdistricts dalam bentuk list
        };
      }));
    } else {
      throw Exception('Failed to load districts');
    }
  }

  Future<void> editAddress(
      int addressId, AddressModel address, String token) async {
    String? token = await _storage.read(key: 'token');

    final response = await http.put(
      Uri.parse('$baseUrl/user-address/$addressId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'receiver_name': address.receiverName,
        'receiver_phone': address.receiverPhone,
        'sub_district_id': address.subDistrictId,
        'address': address.address,
        'latitude': address.latitude,
        'longitude': address.longitude,
        'type': address.type,
        'status': address.status,
      }),
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Gagal memperbarui alamat: ${response.body}');
    }
  }

  Future<AddressModel> getAddressById(int id) async {
    String? token = await _storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/user-address/$id');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AddressModel.fromJson(data['data']);
      } else {
        throw Exception('Gagal mendapatkan detail alamat: ${response.body}');
      }
    } catch (e) {
      throw Exception('Gagal memuat data: $e');
    }
  }

  Future<bool> deleteAddress(int addressId) async {
    // Ambil token dari SecureStorage
    String? token = await _storage.read(key: 'token');

    if (token == null) {
      return false;
    }

    final url = Uri.parse('$baseUrl/user-address/$addressId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Menambahkan token di header
        },
      );

      if (response.statusCode == 200) {
        // Jika berhasil dihapus
        return true;
      } else {
        // Jika gagal
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
