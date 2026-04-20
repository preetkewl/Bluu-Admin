import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class FetchProducts extends ProductsEvent {
  final String status;

  const FetchProducts(this.status);

  @override
  List<Object?> get props => [status];
}

class ApproveProduct extends ProductsEvent {
  final String productId;

  const ApproveProduct(this.productId);

  @override
  List<Object?> get props => [productId];
}

class RejectProduct extends ProductsEvent {
  final String productId;

  const RejectProduct(this.productId);

  @override
  List<Object?> get props => [productId];
}
