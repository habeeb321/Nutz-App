// To parse this JSON data, do
//
//     final homeModel = homeModelFromJson(jsonString);

import 'dart:convert';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  bool? success;
  int? count;
  List<Datum>? data;

  HomeModel({
    this.success,
    this.count,
    this.data,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        success: json["success"],
        count: json["count"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "count": count,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? id;
  String? name;
  double? rating;
  String? description;
  List<String>? images;
  double? price;

  Datum({
    this.id,
    this.name,
    this.rating,
    this.description,
    this.images,
    this.price,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        rating: json["rating"]?.toDouble(),
        description: json["description"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        price: json["price"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "rating": rating,
        "description": description,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "price": price,
      };
}
