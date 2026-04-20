import '../entities/product_entity.dart';

abstract class ProductsRepository {
  Future<List<ProductEntity>> getProductsByStatus(String status);
  Future<void> updateProductStatus(String productId, String status);
}
