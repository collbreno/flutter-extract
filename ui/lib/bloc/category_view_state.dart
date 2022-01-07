part of 'category_view_cubit.dart';

class CategoryViewState extends Equatable {
  final String id;
  final AsyncData<Category> category;

  CategoryViewState.initial(this.id) : category = AsyncData.nothing();

  CategoryViewState({
    required this.id,
    required this.category,
  });

  CategoryViewState copyWith({AsyncData<Category>? category}) {
    return CategoryViewState(
      id: id,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [id, category];
}
