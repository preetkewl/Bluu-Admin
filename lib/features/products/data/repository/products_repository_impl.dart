import '../../domain/entities/product_entity.dart';
import '../../domain/repository/products_repository.dart';
import '../datasource/products_remote_datasource.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource _remoteDataSource;

  const ProductsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ProductEntity>> getProductsByStatus(String status) {
    return _remoteDataSource.getProductsByStatus(status);
  }

  @override
  Future<void> updateProductStatus(String productId, String status) {
    return _remoteDataSource.updateProductStatus(productId, status);
  }
}
