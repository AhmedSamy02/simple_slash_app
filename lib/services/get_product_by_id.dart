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
      List<int> forbiddenIDs = [];
      final response = await _dio.get('$kBaseURL$_endpoints$id');
      Product product = Product();
      product.id = response.data['data']['id'];
      product.description = response.data['data']['description'];
      product.name = response.data['data']['name'];
      List<ProductVariation> variations = [];
      for (var item in response.data['data']['variations']) {
        //! Ignore if the product is not in stock
        if (item['inStock'] == false) {
          forbiddenIDs.add(item['id']);
          continue;
        }
        List<String> images = [];
        ProductVariation variation = ProductVariation(
          id: item['id'],
          price: item['price'],
          images: images,
        );
        for (var image in item['ProductVarientImages']) {
          variation.images!.add(image['image_path']);
        }
        //! Add the default to the start of the list
        if (item['isDefault']) {
          variations.insert(0, variation);
        } else {
          variations.add(variation);
        }
      }
      var properties = response.data['data']['avaiableProperties'];
      product.variations = variations;
      //get sizes if any
      if (properties.isNotEmpty) {
        for (var property in properties) {
          if (property['property'] == 'Size') {
            product.sizes = {};
            for (var size in property['values']) {
              if (forbiddenIDs.any((element) => element == size['id'])) {
                continue;
              }
              product.sizes![size['id']] = size['value'].trim();
            }
          } else if (property['property'] == 'Materials') {
            product.materials = {};
            for (var material in property['values']) {
              if (forbiddenIDs.any((element) => element == material['id'])) {
                continue;
              }
              product.materials![material['id']] = material['value'].trim();
            }
          } else if (property['property'] == 'Color') {
            product.colors = {};
            // ? Sending the default color to first
            Map<dynamic, dynamic> defaultColor = property['values'].firstWhere(
                (element) => element['id'] == product.variations!.first.id);
            product.colors![HexColor.fromHex(defaultColor['value'])] = [
              defaultColor['id']
            ];
            for (var color in property['values']) {
              try {
                if (forbiddenIDs.any((element) => element == color['id'])||color == defaultColor) {
                  continue;
                }
                if (product.colors!
                    .containsKey(HexColor.fromHex(color['value']))) {
                  product.colors![HexColor.fromHex(color['value'])]!
                      .add(color['id']);
                } else {
                  product.colors![HexColor.fromHex(color['value'])] = [
                    color['id']
                  ];
                }
              } on Exception catch (e) {
                if (product.colors!.containsKey(Colors.white)) {
                  product.colors![Colors.white]!.add(color['id']);
                } else {
                  product.colors![Colors.white] = [color['id']];
                }
              }
            }
          } else {
            product.colorImages = {};
            for (var color in property['values']) {
              if (forbiddenIDs.any((element) => element == color['id'])) {
                continue;
              }
              if (product.colorImages!.containsKey(color['value'])) {
                product.colors![color['value']]!.add(color['id']);
              } else {
                product.colors![color['value']] = [color['id']];
              }
            }
          }
        }
      }
      product.brand = Brand(
        id: response.data['data']['brand_id'],
        name: response.data['data']['brandName'],
        logo: response.data['data']['brandImage'],
      );
      for (var id in forbiddenIDs) {
        product.variations!.removeWhere((element) => element.id == id);
        if (product.colors != null) {
          product.colors!.forEach((key, value) {
            value.removeWhere((element) => element == id);
          });
        }
        if (product.colorImages != null) {
          product.colorImages!.forEach((key, value) {
            value.removeWhere((element) => element == id);
          });
        }
        if (product.sizes != null) {
          product.sizes!.remove(id);
        }
        if (product.materials != null) {
          product.materials!.remove(id);
        }
      }
      var t =
          product.getSizesAndMaterialFromColor(product.variations!.last.color);
      return product;
    } on DioException catch (e) {
      throw e.message!;
    }
  }
}
