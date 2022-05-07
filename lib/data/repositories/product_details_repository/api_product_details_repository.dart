import '../../../models/product_details/product_details.dart';
import '../../api/products_api.dart';

class ApiProductDetailsRepository {
  final ProductsApi _productsApi;

  const ApiProductDetailsRepository(this._productsApi);

  Future<ProductDetails> get(String code) {
    return _productsApi.fetchProductDetails(code);
  }
}
