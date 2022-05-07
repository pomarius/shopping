part of 'products_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class ProductsFetch extends ProductsEvent {
  final bool isFirstFetch;

  const ProductsFetch({this.isFirstFetch = false});

  @override
  List<Object> get props => [isFirstFetch];
}
