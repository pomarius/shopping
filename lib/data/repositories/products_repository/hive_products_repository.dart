import 'package:hive/hive.dart';

import '../../../constants/network/keys.dart';
import '../../../models/products/products.dart';

class HiveProductsRepository {
  final Box _box;
  final Duration stalePeriod;

  const HiveProductsRepository(
    this._box, [
    this.stalePeriod = const Duration(days: 1),
  ]);

  Future<Products?> get() async {
    final DateTime now = DateTime.now().toUtc();
    final DateTime today = DateTime.utc(now.year, now.month, now.day);
    final DateTime? date = _box.get(Keys.hiveDate);

    if (date != null && today.subtract(stalePeriod).compareTo(date) == -1) {
      final Products products = _box.get(Keys.hiveProducts);

      return products;
    }

    await _box.delete(Keys.hiveDate);
    await _box.delete(Keys.hiveProducts);
    return null;
  }

  Future<void> save(Products products) async {
    if (_box.get(Keys.hiveDate) == null) {
      final DateTime now = DateTime.now().toUtc();
      final DateTime today = DateTime.utc(now.year, now.month, now.day);
      _box.put(Keys.hiveDate, today);
    }

    _box.put(Keys.hiveProducts, products);
  }
}
