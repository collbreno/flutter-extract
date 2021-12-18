import 'package:bloc_test/bloc_test.dart';
import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ui/bloc/category_view_cubit.dart';
import 'package:dartz/dartz.dart';

import '_mock.mocks.dart';

void main() {
  final category = FixtureCategory().category1;
  final id = category.id;
  final newCategory = category.rebuild((p0) => p0.name = 'New category');
  late CategoryViewCubit cubit;
  late StreamUseCase<Category, String> useCase;

  setUp(() {
    useCase = MockWatchCategoryUseCase();
    cubit = CategoryViewCubit(
      watchCategoryById: useCase,
      categoryId: id,
    );
  });

  test('initial state', () {
    expect(
      cubit.state,
      CategoryViewState(id: id, category: AsyncSnapshot.nothing()),
    );
  });

  blocTest<CategoryViewCubit, CategoryViewState>(
    'multiple emitions',
    build: () => cubit,
    setUp: () {
      when(useCase(id)).thenAnswer((_) {
        return Stream.fromIterable([
          Right(category),
          Right(newCategory),
          Left(NotFoundFailure()),
        ]);
      });
    },
    act: (bloc) => bloc.loadCategory(),
    expect: () => [
      CategoryViewState(
        id: id,
        category: AsyncSnapshot.waiting(),
      ),
      CategoryViewState(
        id: id,
        category: AsyncSnapshot.withData(ConnectionState.done, category),
      ),
      CategoryViewState(
        id: id,
        category: AsyncSnapshot.withData(ConnectionState.done, newCategory),
      ),
      CategoryViewState(
        id: id,
        category: AsyncSnapshot.withError(ConnectionState.done, NotFoundFailure()),
      ),
    ],
  );
}
