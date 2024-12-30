// ignore_for_file: file_names

class EditAddressModel {
  final int id;
  final String name;
  final String phone;
  final String address;
  final String district;
  final int subDistrict;
  final String type;
  final String status;

  EditAddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.district,
    required this.subDistrict,
    required this.type,
    required this.status,
  });

  // Konversi EditAddressModel ke Map untuk pengiriman API
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'district': district,
      'sub_district': subDistrict,
      'type': type,
      'status': status,
    };
  }

  // Konversi Map ke EditAddressModel
  factory EditAddressModel.fromMap(Map<String, dynamic> map) {
    return EditAddressModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      address: map['address'],
      district: map['district'],
      subDistrict: map['sub_district'],
      type: map['type'],
      status: map['status'],
    );
  }
}
