import 'package:built_collection/built_collection.dart';
import 'package:business/business.dart';
import 'package:formz/formz.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/models/_models.dart';

class TagFormCubit extends EntityFormCubit<Tag> {
  TagFormCubit({
    required FutureUseCase<void, Tag> insertTag,
    required FutureUseCase<void, Tag> updateTag,
    Tag? tag,
  }) : super(
          id: tag?.id ?? '',
          insertUseCase: insertTag,
          updateUseCase: updateTag,
          inputs: _getDefaultInputs(tag),
        );

  static BuiltList<FormzInput> _getDefaultInputs(Tag? tag) {
    return BuiltList([
      TagNameFormzInput.pure(tag?.name ?? ''),
      ColorFormzInput.pure(tag?.color),
      NullableIconFormzInput.pure(tag?.icon),
    ]);
  }

  @override
  BuiltList<FormzInput> getDefaultInputs() {
    return _getDefaultInputs(null);
  }

  @override
  Tag mapInputsToEntity(String id) {
    return Tag(
      id: id,
      color: state.inputs.singleWithType<ColorFormzInput>().value!,
      name: state.inputs.singleWithType<TagNameFormzInput>().value,
      icon: state.inputs.singleWithType<NullableIconFormzInput>().value,
    );
  }
}
