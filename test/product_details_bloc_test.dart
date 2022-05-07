import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopping/bloc/product_details/product_details_bloc.dart';
import 'package:shopping/data/repositories/product_details_repository.dart';
import 'package:shopping/data/repositories/product_details_repository/api_product_details_repository.dart';
import 'package:shopping/data/repositories/product_details_repository/hive_product_details_repository.dart';
import 'package:shopping/models/product_details/product_details.dart';

class MockApiProductDetailsRepository extends Mock
    implements ApiProductDetailsRepository {}

class MockHiveProductDetailsRepository extends Mock
    implements HiveProductDetailsRepository {}

class FakeProductDetails extends Fake implements ProductDetails {}

void main() {
  const ProductDetails productDetails = ProductDetails(
    code: 'code',
    description: 'description',
    fits: [],
    measurements: [],
  );

  late final MockApiProductDetailsRepository apiRepo;
  late final MockHiveProductDetailsRepository localRepo;
  late final ProductDetailsRepository repository;
  late final ProductDetailsBloc productDetailsBloc;

  setUpAll(() {
    apiRepo = MockApiProductDetailsRepository();
    localRepo = MockHiveProductDetailsRepository();
    repository = ProductDetailsRepository(apiRepo, localRepo);
    productDetailsBloc = ProductDetailsBloc(repository);

    registerFallbackValue(FakeProductDetails());
  });

  tearDown(() {
    productDetailsBloc.close();
  });

  group('ProductDetailsBloc', () {
    test('bloc should have initial state as [ProductDetailsInitial]', () {
      expect(productDetailsBloc.state.runtimeType, ProductDetailsInitial);
    });

    blocTest<ProductDetailsBloc, ProductDetailsState>(
      'bloc should emit [ProductDetailsLoading, ProductDetailsLoaded] states when no data is cached',
      build: () => ProductDetailsBloc(repository),
      act: (bloc) {
        when(() => localRepo.get(any())).thenAnswer((_) async => null);
        when(() => localRepo.save(any())).thenAnswer((_) async {});
        when(() => apiRepo.get(any())).thenAnswer((_) async => productDetails);
        bloc.add(const ProductDetailsFetch(code: 'code'));
      },
      expect: () => [
        ProductDetailsLoading(),
        const ProductDetailsLoaded(productDetails: productDetails),
      ],
      verify: ((_) {
        verify(() => localRepo.get(any())).called(1);
        verify(() => localRepo.save(any())).called(1);
        verify(() => apiRepo.get(any())).called(1);
      }),
    );

    blocTest<ProductDetailsBloc, ProductDetailsState>(
      'bloc should emit [ProductDetailsLoading, ProductDetailsLoaded] states when data is cached',
      build: () => ProductDetailsBloc(repository),
      act: (bloc) {
        when(() => localRepo.get(any())).thenAnswer(
          (_) async => productDetails,
        );
        when(() => localRepo.save(any())).thenAnswer((_) async {});
        bloc.add(const ProductDetailsFetch(code: 'code'));
      },
      expect: () => [
        ProductDetailsLoading(),
        const ProductDetailsLoaded(productDetails: productDetails),
      ],
      verify: ((_) {
        verify(() => localRepo.get(any())).called(1);
        verifyNever(() => localRepo.save(any()));
        verifyNever(() => apiRepo.get(any()));
      }),
    );

    blocTest<ProductDetailsBloc, ProductDetailsState>(
      'bloc should emit [ProductDetailsLoading, ProductDetailsFailure] states when fetching has failed',
      build: () => ProductDetailsBloc(repository),
      act: (bloc) {
        when(() => localRepo.get(any())).thenAnswer((_) async => null);
        when(() => localRepo.save(any())).thenAnswer((_) async {});
        when(() => apiRepo.get(any())).thenThrow('test');
        bloc.add(const ProductDetailsFetch(code: 'code'));
      },
      expect: () => [
        ProductDetailsLoading(),
        const ProductDetailsFailure(message: 'test'),
      ],
      verify: ((_) {
        verify(() => localRepo.get(any())).called(1);
        verifyNever(() => localRepo.save(any()));
        verify(() => apiRepo.get(any())).called(1);
      }),
    );
  });
}
