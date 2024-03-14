import 'package:flutter/material.dart';
import 'package:simple_slash_app/models/brand.dart';
import 'package:simple_slash_app/models/product_variation.dart';

class Product {
  int? id;
  int? price;
  String? name;
  String? description;
  String? image;
  Brand? brand;
  List<ProductVariation>? variations;
  Map<Color, int>? colors;
  List<String>? colorImages;
  Map<String, int>? sizes;
  Map<String, int>? materials;

  Product({
    this.id,
    this.price,
    this.name,
    this.description,
    this.image,
    this.brand,
    this.variations,
    this.colors,
    this.colorImages,
    this.sizes,
    this.materials,
  });

  factory Product.fromJsonHome(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      price: json['ProductVariations'][0]['price'],
      name: json['name'],
      image: json['ProductVariations'][0]['ProductVarientImages'][0]
          ['image_path'],
      brand: Brand.fromJson(json['Brands']),
    );
  }
}
