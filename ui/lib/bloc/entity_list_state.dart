part of 'entity_list_cubit.dart';

class EntityListState<T> extends Equatable {
  final AsyncData<List<T>> items;

  EntityListState({required this.items});

  EntityListState.initial() : items = AsyncData.nothing();

  EntityListState<T> copyWith({
    AsyncData<List<T>>? items,
  }) {
    return EntityListState(
      items: items ?? this.items,
    );
  }

  @override
  List<Object> get props => [items];
}
