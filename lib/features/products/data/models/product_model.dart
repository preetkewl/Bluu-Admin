import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.status,
    super.imageUrl,
    super.sellerName,
    super.sellerId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Seller info is in 'userId' field (populated object)
    final userMap = json['userId'] as Map<String, dynamic>?;
    final sellerMap = json['seller'] as Map<String, dynamic>?;

    return ProductModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      title: json['title'] as String? ??
          json['name'] as String? ??
          'Untitled',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'pending',
      imageUrl: _extractImageUrl(json),
      sellerName: userMap?['fullName'] as String? ??
          userMap?['name'] as String? ??
          userMap?['email'] as String? ??
          sellerMap?['fullName'] as String? ??
          sellerMap?['name'] as String? ??
          json['sellerName'] as String?,
      sellerId: userMap?['_id'] as String? ??
          sellerMap?['_id'] as String? ??
          json['sellerId'] as String?,
    );
  }

  static String? _extractImageUrl(Map<String, dynamic> json) {
    final images = json['images'];
    if (images is List && images.isNotEmpty) {
      final first = images.first;
      if (first is String) return first;
      if (first is Map) {
        return first['url'] as String? ?? first['src'] as String?;
      }
    }
    return json['imageUrl'] as String? ?? json['image'] as String?;
  }

  ProductModel copyWith({
    String? id,
    String? title,
    double? price,
    String? status,
    String? imageUrl,
    String? sellerName,
    String? sellerId,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      sellerName: sellerName ?? this.sellerName,
      sellerId: sellerId ?? this.sellerId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'status': status,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (sellerName != null) 'sellerName': sellerName,
        if (sellerId != null) 'sellerId': sellerId,
      };
}
