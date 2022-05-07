import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../constants/network/keys.dart';
import '../price/price.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product extends Equatable {
  @HiveField(0)
  final String code;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final Price price;

  const Product({
    required this.code,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      code: json[Keys.productDefaultArticle][Keys.productCode],
      name: json[Keys.productDefaultArticle][Keys.productName],
      imageUrl: json[Keys.productDefaultArticle][Keys.productImages][0]
          [Keys.productUrl],
      price: Price.fromJson(json[Keys.productPrice]),
    );
  }

  Product copyWith({
    String? code,
    String? name,
    String? imageUrl,
    Price? price,
  }) {
    return Product(
      code: code ?? this.code,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
    );
  }

  @override
  List<Object> get props => [code, name, imageUrl, price];
}
