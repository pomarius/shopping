import '../../models/products/products.dart';
import 'products_repository/api_products_repository.dart';
import 'products_repository/hive_products_repository.dart';

class ProductsRepository {
  final ApiProductsRepository _network;
  final HiveProductsRepository _local;

  const ProductsRepository(this._network, this._local);

  Future<Products> get([bool isFirstFetch = false]) async {
    final Products? localProducts = await _local.get();

    if (localProducts != null) {
      if (isFirstFetch) {
        return localProducts;
      }

      final Products networkProducts = await _network.get(
        localProducts.currentPage + 1,
      );

      final Products products = networkProducts.copyWith(
        products: [...localProducts.products, ...networkProducts.products],
      );

      await _local.save(products);
      return products;
    }

    final Products networkProducts = await _network.get(0);

    await _local.save(networkProducts);
    return networkProducts;
  }
}
