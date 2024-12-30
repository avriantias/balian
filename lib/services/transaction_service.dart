import 'dart:convert';

import 'package:balian/models/addTransaction_model.dart';
import 'package:balian/models/transaction_model.dart';
import 'package:balian/shared/shared_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TransactionService extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  Future<bool> createTransaction(TransactionModel transaction) async {
    String? token = await _storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/transactions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(transaction.toJson()),
      );

      if (response.statusCode == 201) {
        return true; // Transaksi berhasil
      } else {
        throw Exception('Failed to create transaction: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<TransactionItemModel>> fetchTransactions(String token) async {
    String? token = await _storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/transactions');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      final List<dynamic> data = decodedResponse['data']; // Akses kunci 'data'
      return data.map((e) => TransactionItemModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch transactions: ${response.reasonPhrase}');
    }
  }

  Future<bool> cancelTransaction(String transactionId, String token) async {
    String? token = await _storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/transactions/$transactionId/status');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: json
            .encode({'status': 'cancelled'}), // Update status jadi 'cancelled'
      );

      if (response.statusCode == 200) {
        return true; // Status transaksi berhasil diupdate menjadi cancelled
      } else {
        throw Exception('Failed to cancel transaction: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
