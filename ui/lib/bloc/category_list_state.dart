part of 'category_list_cubit.dart';

abstract class CategoryListState extends Equatable {
  const CategoryListState();
}

class CategoryListInitial extends CategoryListState {
  @override
  List<Object> get props => [];
}

class CategoryListLoading extends CategoryListState {
  @override
  List<Object?> get props => [];
}

class CategoryListError extends CategoryListState {
  final Failure error;

  CategoryListError(this.error);

  @override
  List<Object?> get props => [error];
}

class CategoryListLoaded extends CategoryListState {
  final List<Category> categories;

  CategoryListLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}
