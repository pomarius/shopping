import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/products/products_bloc.dart';
import '../constants/style/dimens.dart';
import '../widgets/product_card.dart';
import '../widgets/something_went_wrong.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late final ProductsBloc _productsBloc;
  final ScrollController _scrollController = ScrollController();
  bool _loading = true;

  @override
  void initState() {
    _productsBloc = BlocProvider.of<ProductsBloc>(context);
    _scrollController.addListener(_fetch);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_fetch);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(),
          _buildProducts(),
          _buildLoadingIndicator(),
          _buildFailureMessage(),
          _buildTheEndMessage(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return const SliverAppBar(
      pinned: true,
      title: Text('Products'),
    );
  }

  Widget _buildProducts() {
    return BlocConsumer<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is ProductsLoaded) {
          _loading = false;
        }
      },
      buildWhen: (previous, current) {
        return current is ProductsLoaded;
      },
      builder: (context, state) {
        if (state is ProductsLoaded) {
          return SliverPadding(
            padding: const EdgeInsets.all(Dimens.baselineGrid),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: Dimens.baselineGrid,
                crossAxisSpacing: Dimens.baselineGrid,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => ProductCard(
                  product: state.products.products[index],
                ),
                childCount: state.products.products.length,
              ),
            ),
          );
        }

        return const SliverToBoxAdapter();
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading || state is ProductsInitial) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(Dimens.baselineGrid * 2),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        return const SliverToBoxAdapter();
      },
    );
  }

  Widget _buildFailureMessage() {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        if (state is ProductsFailure) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Dimens.baselineGrid,
              ),
              child: SomethingWentWrong(
                message: state.message,
                onPressed: () => _productsBloc.add(const ProductsFetch()),
              ),
            ),
          );
        }

        return const SliverToBoxAdapter();
      },
    );
  }

  Widget _buildTheEndMessage() {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        if (state is ProductsEndReached) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Dimens.baselineGrid,
              ),
              child: Center(
                child: Text(
                  'The end :(',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        return const SliverToBoxAdapter();
      },
    );
  }

  void _fetch() {
    final double current = _scrollController.position.pixels;
    final double max = _scrollController.position.maxScrollExtent;
    final double offset = _scrollController.position.viewportDimension;

    if (current + offset >= max && !_loading) {
      _loading = true;
      _productsBloc.add(const ProductsFetch());
    }
  }
}
