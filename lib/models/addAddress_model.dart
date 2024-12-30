// ignore_for_file: file_names

class AddAddressModel {
  final String name;
  final String phone;
  final String address;
  final String district;
  final int subDistrict;
  final String type;
  final String status;

  AddAddressModel({
    required this.name,
    required this.phone,
    required this.address,
    required this.district,
    required this.subDistrict,
    required this.type,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'receiver_name': name,
      'receiver_phone': phone,
      'sub_district_id': subDistrict,
      'address': address,
      'type': type,
      'status': status,
    };
  }
}
