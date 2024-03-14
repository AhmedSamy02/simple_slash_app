import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:simple_slash_app/constants.dart';
import 'package:simple_slash_app/models/brand.dart';
import 'package:simple_slash_app/models/product.dart';
import 'package:simple_slash_app/models/product_variation.dart';

class GetProductById {
  GetProductById._();
  static final _dio = Dio();
  static const _endpoints = 'product/';
  static Future<Product> getProductById(int id) async {
    try {
      final response = await _dio.get('$kBaseURL$_endpoints$id');
      Product product = Product();
      product.id = response.data['data']['id'];
      product.description = response.data['data']['description'];
      product.name = response.data['data']['name'];
      List<ProductVariation> variations = [];
      for (var item in response.data['data']['variations']) {
        List<String> images = [];
        ProductVariation variation = ProductVariation(
          id: item['id'],
          price: item['price'],
          images: images,
        );
        for (var image in item['ProductVarientImages']) {
          variation.images!.add(image['image_path']);
        }
        variations.add(variation);
      }
      var properties = response.data['data']['avaiableProperties'];
      product.variations = variations;
      //get sizes if any
      if (properties.isNotEmpty) {
        for (var property in properties) {
          if (property['property'] == 'Size') {
            product.sizes = {};
            for (var size in property['values']) {
              product.sizes![size['value']] = size['id'];
            }
          } else if (property['property'] == 'Materials') {
            product.materials = {};
            for (var material in property['values']) {
              product.materials![material['value']] = material['id'];
            }
          } else if (property['property'] == 'Color') {
            product.colors = {};
            for (var color in property['values']) {
              product.colors![HexColor.fromHex(color['value'])] = color['id'];
            }
          }
        }
      }
      product.brand = Brand(
        id: response.data['data']['brand_id'],
        name: response.data['data']['brandName'],
        logo: response.data['data']['brandImage'],
      );
      return product;
    } on DioException catch (e) {
      throw e.message!;
    }
  }
}
