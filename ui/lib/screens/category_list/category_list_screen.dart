import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/navigation/page_transitions.dart';
import 'package:ui/navigation/screen.dart';
import 'package:ui/screens/category_list/bloc/category_list_cubit.dart';
import 'package:ui/screens/category_list/category_list.dart';
import 'package:ui/screens/category_view/category_view_screen.dart';

class CategoryListScreen extends StatelessWidget implements Screen {
  static Route route() {
    return AndroidTransition(CategoryListScreen());
  }

  CategoryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryListCubit>(
      create: (context) => CategoryListCubit(
        context.read<GetCategoriesUseCase>(),
      ),
      child: CategoryList(),
    );
  }
}