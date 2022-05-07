import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../constants/network/keys.dart';

part 'product_details.g.dart';

@HiveType(typeId: 2)
class ProductDetails extends Equatable {
  @HiveField(0)
  final String code;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final List<String> measurements;
  @HiveField(3)
  final List<String> fits;

  const ProductDetails({
    required this.code,
    required this.description,
    required this.measurements,
    required this.fits,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      code: json[Keys.productDetailsCode],
      description: json[Keys.productDetailsDescription],
      measurements: List<String>.from(
        json[Keys.productDetailsMeasurements] ?? [],
      ),
      fits: List<String>.from(json[Keys.productDetailsFits] ?? []),
    );
  }

  @override
  List<Object> get props => [code, description, measurements, fits];
}
