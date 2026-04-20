import '../entities/product_entity.dart';
import '../repository/products_repository.dart';

class GetProductsUseCase {
  final ProductsRepository _repository;

  const GetProductsUseCase(this._repository);

  Future<List<ProductEntity>> call(String status) {
    return _repository.getProductsByStatus(status);
  }
}
