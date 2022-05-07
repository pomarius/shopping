import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../constants/network/keys.dart';
import '../product/product.dart';

part 'products.g.dart';

@HiveType(typeId: 0)
class Products extends Equatable {
  @HiveField(0)
  final List<Product> products;
  @HiveField(1)
  final int currentPage;
  @HiveField(2)
  final int numberOfPages;

  const Products({
    required this.products,
    required this.currentPage,
    required this.numberOfPages,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      products: List<Product>.from(
        json[Keys.productsResults]
            .map((product) => Product.fromJson(product))
            .toList(),
      ),
      currentPage: json[Keys.productsPagination][Keys.productsCurrentPage],
      numberOfPages: json[Keys.productsPagination][Keys.productsNumberOfPages],
    );
  }

  Products copyWith({
    List<Product>? products,
    int? currentPage,
    int? numberOfPages,
  }) {
    return Products(
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      numberOfPages: numberOfPages ?? this.numberOfPages,
    );
  }

  @override
  List<Object> get props => [products, currentPage, numberOfPages];
}
