import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ui/bloc/entity_mutable_list_cubit.dart';
import 'package:uuid/uuid.dart';

import '_mock.mocks.dart';

void main() {
  final fix = FixtureCategory();
  final uid = Uuid();
  late EntityMutableListCubit<Category> cubit;
  late NoParamStreamUseCase<List<Category>> watchAllUseCase;
  late FutureUseCase<void, String> deleteUseCase;

  setUp(() {
    watchAllUseCase = MockWatchCategoriesUseCase();
    deleteUseCase = MockDeleteCategoryUseCase();
  });

  group('deletion', () {
    final category1 = fix.category1;
    final category2 = fix.category2;
    final category3 = fix.category3;
    final initialSelected = BuiltSet<String>({category1.id, category2.id, category3.id});
    final categoryList = AsyncData.withData(
      <Category>[category1, category2, category3],
    );

    setUp(() {
      when(watchAllUseCase()).thenAnswer((_) {
        return Stream.fromIterable([
          Right([category1, category2, category3]),
        ]);
      });
      when(deleteUseCase(category1.id)).thenAnswer((_) async => Right(Null));
      when(deleteUseCase(category2.id)).thenAnswer((_) async => Right(Null));
      when(deleteUseCase(category3.id)).thenAnswer((_) async => Right(Null));
      cubit = EntityMutableListCubit(
        watchAllUseCase: watchAllUseCase,
        deleteUseCase: deleteUseCase,
        openItemCallback: (item) {},
        editItemCallback: (item) {},
      );
    });

    blocTest<EntityMutableListCubit<Category>, EntityMutableListState<Category>>(
      'when there are no erros on deletion, '
      'must emit a none deletion state and clear the selected items',
      build: () => cubit,
      skip: 0,
      setUp: () {
        cubit.emit(cubit.state.copyWith(
          selectedItems: initialSelected,
        ));
      },
      act: (cubit) => cubit.onDeletePressed(),
      expect: () => [
        EntityMutableListState<Category>(
          selectedItems: initialSelected,
          items: categoryList,
          deletionState: DeletionInProgress(),
        ),
        EntityMutableListState<Category>(
          selectedItems: BuiltSet(),
          items: categoryList,
          deletionState: DeletionNone(),
        ),
      ],
    );
  });
}
