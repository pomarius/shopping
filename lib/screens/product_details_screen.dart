import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product_details/product_details_bloc.dart';
import '../constants/style/app_colors.dart';
import '../constants/style/dimens.dart';
import '../models/product/product.dart';
import '../widgets/something_went_wrong.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final ProductDetailsBloc _productsDetailsBloc;

  Product get product => widget.product;

  @override
  void initState() {
    _productsDetailsBloc = BlocProvider.of<ProductDetailsBloc>(context);
    _productsDetailsBloc.add(ProductDetailsFetch(code: product.code));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildPhoto(),
          _buildPrice(),
          _buildDetails(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      title: Text(product.name),
    );
  }

  Widget _buildPhoto() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.baselineGrid),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.cardRadius),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return const AspectRatio(
                    aspectRatio: 1,
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: AppColors.borderColor,
                      size: 48,
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(Dimens.cardRadius),
                  border: Border.all(
                    color: AppColors.borderColor,
                    width: 1.5,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPrice() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.baselineGrid),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            product.price.formattedValue,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) {
        if (state is ProductDetailsLoaded) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.baselineGrid),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._buildDescription(state.productDetails.description),
                  if (state.productDetails.measurements.isNotEmpty)
                    ..._buildMeasurements(state.productDetails.measurements),
                  if (state.productDetails.fits.isNotEmpty)
                    ..._buildFits(state.productDetails.fits),
                ],
              ),
            ),
          );
        } else if (state is ProductDetailsFailure) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: SomethingWentWrong(
              message: state.message,
              onPressed: () => _productsDetailsBloc.add(ProductDetailsFetch(
                code: product.code,
              )),
            ),
          );
        }

        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(Dimens.baselineGrid),
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildDescription(String description) {
    return [
      Text(
        'Description:',
        style: Theme.of(context).textTheme.labelLarge,
      ),
      const SizedBox(height: Dimens.baselineGrid),
      Text(
        description,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ];
  }

  List<Widget> _buildMeasurements(List<String> measurements) {
    return [
      const Divider(height: Dimens.baselineGrid * 2),
      Text(
        'Measurements:',
        style: Theme.of(context).textTheme.labelLarge,
      ),
      const SizedBox(height: Dimens.baselineGrid),
      ...List.generate(
        measurements.length,
        (index) => Text(
          measurements[index],
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    ];
  }

  List<Widget> _buildFits(List<String> fits) {
    return [
      const Divider(height: Dimens.baselineGrid * 2),
      Text(
        'Fits:',
        style: Theme.of(context).textTheme.labelLarge,
      ),
      const SizedBox(height: Dimens.baselineGrid),
      ...List.generate(
        fits.length,
        (index) => Text(
          fits[index],
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    ];
  }
}
