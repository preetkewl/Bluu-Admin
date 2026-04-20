import 'package:dio/dio.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProductsByStatus(String status);
  Future<void> updateProductStatus(String productId, String status);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final Dio _dio;

  const ProductsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ProductModel>> getProductsByStatus(String status) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.productsByStatus,
        queryParameters: {'status': status},
      );

      final data = response.data;
      List<dynamic> productsList;

      if (data is List) {
        productsList = data;
      } else if (data is Map<String, dynamic>) {
        productsList = data['products'] as List<dynamic>? ??
            data['data'] as List<dynamic>? ??
            [];
      } else {
        productsList = [];
      }

      return productsList
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppError.fromDioException(e);
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(message: e.toString());
    }
  }

  @override
  Future<void> updateProductStatus(String productId, String status) async {
    try {
      await _dio.patch(
        ApiEndpoints.updateProductStatus(productId),
        data: {'status': status},
      );
    } on DioException catch (e) {
      throw AppError.fromDioException(e);
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(message: e.toString());
    }
  }
}
