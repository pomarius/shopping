import '../../constants/network/endpoints.dart';
import '../../constants/network/keys.dart';
import '../../models/product_details/product_details.dart';
import '../../models/products/products.dart';
import '../api_client.dart';

class ProductsApi {
  final ApiClient apiClient;

  ProductsApi(this.apiClient);

  Future<Products> fetchProducts(int page) async {
    Map<String, String> headers = {
      Keys.productsApiRapidApiHost: Endpoints.host,
      Keys.productsApiRapidApiKey: Endpoints.key,
    };

    Map<String, dynamic> params = {
      Keys.productsApiCountry: 'eur',
      Keys.productsApiLang: 'en',
      Keys.productsApiCurrentPage: page.toString(),
      Keys.productsApiPageSize: '30',
    };

    final dynamic response = await apiClient.get(
      Endpoints.productsList,
      headers: headers,
      params: params,
    );

    return Products.fromJson(response);
  }

  Future<ProductDetails> fetchProductDetails(String code) async {
    Map<String, String> headers = {
      Keys.productsApiRapidApiHost: Endpoints.host,
      Keys.productsApiRapidApiKey: Endpoints.key,
    };

    Map<String, dynamic> params = {
      Keys.productsApiCountry: 'eur',
      Keys.productsApiLang: 'en',
      Keys.productsApiProductcode: code,
    };

    final dynamic response = await apiClient.get(
      Endpoints.productDetail,
      headers: headers,
      params: params,
    );

    return ProductDetails.fromJson(response[Keys.productsApiProduct]);
  }
}
