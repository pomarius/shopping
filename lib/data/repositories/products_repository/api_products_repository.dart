import '../../../models/products/products.dart';
import '../../api/products_api.dart';

class ApiProductsRepository {
  final ProductsApi _productsApi;

  const ApiProductsRepository(this._productsApi);

  Future<Products> get(int page) {
    return _productsApi.fetchProducts(page);
  }
}
