import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsLoaded extends ProductsState {
  final List<ProductEntity> products;

  const ProductsLoaded(this.products);

  ProductsLoaded copyWith({List<ProductEntity>? products}) {
    return ProductsLoaded(products ?? this.products);
  }

  @override
  List<Object?> get props => [products];
}

class ProductsActionLoading extends ProductsState {
  final List<ProductEntity> products;
  final String productId;

  const ProductsActionLoading({
    required this.products,
    required this.productId,
  });

  @override
  List<Object?> get props => [products, productId];
}

class ProductsActionSuccess extends ProductsState {
  final List<ProductEntity> products;
  final String message;

  const ProductsActionSuccess({
    required this.products,
    required this.message,
  });

  @override
  List<Object?> get props => [products, message];
}

class ProductsFailure extends ProductsState {
  final String message;
  final List<ProductEntity>? products;

  const ProductsFailure(this.message, {this.products});

  @override
  List<Object?> get props => [message, products];
}
