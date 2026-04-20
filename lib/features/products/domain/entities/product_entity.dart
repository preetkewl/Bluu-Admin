import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String title;
  final double price;
  final String status;
  final String? imageUrl;
  final String? sellerName;
  final String? sellerId;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.status,
    this.imageUrl,
    this.sellerName,
    this.sellerId,
  });

  @override
  List<Object?> get props => [id, title, price, status, imageUrl, sellerName, sellerId];
}
