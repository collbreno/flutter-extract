import 'package:formz/formz.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:ui/models/category_name_formz_input.dart';
import 'package:uuid/uuid.dart';

enum UidFormzInputValidationError { empty, invalid }

class UidFormzInput extends FormzInput<String, UidFormzInputValidationError> {
  const UidFormzInput.pure([String value = '']) : super.pure(value);

  const UidFormzInput.dirty([String value = '']) : super.dirty(value);

  UidFormzInput.random() : super.dirty(Uuid().v4());

  @override
  UidFormzInputValidationError? validator(String value) {
    if (value.isEmpty) return UidFormzInputValidationError.empty;
    if (value.length != UID_SIZE) return UidFormzInputValidationError.invalid;
    return null;
  }
}
