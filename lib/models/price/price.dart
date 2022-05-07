import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../constants/network/keys.dart';

part 'price.g.dart';

@HiveType(typeId: 3)
class Price extends Equatable {
  @HiveField(0)
  final String currencyIso;
  @HiveField(1)
  final double value;
  @HiveField(2)
  final String formattedValue;

  const Price({
    required this.currencyIso,
    required this.value,
    required this.formattedValue,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      currencyIso: json[Keys.priceCurrencyIso],
      value: json[Keys.priceValue],
      formattedValue: json[Keys.priceFormattedValue],
    );
  }

  @override
  List<Object> get props => [currencyIso, value, formattedValue];
}
