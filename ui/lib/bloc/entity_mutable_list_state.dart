part of 'entity_mutable_list_cubit.dart';

class EntityMutableListState<T> extends Equatable {
  final AsyncData<List<T>> items;
  final BuiltSet<String> selectedItems;
  final DeletionState deletionState;

  bool get isSelecting => selectedItems.isNotEmpty;

  EntityMutableListState({
    required this.selectedItems,
    required this.items,
    required this.deletionState,
  });

  EntityMutableListState.initial()
      : items = AsyncData.nothing(),
        deletionState = DeletionNone(),
        selectedItems = BuiltSet();

  EntityMutableListState<T> copyWith({
    AsyncData<List<T>>? items,
    BuiltSet<String>? selectedItems,
    DeletionState? deletionState,
  }) {
    return EntityMutableListState<T>(
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
