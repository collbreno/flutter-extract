import 'package:bloc/bloc.dart';
import 'package:business/business.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'category_view_state.dart';

class CategoryViewCubit extends Cubit<CategoryViewState> {
  final StreamUseCase<Category, String> _watchCategoryById;

  CategoryViewCubit({
    required StreamUseCase<Category, String> watchCategoryById,
    required String categoryId,
  })  : _watchCategoryById = watchCategoryById,
        super(CategoryViewState.initial(categoryId)) {
    loadCategory();
  }

  void loadCategory() async {
    emit(state.copyWith(category: AsyncSnapshot.waiting()));

    _watchCategoryById(state.id).listen((result) {
      result.fold(
        (error) =>
            emit(state.copyWith(category: AsyncSnapshot.withError(ConnectionState.done, error))),
        (category) =>
            emit(state.copyWith(category: AsyncSnapshot.withData(ConnectionState.done, category))),
      );
    });
  }
}
