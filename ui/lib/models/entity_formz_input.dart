import 'package:business/business.dart';
import 'package:formz/formz.dart';

typedef CategoryFormzInput = EntityFormzInput<Category>;

enum EntityFormzInputValidationError { empty }

class EntityFormzInput<T extends Entity> extends FormzInput<T?, EntityFormzInputValidationError> {
  const EntityFormzInput.pure([T? value]) : super.pure(value);

  const EntityFormzInput.dirty([T? value]) : super.dirty(value);

  @override
  EntityFormzInputValidationError? validator(T? value) {
    if (value == null) return EntityFormzInputValidationError.empty;
    return null;
  }
}
