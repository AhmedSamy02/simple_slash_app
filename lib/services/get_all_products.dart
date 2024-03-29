import 'package:dio/dio.dart';
import 'package:simple_slash_app/constants.dart';
import 'package:simple_slash_app/models/product.dart';

class GetAllProducts {
  GetAllProducts._();
  static const _endpoint = 'product';
  static final _dio = Dio();
  static Future<List<Product>> getProducts(int pageSize, int pageNumber) async {
    try {
      final response = await _dio.get(kBaseURL + _endpoint, queryParameters: {
        'page': pageNumber ~/ pageSize + 1,
        'limit': pageSize,
      });
      List<Product> products = [];
      
      for (var item in response.data['data']) {
        products.add(Product.fromJsonHome(item));
      }
      return products;
    } catch (e) {
      logger.e(e);
      throw e;
    }
  }
}
