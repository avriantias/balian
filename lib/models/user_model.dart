import 'package:balian/models/address_model.dart';

class UserModel {
  final int id;
  final String name;
  final int roleId;
  final String email;
  final dynamic userDetail;
  final List<AddressModel>? userAddress;

  UserModel({
    required this.id,
    required this.name,
    required this.roleId,
    required this.email,
    this.userDetail,
    this.userAddress,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      roleId: json['role_id'] is String
          ? int.parse(json['role_id'])
          : json['role_id'], // Konversi ke int jika diperlukan
      email: json['email'],
      userDetail: json['user_detail'],
      userAddress: json['user_address'] != null
          ? (json['user_address'] as List)
              .map((address) => AddressModel.fromJson(address))
              .toList()
          : null,
    );
  }
}
