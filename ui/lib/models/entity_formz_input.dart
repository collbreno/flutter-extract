import 'package:business/business.dart';
import 'package:ui/bloc/entity_form_cubit.dart';

typedef CategoryFormzInput = EntityFormzInput<Category>;

enum EntityFormzInputValidationError { empty }

class EntityFormzInput<T> extends FormzInputSuper<T?, EntityFormzInputValidationError> {
  const EntityFormzInput.pure([T? value]) : super.pure(value);

  const EntityFormzInput.dirty([T? value]) : super.dirty(value);

  @override
  FormzInputSuper<T?, EntityFormzInputValidationError> dirtyConstructor(value) {
    return EntityFormzInput.dirty(value);
  }

  @override
  FormzInputSuper<T?, EntityFormzInputValidationError> pureConstructor(value) {
    return EntityFormzInput.pure(value);
  }

  @override
  EntityFormzInputValidationError? validator(T? value) {
    if (value == null) return EntityFormzInputValidationError.empty;
    return null;
  }
}
