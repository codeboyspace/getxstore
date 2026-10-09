import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:getx/app/constants/app_constants.dart';
import 'package:getx/app/models/product.dart';

class ApiService {
  Future<List<Product>> fetchProducts() async {
    final uri = Uri.parse(
      AppConstants.productsUrl,
    ).replace(queryParameters: {'limit': '0', 'skip': '0'});
    return _fetchProductList(uri);
  }

  Future<List<Product>> searchProducts(String query) async {
    final uri = Uri.parse(
      AppConstants.productsSearchUrl,
    ).replace(queryParameters: {'q': query});
    return _fetchProductList(uri);
  }

  Future<List<Product>> _fetchProductList(Uri uri) async {
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load products (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid products response');
    }

    final productsList = decoded['products'] as List<dynamic>? ?? [];

    return productsList
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Product> fetchProductById(int id) async {
    final uri = Uri.parse('${AppConstants.productsUrl}/$id');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load product details');
    }

    final decoded = jsonDecode(response.body);
    return Product.fromJson(decoded as Map<String, dynamic>);
  }
}
