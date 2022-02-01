import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/store_form_cubit.dart';
import 'package:ui/common/form/entity_form_builder.dart';
import 'package:ui/navigation/page_transitions.dart';
import 'package:ui/navigation/screen.dart';
import 'package:uuid/uuid.dart';

class StoreFormScreen extends StatelessWidget implements Screen {
  final Store? store;

  const StoreFormScreen._({Key? key, this.store}) : super(key: key);

  static Route route([Store? store]) {
    return AndroidTransition(StoreFormScreen._(store: store));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoreFormCubit(
        insertStore: context.read<InsertStoreUseCase>(),
        updateStore: context.read<UpdateStoreUseCase>(),
        store: store,
        uid: Uuid(),
      ),
      child: EntityFormBuilder<StoreFormCubit>(
        onOpenEntity: (value) {},
        titleWhenCreating: 'Criar Loja',
        titleWhenEditing: 'Editar Loja',
      ),
    );
  }
}
