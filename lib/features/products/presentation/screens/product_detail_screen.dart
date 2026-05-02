import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/app_snackbar.dart';
import '../../../../shared/widgets/dashboard_layout.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      activeRoute: '/dashboard/products',
      pageTitle: 'Admin Panel',
      child: BlocConsumer<ProductsBloc, ProductsState>(
        listener: (context, state) {
          if (state is ProductsActionSuccess) {
            AppSnackbar.showSuccess(context, state.message);
            context.go('/dashboard/products');
          } else if (state is ProductsFailure) {
            AppSnackbar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isActionLoading =
              state is ProductsActionLoading && state.productId == product.id;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BackHeader(productTitle: product.title),
                const SizedBox(height: 24),
                _DetailCard(
                  product: product,
                  isActionLoading: isActionLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BackHeader extends StatelessWidget {
  final String productTitle;

  const _BackHeader({required this.productTitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.go('/dashboard/products'),
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.cardWhite,
            side: const BorderSide(color: AppTheme.borderColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Detail',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 2),
            Text(
              productTitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  final ProductEntity product;
  final bool isActionLoading;

  const _DetailCard({required this.product, required this.isActionLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top image + basic info row
          Padding(
            padding: const EdgeInsets.all(24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 600;
                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProductImageLarge(imageUrl: product.imageUrl),
                      const SizedBox(height: 20),
                      _ProductInfo(product: product),
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProductImageLarge(imageUrl: product.imageUrl),
                    const SizedBox(width: 24),
                    Expanded(child: _ProductInfo(product: product)),
                  ],
                );
              },
            ),
          ),

          const Divider(color: AppTheme.borderColor, height: 1),

          // Metadata fields
          Padding(
            padding: const EdgeInsets.all(24),
            child: _MetadataGrid(product: product),
          ),

          // Actions (only for pending products)
          if (product.status.toLowerCase() == 'pending') ...[
            const Divider(color: AppTheme.borderColor, height: 1),
            Padding(
              padding: const EdgeInsets.all(24),
              child: _ActionRow(
                product: product,
                isLoading: isActionLoading,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProductImageLarge extends StatelessWidget {
  final String? imageUrl;

  const _ProductImageLarge({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
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
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                    strokeWidth: 2,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) =>
                  _NoImagePlaceholder(),
            )
          : _NoImagePlaceholder(),
    );
  }
}

class _NoImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_not_supported_outlined,
            size: 36, color: AppTheme.textSecondary),
        SizedBox(height: 8),
        Text(
          'No image',
          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final ProductEntity product;

  const _ProductInfo({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              '₹${product.price.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            _StatusBadge(status: product.status),
          ],
        ),
        const SizedBox(height: 16),
        if (product.sellerName != null) ...[
          Row(
            children: [
              const Icon(Icons.storefront_outlined,
                  size: 16, color: AppTheme.textSecondary),
              const SizedBox(width: 6),
              Text(
                'Sold by ${product.sellerName}',
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _MetadataGrid extends StatelessWidget {
  final ProductEntity product;

  const _MetadataGrid({required this.product});

  @override
  Widget build(BuildContext context) {
    final fields = [
      _MetaField(label: 'Product ID', value: product.id),
      _MetaField(label: 'Status', value: product.status.toUpperCase()),
      _MetaField(
          label: 'Seller Name', value: product.sellerName ?? 'Unknown'),
      _MetaField(label: 'Seller ID', value: product.sellerId ?? 'N/A'),
      _MetaField(
          label: 'Price', value: '₹${product.price.toStringAsFixed(0)}'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Information',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: fields
              .map((f) => SizedBox(width: 280, child: _MetaFieldTile(field: f)))
              .toList(),
        ),
      ],
    );
  }
}

class _MetaField {
  final String label;
  final String value;
  const _MetaField({required this.label, required this.value});
}

class _MetaFieldTile extends StatelessWidget {
  final _MetaField field;

  const _MetaFieldTile({required this.field});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundGrey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            field.value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final ProductEntity product;
  final bool isLoading;

  const _ActionRow({required this.product, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review Action',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'Approve or reject this product submission',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        if (isLoading)
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppTheme.primaryColor,
            ),
          )
        else
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => context
                    .read<ProductsBloc>()
                    .add(ApproveProduct(product.id)),
                icon: const Icon(Icons.check, size: 16),
                label: const Text('Approve'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => context
                    .read<ProductsBloc>()
                    .add(RejectProduct(product.id)),
                icon: const Icon(Icons.close, size: 16),
                label: const Text('Reject'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.dangerColor,
                  side: const BorderSide(color: AppTheme.dangerColor),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    switch (status.toLowerCase()) {
      case 'approved':
        bg = AppTheme.successColor.withValues(alpha: 0.1);
        fg = AppTheme.successColor;
        break;
      case 'rejected':
        bg = AppTheme.dangerColor.withValues(alpha: 0.1);
        fg = AppTheme.dangerColor;
        break;
      default:
        bg = AppTheme.warningColor.withValues(alpha: 0.1);
        fg = AppTheme.warningColor;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
