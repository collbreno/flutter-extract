import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/subcategory_form_cubit.dart';
import 'package:ui/common/form/entity_form_builder.dart';
import 'package:ui/navigation/page_transitions.dart';
import 'package:ui/navigation/screen.dart';

class SubcategoryFormScreen extends StatelessWidget implements Screen {
  static Route route([Subcategory? subcategory]) {
    return AndroidTransition(SubcategoryFormScreen._(subcategory: subcategory));
  }

  const SubcategoryFormScreen._({Key? key, this.subcategory}) : super(key: key);

  final Subcategory? subcategory;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubcategoryFormCubit(
        insertSubcategory: context.read<InsertSubcategoryUseCase>(),
        updateSubcategory: context.read<UpdateSubcategoryUseCase>(),
        subcategory: subcategory,
      ),
      child: EntityFormBuilder<SubcategoryFormCubit>(
        titleWhenEditing: 'Editar Subcategoria',
        titleWhenCreating: 'Criar Subcategoria',
        onOpenEntity: (id) {},
      ),
    );
  }
}
