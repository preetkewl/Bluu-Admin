import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/update_product_status_usecase.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase _getProductsUseCase;
  final UpdateProductStatusUseCase _updateProductStatusUseCase;

  ProductsBloc({
    required GetProductsUseCase getProductsUseCase,
    required UpdateProductStatusUseCase updateProductStatusUseCase,
  })  : _getProductsUseCase = getProductsUseCase,
        _updateProductStatusUseCase = updateProductStatusUseCase,
        super(const ProductsInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<ApproveProduct>(_onApproveProduct);
    on<RejectProduct>(_onRejectProduct);
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());
    try {
      final products = await _getProductsUseCase(event.status);
      emit(ProductsLoaded(products));
    } on AppError catch (e) {
      emit(ProductsFailure(e.message));
    } catch (e) {
      emit(ProductsFailure(e.toString()));
    }
  }

  Future<void> _onApproveProduct(
    ApproveProduct event,
    Emitter<ProductsState> emit,
  ) async {
    final currentProducts = _getCurrentProducts();
    if (currentProducts == null) return;

    emit(ProductsActionLoading(
      products: currentProducts,
      productId: event.productId,
    ));

    try {
      await _updateProductStatusUseCase(
        event.productId,
        AppConstants.statusApproved,
      );
      final updatedProducts =
          currentProducts.where((p) => p.id != event.productId).toList();
      emit(ProductsActionSuccess(
        products: updatedProducts,
        message: 'Product approved successfully',
      ));
    } on AppError catch (e) {
      emit(ProductsFailure(e.message, products: currentProducts));
    } catch (e) {
      emit(ProductsFailure(e.toString(), products: currentProducts));
    }
  }

  Future<void> _onRejectProduct(
    RejectProduct event,
    Emitter<ProductsState> emit,
  ) async {
    final currentProducts = _getCurrentProducts();
    if (currentProducts == null) return;

    emit(ProductsActionLoading(
      products: currentProducts,
      productId: event.productId,
    ));

    try {
      await _updateProductStatusUseCase(
        event.productId,
        AppConstants.statusRejected,
      );
      final updatedProducts =
          currentProducts.where((p) => p.id != event.productId).toList();
      emit(ProductsActionSuccess(
        products: updatedProducts,
        message: 'Product rejected successfully',
      ));
    } on AppError catch (e) {
      emit(ProductsFailure(e.message, products: currentProducts));
    } catch (e) {
      emit(ProductsFailure(e.toString(), products: currentProducts));
    }
  }

  List<ProductEntity>? _getCurrentProducts() {
    final s = state;
    if (s is ProductsLoaded) return List<ProductEntity>.from(s.products);
    if (s is ProductsActionLoading) return List<ProductEntity>.from(s.products);
    if (s is ProductsActionSuccess) return List<ProductEntity>.from(s.products);
    if (s is ProductsFailure && s.products != null) {
      return List<ProductEntity>.from(s.products!);
    }
    return null;
  }
}
