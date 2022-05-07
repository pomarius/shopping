import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'constants/style/app_theme.dart';
import 'data/injector.dart';
import 'models/price/price.dart';
import 'models/product/product.dart';
import 'models/product_details/product_details.dart';
import 'models/products/products.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.init((await getTemporaryDirectory()).path);
  Hive.registerAdapter(ProductsAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ProductDetailsAdapter());
  Hive.registerAdapter(PriceAdapter());

  await Injector.setupInjector();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping',
      theme: AppTheme.lightTheme(),
      onGenerateRoute: AppRouter(context).onGenerateRoute,
    );
  }
}
