import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:business/business.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'entity_list_state.dart';

class EntityListCubit<T extends Entity> extends Cubit<EntityListState<T>> {
  final NoParamStreamUseCase<List<T>> _watchAllUseCase;
  final ValueSetter<T> _openItemCallback;
  final ValueSetter<T> _editItemCallBack;

  EntityListCubit({
    required NoParamStreamUseCase<List<T>> watchAllUseCase,
    required ValueSetter<T> openItemCallback,
    required ValueSetter<T> editItemCallback,
  })  : _watchAllUseCase = watchAllUseCase,
        _openItemCallback = openItemCallback,
        _editItemCallBack = editItemCallback,
        super(EntityListState<T>.initial()) {
    _startWatching();
  }

  void _startWatching() {
    emit(state.copyWith(items: AsyncSnapshot.waiting()));

    _watchAllUseCase().listen((result) {
      result.fold(
        (error) =>
            emit(state.copyWith(items: AsyncSnapshot.withError(ConnectionState.done, error))),
        (items) => emit(state.copyWith(items: AsyncSnapshot.withData(ConnectionState.done, items))),
      );
    });
  }

  void onPressed(T item) {
    if (state.isSelecting) {
      _toggleItem(item);
    } else {
      _openItemCallback(item);
    }
  }

  void onClearSelection() {
    emit(state.copyWith(selectedItems: BuiltSet()));
  }

  void onLongPressed(T item) {
    _toggleItem(item);
  }

  void _toggleItem(T item) {
    final newSelected = state.selectedItems.contains(item.id)
        ? state.selectedItems.rebuild((p0) => p0.remove(item.id))
        : state.selectedItems.rebuild((p0) => p0.add(item.id));

    emit(state.copyWith(selectedItems: newSelected));
  }

  void onEditPressed() {
    final item = state.items.data!.singleWhere(
      (element) => element.id == state.selectedItems.single,
    );
    _editItemCallBack(item);
  }
}
