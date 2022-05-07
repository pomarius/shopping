import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/products_repository.dart';
import '../../models/products/products.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository _repository;

  ProductsBloc(this._repository) : super(ProductsInitial()) {
    on<ProductsFetch>(_onProductsFetch, transformer: sequential());
  }

  Future<void> _onProductsFetch(
    ProductsFetch event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final Products products = await _repository.get(event.isFirstFetch);
      products.currentPage >= products.numberOfPages
          ? emit(ProductsEndReached())
          : emit(ProductsLoaded(products: products));
    } catch (exception) {
      emit(ProductsFailure(message: exception.toString()));
    }
  }
}
