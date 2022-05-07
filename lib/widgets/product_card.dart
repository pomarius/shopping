import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/style/app_colors.dart';
import '../constants/style/dimens.dart';
import '../models/product/product.dart';
import '../routes/routes.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.cardRadius),
          child: Column(
            children: [
              _buildPhoto(context),
              _buildDetails(context),
            ],
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.cardRadius),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _onTap(context, product),
            ),
          ),
        ),
        IgnorePointer(
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
        ),
      ],
    );
  }

  Widget _buildPhoto(BuildContext context) {
    return Expanded(
      child: CachedNetworkImage(
        imageUrl: product.imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          return const Icon(
            Icons.broken_image_outlined,
            color: AppColors.borderColor,
            size: 48,
          );
        },
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.baselineGrid),
      child: Row(
        children: [
          Expanded(
            child: Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: Dimens.baselineGrid),
          Text(
            product.price.formattedValue,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, Product product) {
    Navigator.pushNamed(context, Routes.details, arguments: product);
  }
}
