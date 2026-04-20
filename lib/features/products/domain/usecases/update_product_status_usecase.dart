import '../repository/products_repository.dart';

class UpdateProductStatusUseCase {
  final ProductsRepository _repository;

  const UpdateProductStatusUseCase(this._repository);

  Future<void> call(String productId, String status) {
    return _repository.updateProductStatus(productId, status);
  }
}
