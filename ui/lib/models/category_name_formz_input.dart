import 'package:formz/formz.dart';
import 'package:infrastructure/infrastructure.dart';

enum CategoryNameFormzInputValidationError {
  empty,
  tooLong,
  tooShort,
}

class CategoryNameFormzInput extends FormzInput<String, CategoryNameFormzInputValidationError> {
  const CategoryNameFormzInput.pure([String value = '']) : super.pure('');

  const CategoryNameFormzInput.dirty([String value = '']) : super.dirty(value);

  @override
  CategoryNameFormzInputValidationError? validator(String value) {
    if (value.isEmpty) return CategoryNameFormzInputValidationError.empty;
    if (value.length < CATEGORY_NAME_MIN) return CategoryNameFormzInputValidationError.tooShort;
    if (value.length > CATEGORY_NAME_MAX) return CategoryNameFormzInputValidationError.tooLong;
    return null;
  }
}
