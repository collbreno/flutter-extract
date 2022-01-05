import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/category_view_cubit.dart';
import 'package:ui/navigation/page_transitions.dart';
import 'package:ui/navigation/screen.dart';
import 'package:ui/screens/category/category_view.dart';

class CategoryViewScreen extends StatelessWidget implements Screen {
  static Route route(String categoryId) {
    return AndroidTransition(CategoryViewScreen._(categoryId));
  }

  final String categoryId;

  const CategoryViewScreen._(
    this.categoryId, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryViewCubit(
        watchCategoryById: context.read<WatchCategoryByIdUseCase>(),
        categoryId: categoryId,
      ),
      child: CategoryView(),
    );
  }
}
