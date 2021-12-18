import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/screens/category_form/category_form.dart';
import 'package:ui/screens/category_form/category_form_screen.dart';
import 'package:ui/bloc/category_view_cubit.dart';

enum _Actions { delete, edit }

class CategoryView extends StatelessWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: RefreshIndicator(
        onRefresh: () async => context.read<CategoryViewCubit>().loadCategory(),
        child: ListView(
          children: [
            _CategoryListTile(),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryViewCubit, CategoryViewState>(
      builder: (context, state) {
        return AppBar(
          title: Text("Categoria"),
          actions: state.category.hasData
              ? [
                  PopupMenuButton<_Actions>(
                    onSelected: (action) {
                      if (action == _Actions.edit)
                        Navigator.of(context).push(CategoryFormScreen.route(state.category.data));
                      // TODO: Implementar delete
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: _Actions.delete,
                          child: Text("Deletar"),
                        ),
                        PopupMenuItem(
                          value: _Actions.edit,
                          child: Text("Editar"),
                        ),
                      ];
                    },
                  )
                ]
              : null,
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CategoryListTile extends StatelessWidget {
  const _CategoryListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryViewCubit, CategoryViewState>(
      builder: (context, state) {
        if (state.category.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state.category.hasData) {
          final category = state.category.data!;
          return ListTile(
            title: Text(category.name),
            leading: Icon(category.icon, color: category.color),
          );
        }
        if (state.category.hasError) {
          return Column(
            children: [
              Text("Algo deu errado"),
              OutlinedButton(
                onPressed: context.read<CategoryViewCubit>().loadCategory,
                child: Text("Recarregar"),
              )
            ],
          );
        }
        throw ArgumentError();
      },
    );
  }
}
