class AddToAddressModel {
  final String receiverName;
  final String receiverPhone;
  final int subDistrictId;
  final String address;
  final String type;
  final double? latitude;
  final double? longitude;
  final String status;

  AddToAddressModel({
    required this.receiverName,
    required this.receiverPhone,
    required this.subDistrictId,
    required this.address,
    required this.type,
    this.latitude,
    this.longitude,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'receiver_name': receiverName,
      'receiver_phone': receiverPhone,
      'sub_district_id': subDistrictId,
      'address': address,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
    };
  }
}
