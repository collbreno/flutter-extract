import 'package:bloc/bloc.dart';
import 'package:business/business.dart';
import 'package:equatable/equatable.dart';

part 'category_list_state.dart';

class CategoryListCubit extends Cubit<CategoryListState> {
  final NoParamStreamUseCase<List<Category>> _watchCategories;

  CategoryListCubit(this._watchCategories) : super(CategoryListInitial()) {
    loadCategories();
  }

  void loadCategories() async {
    emit(CategoryListLoading());

    _watchCategories().listen((result) {
      result.fold(
        (error) => emit(CategoryListError(error)),
        (categories) => emit(CategoryListLoaded(categories)),
      );
    });
  }
}
