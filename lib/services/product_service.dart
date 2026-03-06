import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'api_service.dart';

class ProductService {
  final Dio _dio = ApiService().dio;

  Future<List<Product>> getProducts({String? companyId}) async {
    try {
      final String endpoint = companyId != null ? '/products?companyId=$companyId' : '/products';
      final response = await _dio.get(endpoint);
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => Product.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching products: $e');
      throw Exception('Failed to load products');
    }
  }

  Future<Product?> getProductDetails(String id) async {
    try {
      final response = await _dio.get('/products/$id');
      if (response.statusCode == 200 && response.data != null) {
        return Product.fromJson(response.data);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching product details: $e');
      throw Exception('Failed to load product details');
    }
  }
}
