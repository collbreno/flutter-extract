import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/category_form_cubit.dart';
import 'package:ui/common/list_tile_form_fields.dart';
import 'package:ui/common/toggle_buttons_form_field.dart';
import 'package:ui/screens/category_form.dart';
import 'package:ui/services/color_service.dart';
import 'package:provider/provider.dart';

class NewCategoryScreen extends StatefulWidget {
  @override
  _NewCategoryScreenState createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Categoria"),
      ),
      body: BlocProvider(
        create: (context) => CategoryFormCubit(
          insertCategory: context.read<InsertCategoryUseCase>(),
          updateCategory: context.read<UpdateCategoryUseCase>(),
        ),
        child: CategoryForm(),
      ),
    );
  }
}
