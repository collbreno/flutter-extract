part of 'category_form_cubit.dart';

class CategoryFormState extends Equatable {
  final FormzStatus status;
  final String id;
  final CategoryNameFormzInput name;
  final IconFormzInput icon;
  final ColorFormzInput color;

  const CategoryFormState({
    this.status = FormzStatus.pure,
    this.id = '',
    this.name = const CategoryNameFormzInput.pure(),
    this.icon = const IconFormzInput.pure(),
    this.color = const ColorFormzInput.pure(),
  });

  CategoryFormState.fromCategory(Category category)
      : status = FormzStatus.pure,
        id = category.id,
        name = CategoryNameFormzInput.pure(category.name),
        color = ColorFormzInput.pure(category.color),
        icon = IconFormzInput.pure(category.icon);

  CategoryFormState copyWith({
    FormzStatus? status,
    String? id,
    CategoryNameFormzInput? name,
    IconFormzInput? icon,
    ColorFormzInput? color,
  }) {
    return CategoryFormState(
      status: status ?? this.status,
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [status, id, name, icon, color];
}
