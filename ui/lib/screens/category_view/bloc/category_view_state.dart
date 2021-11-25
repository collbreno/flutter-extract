part of 'category_view_cubit.dart';

class CategoryViewState extends Equatable {
  final String id;
  final AsyncSnapshot<Category> category;

  CategoryViewState(this.id) : category = AsyncSnapshot.nothing();

  CategoryViewState._({
    required this.id,
    required this.category,
  });

  CategoryViewState copyWith({AsyncSnapshot<Category>? category}) {
    return CategoryViewState._(
      id: id,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [id, category];
}
