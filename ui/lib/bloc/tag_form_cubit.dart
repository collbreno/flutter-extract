import 'package:business/business.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:ui/models/_models.dart';

class TagFormCubit extends EntityFormCubit<Tag> {
  TagFormCubit({
    required FutureUseCase<void, Tag> insert,
    required FutureUseCase<void, Tag> update,
    Tag? tag,
  }) : super(
          id: tag?.id ?? '',
          insertUseCase: insert,
          updateUseCase: update,
          inputs: _getDefaultInputs(tag),
        );

  static BuiltList<FormzInputSuper> _getDefaultInputs(Tag? tag) {
    return BuiltList([
      TagNameFormzInput.pure(tag?.name ?? ''),
      ColorFormzInput.pure(tag?.color),
      IconFormzInput.pure(tag?.icon),
    ]);
  }

  @override
  BuiltList<FormzInputSuper> getDefaultInputs() {
    return _getDefaultInputs(null);
  }

  @override
  Tag mapInputsToEntity(String id) {
    return Tag(
      id: id,
      color: state.inputs.singleWithType<ColorFormzInput>().value!,
      name: state.inputs.singleWithType<TagNameFormzInput>().value,
      icon: state.inputs.singleWithType<IconFormzInput>().value,
    );
  }
}
