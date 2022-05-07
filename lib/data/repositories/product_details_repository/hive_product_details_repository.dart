import 'package:hive/hive.dart';

import '../../../constants/network/keys.dart';
import '../../../models/product_details/product_details.dart';

class HiveProductDetailsRepository {
  final Box _box;
  final Duration stalePeriod;

  const HiveProductDetailsRepository(
    this._box, [
    this.stalePeriod = const Duration(days: 7),
  ]);

  Future<ProductDetails?> get(String code) async {
    dynamic details = _box.get(code);

    if (details == null) {
      return null;
    }

    final DateTime now = DateTime.now().toUtc();
    final DateTime today = DateTime.utc(now.year, now.month, now.day);

    if (today.subtract(stalePeriod).compareTo(details[Keys.hiveDate]) == -1) {
      final ProductDetails productDetails = details[Keys.hiveProductDetails];

      return productDetails;
    }

    await _box.delete(code);
    return null;
  }

  Future<void> save(ProductDetails productDetails) async {
    final DateTime now = DateTime.now().toUtc();
    final DateTime today = DateTime.utc(now.year, now.month, now.day);

    final Map<String, dynamic> details = {
      Keys.hiveDate: today,
      Keys.hiveProductDetails: productDetails,
    };

    _box.put(productDetails.code, details);
  }
}
