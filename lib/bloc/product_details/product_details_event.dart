part of 'product_details_bloc.dart';

abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object> get props => [];
}

class ProductDetailsFetch extends ProductDetailsEvent {
  final String code;

  const ProductDetailsFetch({required this.code});

  @override
  List<Object> get props => [code];
}
