import 'package:built_collection/built_collection.dart';
import 'package:built_collection/src/list.dart';
import 'package:business/business.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/models/_models.dart';

class StoreFormCubit extends EntityFormCubit<Store> {
  StoreFormCubit({
    required FutureUseCase<void, Store> insertStore,
    required FutureUseCase<void, Store> updateStore,
    Store? store,
  }) : super(
          insertUseCase: insertStore,
          updateUseCase: updateStore,
          id: store?.id ?? '',
          inputs: _getDefaultInputs(store),
        );

  static BuiltList<FormzInputSuper> _getDefaultInputs(Store? store) {
    return BuiltList([
      StoreNameFormzInput.pure(store?.name ?? ''),
    ]);
  }

  @override
  BuiltList<FormzInputSuper> getDefaultInputs() {
    return _getDefaultInputs(null);
  }

  @override
  Store mapInputsToEntity(String id) {
    return Store(
      id: id,
      name: state.inputs.singleWithType<StoreNameFormzInput>().value,
    );
  }
}
