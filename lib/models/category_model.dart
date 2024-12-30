import 'dart:convert';

class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String image;
  final String banner;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.banner,
  });

  factory CategoryModel.fromRawJson(String str) =>
      CategoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        image: json["image"],
        banner: json["banner"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "image": image,
        "banner": banner,
      };
}
