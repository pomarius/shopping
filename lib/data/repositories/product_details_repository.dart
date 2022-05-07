import '../../models/product_details/product_details.dart';
import 'product_details_repository/api_product_details_repository.dart';
import 'product_details_repository/hive_product_details_repository.dart';

class ProductDetailsRepository {
  final ApiProductDetailsRepository _network;
  final HiveProductDetailsRepository _local;

  const ProductDetailsRepository(this._network, this._local);

  Future<ProductDetails> get(String code) async {
    final ProductDetails? localProduct = await _local.get(code);

    if (localProduct != null) {
      return localProduct;
    }

    final ProductDetails networkProduct = await _network.get(code);

    await _local.save(networkProduct);
    return networkProduct;
  }
}
