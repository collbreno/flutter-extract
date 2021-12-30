part of 'entity_list_cubit.dart';

abstract class EntityListState<T> extends Equatable {}

class EntityListInitial<T> extends EntityListState<T> {
  @override
  List<Object> get props => [];
}

class EntityListLoading<T> extends EntityListState<T> {
  @override
  List<Object?> get props => [];
}

class EntityListError<T> extends EntityListState<T> {
  final Failure error;

  EntityListError(this.error);

  @override
  List<Object> get props => [error];
}

class EntityListFinished<T> extends EntityListState<T> {
  final List<T> items;

  EntityListFinished(this.items);

  @override
  List<Object> get props => [items];
}
