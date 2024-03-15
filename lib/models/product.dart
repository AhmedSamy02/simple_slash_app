import 'package:analyzer_plugin/utilities/pair.dart';
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
  //? Color and all ids corresponds this color
  Map<Color, List<int>>? colors;
  Map<String, List<int>>? colorImages;
  //* id and corresponding size
  Map<int, String>? sizes;
  //* id and corresponding material
  Map<int, String>? materials;

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
    String image = 'sdfds';
    if (json['ProductVariations'][0]['ProductVarientImages'].isNotEmpty) {
      image =
          json['ProductVariations'][0]['ProductVarientImages'][0]['image_path'];
    }
    return Product(
      id: json['id'],
      price: json['ProductVariations'][0]['price'],
      name: json['name'],
      image: image,
      brand: Brand.fromJson(json['Brands']),
    );
  }
  Pair<List<String>, List<String>> getSizesAndMaterialFromColor(Color? color) {
    List<String> sizes = [];
    List<String> materials = [];
    // ! pass the color with null if there's no color list
    if (color == null) {
      if (this.sizes != null) {
        sizes = this.sizes!.values.toList();
      }
      if (this.materials != null) {
        materials = this.materials!.values.toList();
      }
      return Pair(sizes, materials);
    }

    for (var element in colors![color]!) {
      if (this.sizes != null) {
        sizes.add(this.sizes![element]!);
      }
      if (this.materials != null) {
        materials.add(this.materials![element]!);
      }
    }
    return Pair(sizes, materials);
  }
  Pair<List<String>, List<String>> getSizesAndMaterialFromColorImage(String? color) {
    List<String> sizes = [];
    List<String> materials = [];
    // ! pass the color with null if there's no color list
    if (color == null) {
      if (this.sizes != null) {
        sizes = this.sizes!.values.toList();
      }
      if (this.materials != null) {
        materials = this.materials!.values.toList();
      }
      return Pair(sizes, materials);
    }

    for (var element in colorImages![color]!) {
      if (this.sizes != null) {
        sizes.add(this.sizes![element]!);
      }
      if (this.materials != null) {
        materials.add(this.materials![element]!);
      }
    }
    return Pair(sizes, materials);
  }
}
