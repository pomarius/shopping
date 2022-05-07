import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/product_details/product_details_bloc.dart';
import '../bloc/products/products_bloc.dart';
import '../data/repositories/product_details_repository.dart';
import '../data/repositories/products_repository.dart';
import '../models/product/product.dart';
import '../screens/product_details_screen.dart';
import '../screens/products_screen.dart';
import 'routes.dart';

class AppRouter {
  final BuildContext context;
  const AppRouter(this.context);
  PageRoute? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.products:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ProductsBloc(
              GetIt.instance.get<ProductsRepository>(),
            )..add(const ProductsFetch(isFirstFetch: true)),
            child: const ProductsScreen(),
          ),
        );
      case Routes.details:
        final product = routeSettings.arguments as Product;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ProductDetailsBloc(
              GetIt.instance.get<ProductDetailsRepository>(),
            ),
            child: ProductDetailsScreen(product: product),
          ),
        );
      default:
        return null;
    }
  }
}
