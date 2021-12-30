import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/category_list_cubit.dart';
import 'package:ui/common/multi_select_app_bar.dart';
import 'package:ui/screens/category_form_screen.dart';
import 'package:ui/screens/category_view/category_view_screen.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MultiSelectAppBar(
        defaultAppBar: AppBar(title: Text("Categorias")),
        selectedItems: [],
        onClear: () {},
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
        ],
      ),
      body: BlocBuilder<CategoryListCubit, CategoryListState>(
        builder: (context, state) {
          if (state is CategoryListLoaded)
            return _List(state.categories);
          else if (state is CategoryListError)
            return _Error(state.error);
          else if (state is CategoryListLoading)
            return Center(child: CircularProgressIndicator());
          else
            throw ArgumentError();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(CategoryFormScreen.route()),
        child: Icon(Icons.add),
      ),
    );
  }
}

class _List extends StatelessWidget {
  final List<Category> categories;

  const _List(this.categories, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ListTile(
          title: Text(category.name),
          leading: Icon(category.icon, color: category.color),
          onTap: () => Navigator.of(context).push(CategoryViewScreen.route(category.id)),
        );
      },
    );
  }
}

class _Error extends StatelessWidget {
  final Failure error;

  const _Error(this.error, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Algo deu errado"),
        SizedBox(height: 20),
        OutlinedButton(
          onPressed: context.read<CategoryListCubit>().loadCategories,
          child: Text("Recarregar"),
        ),
      ],
    );
  }
}
