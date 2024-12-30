import 'package:balian/models/subDistrict_model.dart';

class AddressModel {
  final int id;
  final int userId;
  final int subDistrictId;
  final String address;
  final String? latitude;
  final String? longitude;
  final String type;
  final String receiverName;
  final String receiverPhone;
  final String status;
  final String? createdAt;
  final String? updatedAt;
  final SubDistrictModel? subDistrict;

  AddressModel({
    required this.id,
    required this.userId,
    required this.subDistrictId,
    required this.address,
    this.latitude,
    this.longitude,
    required this.type,
    required this.receiverName,
    required this.receiverPhone,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.subDistrict,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      userId: json['user_id'],
      subDistrictId: json['sub_district_id'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      type: json['type'],
      receiverName: json['receiver_name'],
      receiverPhone: json['receiver_phone'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      subDistrict: json['sub_district'] != null
          ? SubDistrictModel.fromJson(json['sub_district'])
          : null,
    );
  }
}
