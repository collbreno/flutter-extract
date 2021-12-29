import 'package:built_collection/src/list.dart';
import 'package:business/business.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/models/_models.dart';

class CategoryFormCubit extends EntityFormCubit<Category> {
  CategoryFormCubit({
    required FutureUseCase<void, Category> insertCategory,
    required FutureUseCase<void, Category> updateCategory,
    Category? category,
  }) : super(
          insertUseCase: insertCategory,
          updateUseCase: updateCategory,
          id: category?.id ?? '',
          inputs: _getDefaultInputs(category),
        );

  static BuiltList<FormzInputSuper> _getDefaultInputs(Category? category) {
    return BuiltList([
      CategoryNameFormzInput.pure(category?.name ?? ''),
      IconFormzInput.pure(category?.icon),
      ColorFormzInput.pure(category?.color),
    ]);
  }

  @override
  BuiltList<FormzInputSuper> getDefaultInputs() {
    return _getDefaultInputs(null);
  }

  @override
  Category mapInputsToEntity(String id) {
    return Category(
      id: id,
      icon: state.inputs.singleWithType<IconFormzInput>().value!,
      color: state.inputs.singleWithType<ColorFormzInput>().value!,
      name: state.inputs.singleWithType<CategoryNameFormzInput>().value,
    );
  }
}
