part of 'entity_list_cubit.dart';

class EntityListState<T> extends Equatable {
  final AsyncSnapshot<List<T>> items;
  final BuiltSet<String> selectedItems;

  bool get isSelecting => selectedItems.isNotEmpty;

  EntityListState({
    required this.selectedItems,
    required this.items,
  });

  EntityListState.initial()
      : items = AsyncSnapshot.nothing(),
        selectedItems = BuiltSet();

  EntityListState<T> copyWith({
    AsyncSnapshot<List<T>>? items,
    BuiltSet<String>? selectedItems,
  }) {
    return EntityListState<T>(
      selectedItems: selectedItems ?? this.selectedItems,
      items: items ?? this.items,
    );
  }

  @override
  List<Object> get props => [items, selectedItems];
}
