import 'package:simple_slash_app/models/brand.dart';

class Product {
  int? id;
  int? price;
  String? name;
  String? image;
  Brand? brand;

  Product({
    this.id,
    this.price,
    this.name,
    this.image,
    this.brand,
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
