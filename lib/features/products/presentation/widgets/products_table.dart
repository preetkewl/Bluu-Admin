import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';

class ProductsTable extends StatelessWidget {
  final List<ProductEntity> products;
  final String? actionLoadingProductId;

  const ProductsTable({
    super.key,
    required this.products,
    this.actionLoadingProductId,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No pending products',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'All products have been reviewed',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width - 280,
        ),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            const Color(0xFFF9FAFB),
          ),
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
            fontSize: 13,
          ),
          dataTextStyle: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 14,
          ),
          columnSpacing: 24,
          horizontalMargin: 20,
          dividerThickness: 1,
          dataRowMinHeight: 72,
          dataRowMaxHeight: 72,
          border: TableBorder(
            horizontalInside: const BorderSide(
              color: AppTheme.borderColor,
              width: 1,
            ),
            top: const BorderSide(color: AppTheme.borderColor),
            bottom: const BorderSide(color: AppTheme.borderColor),
            left: const BorderSide(color: AppTheme.borderColor),
            right: const BorderSide(color: AppTheme.borderColor),
          ),
          columns: const [
            DataColumn(label: Text('Image')),
            DataColumn(label: Text('Title')),
            DataColumn(label: Text('Price'), numeric: true),
            DataColumn(label: Text('Seller')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: products.map((product) {
            final isActionLoading = actionLoadingProductId == product.id;
            return _buildRow(context, product, isActionLoading);
          }).toList(),
        ),
      ),
    );
  }

  DataRow _buildRow(
    BuildContext context,
    ProductEntity product,
    bool isActionLoading,
  ) {
    return DataRow(
      cells: [
        // Image
        DataCell(
          _ProductImage(imageUrl: product.imageUrl),
        ),

        // Title
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              product.title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),

        // Price
        DataCell(
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),

        // Seller
        DataCell(
          Text(
            product.sellerName ?? 'Unknown',
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
        ),

        // Status badge
        DataCell(
          _StatusBadge(status: product.status),
        ),

        // Actions
        DataCell(
          isActionLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.primaryColor,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ActionButton(
                      label: 'Approve',
                      color: AppTheme.successColor,
                      onPressed: () {
                        context
                            .read<ProductsBloc>()
                            .add(ApproveProduct(product.id));
                      },
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      label: 'Reject',
                      color: AppTheme.dangerColor,
                      onPressed: () {
                        context
                            .read<ProductsBloc>()
                            .add(RejectProduct(product.id));
                      },
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  Color get _backgroundColor {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppTheme.successColor.withValues(alpha: 0.1);
      case 'rejected':
        return AppTheme.dangerColor.withValues(alpha: 0.1);
      default:
        return AppTheme.warningColor.withValues(alpha: 0.1);
    }
  }

  Color get _textColor {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppTheme.successColor;
      case 'rejected':
        return AppTheme.dangerColor;
      default:
        return AppTheme.warningColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: _textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String? imageUrl;

  const _ProductImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.borderColor),
      ),
      clipBehavior: Clip.hardEdge,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Text(
                  'No image',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            )
          : const Center(
              child: Text(
                'No image',
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: const Size(72, 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Text(label),
    );
  }
}
