import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/bloc/store_form_cubit.dart';
import 'package:ui/common/form/entity_form_builder.dart';

class StoreForm extends StatelessWidget {
  const StoreForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<StoreFormCubit, EntityFormState>(
          builder: (context, state) => state.id.isEmpty ? Text("Nova Loja") : Text("Editar Loja"),
        ),
      ),
      body: EntityFormBuilder<StoreFormCubit>(
        onOpenEntity: (id) {},
      ),
    );
  }
}
