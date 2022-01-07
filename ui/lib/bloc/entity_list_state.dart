part of 'entity_list_cubit.dart';

class EntityListState<T> extends Equatable {
  final AsyncData<List<T>> items;
  final BuiltSet<String> selectedItems;
  final DeletionState deletionState;

  bool get isSelecting => selectedItems.isNotEmpty;

  EntityListState({
    required this.selectedItems,
    required this.items,
    required this.deletionState,
  });

  EntityListState.initial()
      : items = AsyncData.nothing(),
        deletionState = DeletionNone(),
        selectedItems = BuiltSet();

  EntityListState<T> copyWith({
    AsyncData<List<T>>? items,
    BuiltSet<String>? selectedItems,
    DeletionState? deletionState,
  }) {
    return EntityListState<T>(
      selectedItems: selectedItems ?? this.selectedItems,
      items: items ?? this.items,
      deletionState: deletionState ?? this.deletionState,
    );
  }

  @override
  List<Object> get props => [items, selectedItems, deletionState];
}

abstract class DeletionState extends Equatable {}

class DeletionNone extends DeletionState {
  @override
  List<Object> get props => [];
}

class DeletionInProgress extends DeletionState {
  @override
  List<Object> get props => [];
}

class DeletionWithError extends DeletionState {
  final List<IdWithFailure> idsAndError;

  DeletionWithError(this.idsAndError);

  @override
  List<Object> get props => [idsAndError];
}
