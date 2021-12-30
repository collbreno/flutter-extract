import 'package:business/business.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/category_form_cubit.dart';
import 'package:ui/common/form/entity_form_builder.dart';
import 'package:ui/navigation/page_transitions.dart';
import 'package:ui/navigation/screen.dart';
import 'package:ui/screens/category_view/category_view_screen.dart';

class CategoryFormScreen extends StatelessWidget implements Screen {
  const CategoryFormScreen({Key? key, this.category}) : super(key: key);

  static Route route([Category? category]) {
    return AndroidTransition(CategoryFormScreen(category: category));
  }

  final Category? category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryFormCubit(
        insertCategory: context.read<InsertCategoryUseCase>(),
        updateCategory: context.read<UpdateCategoryUseCase>(),
        category: category,
      ),
      child: EntityFormBuilder<CategoryFormCubit>(
        titleWhenEditing: 'Editar Categoria',
        titleWhenCreating: 'Criar Categoria',
        onOpenEntity: (id) => Navigator.of(context).push(CategoryViewScreen.route(id)),
      ),
    );
  }
}
