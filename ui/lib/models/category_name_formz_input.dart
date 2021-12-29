import 'package:infrastructure/infrastructure.dart';
import 'package:ui/bloc/entity_form_cubit.dart';

enum CategoryNameFormzInputValidationError {
  empty,
  tooLong,
  tooShort,
}

class CategoryNameFormzInput
    extends FormzInputSuper<String, CategoryNameFormzInputValidationError> {
  const CategoryNameFormzInput.pure([String value = '']) : super.pure(value);

  const CategoryNameFormzInput.dirty([String value = '']) : super.dirty(value);

  @override
  CategoryNameFormzInputValidationError? validator(String value) {
    if (value.isEmpty) return CategoryNameFormzInputValidationError.empty;
    if (value.length < CATEGORY_NAME_MIN) return CategoryNameFormzInputValidationError.tooShort;
    if (value.length > CATEGORY_NAME_MAX) return CategoryNameFormzInputValidationError.tooLong;
    return null;
  }

  @override
  FormzInputSuper<String, CategoryNameFormzInputValidationError> dirtyConstructor(value) {
    return CategoryNameFormzInput.dirty(value);
  }

  @override
  FormzInputSuper<String, CategoryNameFormzInputValidationError> pureConstructor(value) {
    return CategoryNameFormzInput.pure(value);
  }
}
