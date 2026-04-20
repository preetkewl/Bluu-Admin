import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/constants.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/app_snackbar.dart';
import '../../../../shared/widgets/dashboard_layout.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import '../widgets/products_table.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(
          const FetchProducts(AppConstants.statusPending),
        );
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      activeRoute: '/dashboard/products',
      pageTitle: 'Admin Panel',
      child: BlocConsumer<ProductsBloc, ProductsState>(
        listener: (context, state) {
          if (state is ProductsActionSuccess) {
            AppSnackbar.showSuccess(context, state.message);
          } else if (state is ProductsFailure) {
            AppSnackbar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PageHeader(
                  onRefresh: () => context.read<ProductsBloc>().add(
                        const FetchProducts(AppConstants.statusPending),
                      ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: _buildContent(context, state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProductsState state) {
    if (state is ProductsLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    }

    if (state is ProductsLoaded) {
      return _ProductsCard(
        products: state.products,
      );
    }

    if (state is ProductsActionLoading) {
      return _ProductsCard(
        products: state.products,
        actionLoadingProductId: state.productId,
      );
    }

    if (state is ProductsActionSuccess) {
      return _ProductsCard(products: state.products);
    }

    if (state is ProductsFailure) {
      if (state.products != null) {
        return _ProductsCard(products: state.products!);
      }
      return _ErrorWidget(
        message: state.message,
        onRetry: () => context.read<ProductsBloc>().add(
              const FetchProducts(AppConstants.statusPending),
            ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _PageHeader extends StatelessWidget {
  final VoidCallback onRefresh;

  const _PageHeader({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pending Products',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Review and approve or reject pending product submissions',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const Spacer(),
        OutlinedButton(
          onPressed: onRefresh,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primaryColor,
            side: const BorderSide(color: AppTheme.primaryColor),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Refresh',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _ProductsCard extends StatelessWidget {
  final List products;
  final String? actionLoadingProductId;

  const _ProductsCard({
    required this.products,
    this.actionLoadingProductId,
  });

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
          // Card header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Text(
                  'Products',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${products.length}',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Table
          Expanded(
            child: SingleChildScrollView(
              child: ProductsTable(
                products: products.cast(),
                actionLoadingProductId: actionLoadingProductId,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Failed to load products',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.dangerColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
