// ignore_for_file: file_names

import 'package:balian/models/districtInfo_model.dart';

class SubDistrictModel {
  int? id;
  String? name;
  int? districtId;
  int? fee;
  String? description;
  String? status;
  DistrictInfoModel? districtInfo;

  SubDistrictModel({
    this.id,
    this.name,
    this.districtId,
    this.fee,
    this.description,
    this.status,
    this.districtInfo,
  });

  factory SubDistrictModel.fromJson(Map<String, dynamic> json) {
    return SubDistrictModel(
      id: json['id'],
      name: json['name'],
      districtId: json['district_id'],
      fee: json['fee'],
      description: json['description'],
      status: json['status'],
      districtInfo: json['district'] != null
          ? DistrictInfoModel.fromJson(json['district'])
          : null,
    );
  }
}
