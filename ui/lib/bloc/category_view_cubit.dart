import 'package:bloc/bloc.dart';
import 'package:business/business.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'category_view_state.dart';

class CategoryViewCubit extends Cubit<CategoryViewState> {
  final FutureUseCase<Category, String> _getCategoryById;

  CategoryViewCubit({
    required FutureUseCase<Category, String> getCategoryById,
    required String categoryId,
  })  : _getCategoryById = getCategoryById,
        super(CategoryViewState(categoryId)) {
    loadCategory();
  }

  void loadCategory() async {
    emit(state.copyWith(category: AsyncSnapshot.waiting()));

    final result = await _getCategoryById(state.id);

    result.fold(
      (error) =>
          emit(state.copyWith(category: AsyncSnapshot.withError(ConnectionState.done, error))),
      (category) =>
          emit(state.copyWith(category: AsyncSnapshot.withData(ConnectionState.done, category))),
    );
  }
}
