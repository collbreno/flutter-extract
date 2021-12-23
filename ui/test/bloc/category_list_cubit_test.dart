import 'package:bloc_test/bloc_test.dart';
import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ui/bloc/category_list_cubit.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureCategory();
  final category1 = fix.category1;
  final category2 = fix.category2;

  late CategoryListCubit cubit;
  late NoParamStreamUseCase<List<Category>> useCase;

  setUp(() {
    useCase = MockWatchCategoriesUseCase();
    cubit = CategoryListCubit(useCase);
  });

  test('initial state', () {
    expect(cubit.state, CategoryListInitial());
  });

  blocTest<CategoryListCubit, CategoryListState>(
    'multiple emitions',
    build: () => cubit,
    setUp: () {
      when(useCase()).thenAnswer((_) {
        return Stream.fromIterable([
          Left(NotFoundFailure()),
          Right([category1]),
          Right([category1, category2]),
        ]);
      });
    },
    act: (bloc) => bloc.loadCategories(),
    expect: () => [
      CategoryListLoading(),
      CategoryListError(NotFoundFailure()),
      CategoryListLoaded([category1]),
      CategoryListLoaded([category1, category2]),
    ],
  );
}
