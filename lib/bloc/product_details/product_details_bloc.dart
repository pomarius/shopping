import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/product_details_repository.dart';
import '../../models/product_details/product_details.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final ProductDetailsRepository _repository;

  ProductDetailsBloc(this._repository) : super(ProductDetailsInitial()) {
    on<ProductDetailsFetch>(
      _onProductDetailsFetch,
      transformer: restartable(),
    );
  }

  Future<void> _onProductDetailsFetch(
    ProductDetailsFetch event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(ProductDetailsLoading());
    try {
      final ProductDetails details = await _repository.get(event.code);
      emit(ProductDetailsLoaded(productDetails: details));
    } catch (exception) {
      emit(ProductDetailsFailure(message: exception.toString()));
    }
  }
}
