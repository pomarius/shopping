import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopping/bloc/products/products_bloc.dart';
import 'package:shopping/data/repositories/products_repository.dart';
import 'package:shopping/data/repositories/products_repository/api_products_repository.dart';
import 'package:shopping/data/repositories/products_repository/hive_products_repository.dart';
import 'package:shopping/models/price/price.dart';
import 'package:shopping/models/product/product.dart';
import 'package:shopping/models/products/products.dart';

class MockApiProductsRepository extends Mock implements ApiProductsRepository {}

class MockHiveProductsRepository extends Mock
    implements HiveProductsRepository {}

class FakeProducts extends Fake implements Products {}

void main() {
  const Products products = Products(
    products: [
      Product(
        code: 'code',
        name: 'name',
        imageUrl: 'imageUrl',
        price: Price(
          currencyIso: 'currencyIso',
          value: 0,
          formattedValue: 'formattedValue',
        ),
      ),
    ],
    currentPage: 0,
    numberOfPages: 1,
  );

  final Products cacheProducts = products.copyWith(
    products: [products.products[0].copyWith(code: 'cache')],
  );

  final Products apiProducts = products.copyWith(
    products: [products.products[0].copyWith(code: 'api')],
  );

  late final MockApiProductsRepository apiRepo;
  late final MockHiveProductsRepository localRepo;
  late final ProductsRepository repository;
  late final ProductsBloc productsBloc;

  setUpAll(() {
    apiRepo = MockApiProductsRepository();
    localRepo = MockHiveProductsRepository();
    repository = ProductsRepository(apiRepo, localRepo);
    productsBloc = ProductsBloc(repository);

    registerFallbackValue(FakeProducts());
  });

  tearDown(() {
    productsBloc.close();
  });

  group('ProductsBloc', () {
    test('bloc should have initial state as [ProductsInitial]', () {
      expect(productsBloc.state.runtimeType, ProductsInitial);
    });

    blocTest<ProductsBloc, ProductsState>(
      'bloc should emit [ProductsLoading, ProductsLoaded] states when no data is cached',
      build: () => ProductsBloc(repository),
      act: (bloc) {
        when(() => localRepo.get()).thenAnswer((_) async => null);
        when(() => localRepo.save(any())).thenAnswer((_) async {});
        when(() => apiRepo.get(any())).thenAnswer((_) async => products);
        bloc.add(const ProductsFetch());
      },
      expect: () => [
        ProductsLoading(),
        const ProductsLoaded(products: products),
      ],
      verify: ((_) {
        verify(() => localRepo.get()).called(1);
        verify(() => localRepo.save(any())).called(1);
        verify(() => apiRepo.get(any())).called(1);
      }),
    );

    blocTest<ProductsBloc, ProductsState>(
      'bloc should emit [ProductsLoading, ProductsLoaded] states on first fetch when data is cached',
      build: () => ProductsBloc(repository),
      act: (bloc) {
        when(() => localRepo.get()).thenAnswer((_) async => products);
        when(() => localRepo.save(any())).thenAnswer((_) async {});
        bloc.add(const ProductsFetch(isFirstFetch: true));
      },
      expect: () => [
        ProductsLoading(),
        const ProductsLoaded(products: products),
      ],
      verify: ((_) {
        verify(() => localRepo.get()).called(1);
        verifyNever(() => localRepo.save(any()));
        verifyNever(() => apiRepo.get(any()));
      }),
    );

    blocTest<ProductsBloc, ProductsState>(
      'bloc should emit [ProductsLoading, ProductsLoaded] states when data is cached',
      build: () => ProductsBloc(repository),
      act: (bloc) {
        when(() => localRepo.get()).thenAnswer((_) async => cacheProducts);
        when(() => localRepo.save(any())).thenAnswer((_) async {});
        when(() => apiRepo.get(any())).thenAnswer((_) async => apiProducts);
        bloc.add(const ProductsFetch());
      },
      expect: () => [
        ProductsLoading(),
        ProductsLoaded(
          products: products.copyWith(
            products: [...cacheProducts.products, ...apiProducts.products],
          ),
        ),
      ],
      verify: ((_) {
        verify(() => localRepo.get()).called(1);
        verify(() => localRepo.save(any())).called(1);
        verify(() => apiRepo.get(any())).called(1);
      }),
    );

    blocTest<ProductsBloc, ProductsState>(
      'bloc should emit [ProductsLoading, ProductsFailure] states when fetching has failed',
      build: () => ProductsBloc(repository),
      act: (bloc) {
        when(() => localRepo.get()).thenAnswer((_) async => products);
        when(() => localRepo.save(any())).thenAnswer((_) async {});
        when(() => apiRepo.get(any())).thenThrow('test');
        bloc.add(const ProductsFetch());
      },
      expect: () => [
        ProductsLoading(),
        const ProductsFailure(message: 'test'),
      ],
      verify: ((_) {
        verify(() => localRepo.get()).called(1);
        verifyNever(() => localRepo.save(any()));
        verify(() => apiRepo.get(any())).called(1);
      }),
    );

    blocTest<ProductsBloc, ProductsState>(
      'bloc should emit [ProductsLoading, ProductsEndReached] states when reached the last page',
      build: () => ProductsBloc(repository),
      act: (bloc) {
        when(() => localRepo.get()).thenAnswer((_) async => products);
        when(() => localRepo.save(any())).thenAnswer((_) async {});
        when(() => apiRepo.get(any())).thenAnswer(
          (_) async => products.copyWith(currentPage: 1),
        );
        bloc.add(const ProductsFetch());
      },
      expect: () => [
        ProductsLoading(),
        ProductsEndReached(),
      ],
      verify: ((_) {
        verify(() => localRepo.get()).called(1);
        verify(() => localRepo.save(any())).called(1);
        verify(() => apiRepo.get(any())).called(1);
      }),
    );
  });
}
