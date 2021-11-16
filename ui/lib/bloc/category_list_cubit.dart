import 'package:bloc/bloc.dart';
import 'package:business/business.dart';
import 'package:equatable/equatable.dart';

part 'category_list_state.dart';

class CategoryListCubit extends Cubit<CategoryListState> {
  final NoParamUseCase<List<Category>> getCategories;

  CategoryListCubit(this.getCategories) : super(CategoryListInitial()) {
    loadCategories();
  }

  void loadCategories() async {
    emit(CategoryListLoading());

    final result = await getCategories();

    result.fold(
      (error) => emit(CategoryListError(error)),
      (categories) => emit(CategoryListLoaded(categories)),
    );
  }
}
