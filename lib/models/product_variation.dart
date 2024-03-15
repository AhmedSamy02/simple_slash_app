import 'package:flutter/material.dart';

class ProductVariation {
  int? id;
  int? price;
  List<String>? images;
  Color? color;
  List<String>? colorImages;
  String? size;

  ProductVariation({
    this.id,
    this.price,
    this.images,
    this.color,
    this.size,
    this.colorImages,
  });
}
