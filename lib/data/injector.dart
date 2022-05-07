import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../constants/network/endpoints.dart';
import 'api/products_api.dart';
import 'api_client.dart';
import 'repositories/product_details_repository/api_product_details_repository.dart';
import 'repositories/product_details_repository/hive_product_details_repository.dart';
import 'repositories/product_details_repository.dart';
import 'repositories/products_repository/api_products_repository.dart';
import 'repositories/products_repository/hive_products_repository.dart';
import 'repositories/products_repository.dart';

class Injector {
  static GetIt getIt = GetIt.instance;

  static Future<void> setupInjector() async {
    _setupApiClient();
    _setupApis();
    await _setupRepos();
  }

  static void _setupApiClient() {
    final ApiClient apiClient = ApiClient(Endpoints.host);
    getIt.registerSingleton(apiClient);
  }

  static void _setupApis() {
    getIt.registerSingleton(ProductsApi(getIt<ApiClient>()));
  }

  static Future<void> _setupRepos() async {
    getIt.registerSingleton<ProductsRepository>(ProductsRepository(
      ApiProductsRepository(getIt<ProductsApi>()),
      HiveProductsRepository(await Hive.openBox('products')),
    ));

    getIt.registerSingleton<ProductDetailsRepository>(ProductDetailsRepository(
      ApiProductDetailsRepository(getIt<ProductsApi>()),
      HiveProductDetailsRepository(await Hive.openBox('productDetails')),
    ));
  }
}
