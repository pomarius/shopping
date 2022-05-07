part of 'product_details_bloc.dart';

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object> get props => [];
}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductDetails productDetails;

  const ProductDetailsLoaded({required this.productDetails});

  @override
  List<Object> get props => [productDetails];
}

class ProductDetailsFailure extends ProductDetailsState {
  final String message;

  const ProductDetailsFailure({required this.message});

  @override
  List<Object> get props => [message];
}
