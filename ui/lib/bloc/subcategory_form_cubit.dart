import 'package:built_collection/built_collection.dart';
import 'package:business/business.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/models/_models.dart';
import 'package:ui/models/entity_formz_input.dart';
import 'package:ui/models/subcategory_name_formz_input.dart';

class SubcategoryFormCubit extends EntityFormCubit<Subcategory> {
  SubcategoryFormCubit({
    Subcategory? subcategory,
    required FutureUseCase<void, Subcategory> insertSubcategory,
    required FutureUseCase<void, Subcategory> updateSubcategory,
  }) : super(
          inputs: _getDefaultInputs(subcategory),
          updateUseCase: updateSubcategory,
          insertUseCase: insertSubcategory,
          id: subcategory?.id ?? '',
        );

  static BuiltList<FormzInputSuper> _getDefaultInputs(Subcategory? subcategory) {
    return BuiltList([
      CategoryFormzInput.pure(subcategory?.parent),
      SubcategoryNameFormzInput.pure(subcategory?.name ?? ''),
      IconFormzInput.pure(subcategory?.icon),
      ColorFormzInput.pure(subcategory?.color),
    ]);
  }

  @override
  BuiltList<FormzInputSuper> getDefaultInputs() {
    return _getDefaultInputs(null);
  }

  @override
  Subcategory mapInputsToEntity(String id) {
    return Subcategory(
      id: id,
      parent: state.inputs.singleWithType<CategoryFormzInput>().value!,
      icon: state.inputs.singleWithType<IconFormzInput>().value!,
      color: state.inputs.singleWithType<ColorFormzInput>().value!,
      name: state.inputs.singleWithType<SubcategoryNameFormzInput>().value,
    );
  }
}
