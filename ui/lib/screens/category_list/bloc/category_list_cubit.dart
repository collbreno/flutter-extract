import 'package:bloc/bloc.dart';
import 'package:business/business.dart';
import 'package:equatable/equatable.dart';

part 'category_list_state.dart';

class CategoryListCubit extends Cubit<CategoryListState> {
  final NoParamFutureUseCase<List<Category>> _getCategories;

  CategoryListCubit(this._getCategories) : super(CategoryListInitial()) {
    loadCategories();
  }

  void loadCategories() async {
    print('carregabdo categorias');
    emit(CategoryListLoading());

    final result = await _getCategories();

    result.fold(
      (error) => emit(CategoryListError(error)),
      (categories) => emit(CategoryListLoaded(categories)),
    );
  }
}
