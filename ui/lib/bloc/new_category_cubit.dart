import 'package:bloc/bloc.dart';
import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:dartz/dartz.dart';

part 'new_category_state.dart';

class NewCategoryCubit extends Cubit<NewCategoryState> {
  final uid = Uuid();
  final UseCase<void, Category> _insertCategory;
  // final UseCase<void, Subcategory> _insertSubcategory;
  final UseCase<void, Category> _updateCategory;
  // final UseCase<void, Subcategory> _updateSubcategory;

  NewCategoryCubit({
    required UseCase<void, Category> insertCategory,
    // required UseCase<void, Subcategory> insertSubcategory,
    required UseCase<void, Category> updateCategory,
    // required UseCase<void, Subcategory> updateSubcategory,
  })  : _insertCategory = insertCategory,
        // _insertSubcategory = insertSubcategory,
        _updateCategory = updateCategory,
        // _updateSubcategory = updateSubcategory,
        super(NewCategoryInitial());

  void submit({
    required String? id,
    required String name,
    required Color color,
    required IconData icon,
    required Category? parent,
  }) async {
    emit(NewCategoryLoading());

    late final Either<Failure, void> result;

    if (parent == null) {
      if (id == null)
        result = await _insertCategory(Category(
          id: uid.v4(),
          color: color,
          icon: icon,
          name: name,
        ));
      else
        result = await _updateCategory(Category(
          id: id,
          name: name,
          icon: icon,
          color: color,
        ));
    } else {
      // if (id == null)
      //   result = await _insertSubcategory(Subcategory(
      //     id: uid.v4(),
      //     color: color,
      //     icon: icon,
      //     name: name,
      //     parent: parent,
      //   ));
      // else
      //   result = await _updateSubcategory(Subcategory(
      //     id: id,
      //     color: color,
      //     icon: icon,
      //     name: name,
      //     parent: parent,
      //   ));
    }

    result.fold(
      (l) => emit(NewCategoryError(l)),
      (r) => emit(NewCategoryInitial()),
    );
  }
}
