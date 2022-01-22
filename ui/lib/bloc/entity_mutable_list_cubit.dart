import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:business/business.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'entity_mutable_list_state.dart';

class EntityMutableListCubit<T extends Entity> extends Cubit<EntityMutableListState<T>> {
  final NoParamStreamUseCase<List<T>> _watchAllUseCase;
  final FutureUseCase<void, String> _deleteUseCase;
  final ValueSetter<T> _openItemCallback;
  final ValueSetter<T> _editItemCallBack;

  late final StreamSubscription<FailureOr<List<T>>> _streamSubscription;

  EntityMutableListCubit({
    required NoParamStreamUseCase<List<T>> watchAllUseCase,
    required FutureUseCase<void, String> deleteUseCase,
    required ValueSetter<T> openItemCallback,
    required ValueSetter<T> editItemCallback,
  })  : _watchAllUseCase = watchAllUseCase,
        _openItemCallback = openItemCallback,
        _editItemCallBack = editItemCallback,
        _deleteUseCase = deleteUseCase,
        super(EntityMutableListState<T>.initial()) {
    _startWatching();
  }

  void _startWatching() {
    emit(state.copyWith(items: AsyncData.loading()));

    _streamSubscription = _watchAllUseCase().listen((result) {
      result.fold(
        (error) => emit(state.copyWith(items: AsyncData.withError(error))),
        (items) => emit(state.copyWith(items: AsyncData.withData(items))),
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

  void onDeletePressed() async {
    emit(state.copyWith(deletionState: DeletionInProgress()));

    final errors = <IdWithFailure>[];
    var selectedItems = state.selectedItems;

    await Future.forEach<String>(state.selectedItems, (id) async {
      final result = await _deleteUseCase(id);
      result.fold(
        (error) => errors.add(IdWithFailure(id, error)),
        (r) => selectedItems = selectedItems.rebuild((p0) => p0.remove(id)),
      );
    });

    final deletionState = errors.isEmpty ? DeletionNone() : DeletionWithError(errors);

    emit(state.copyWith(deletionState: deletionState, selectedItems: selectedItems));
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
