import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/category_form_cubit.dart';
import 'package:ui/bloc/entity_form_cubit.dart';
import 'package:ui/common/form/entity_form_builder.dart';
import 'package:ui/screens/category_view/category_view_screen.dart';

class CategoryForm extends StatelessWidget {
  CategoryForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: EntityFormBuilder<CategoryFormCubit>(
        onOpenEntity: (id) {
          Navigator.of(context).push(CategoryViewScreen.route(id));
        },
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryFormCubit, EntityFormState>(
      builder: (context, state) {
        return AppBar(
          title: state.id.isEmpty ? Text("Nova Categoria") : Text("Editar Categoria"),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
