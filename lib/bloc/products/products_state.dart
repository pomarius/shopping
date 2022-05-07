part of 'products_bloc.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final Products products;

  const ProductsLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

class ProductsFailure extends ProductsState {
  final String message;

  const ProductsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProductsEndReached extends ProductsState {}
