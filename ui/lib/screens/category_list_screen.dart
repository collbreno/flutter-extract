import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/category_list_cubit.dart';
import 'package:ui/common/list_tile_utils.dart';

class CategoryListScreen extends StatelessWidget {
  CategoryListScreen({Key? key}) : super(key: key);

  late final _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = CategoryListCubit(context.read<GetCategoriesUseCase>());
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorias"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<CategoryListCubit, CategoryListState>(
      bloc: _bloc,
      builder: (context, state) {
        if (state is CategoryListLoaded)
          return _buildList(state.categories);
        else if (state is CategoryListError)
          return _buildError(state.error);
        else if (state is CategoryListLoading)
          return _buildLoading();
        else
          throw ArgumentError();
      },
    );
  }

  Widget _buildList(List<Category> categories) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryListTile(category);
      },
    );
  }

  Widget _buildError(Failure error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Algo deu errado"),
        SizedBox(height: 20),
        OutlinedButton(
          onPressed: _bloc.loadCategories,
          child: Text("Recarregar"),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }
}