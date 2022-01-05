import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/entity_list_cubit.dart';
import 'package:ui/common/entity_list_builder.dart';
import 'package:ui/navigation/page_transitions.dart';
import 'package:ui/navigation/screen.dart';
import 'package:ui/screens/category_form_screen.dart';
import 'package:ui/screens/category_view/category_view_screen.dart';

class CategoryListScreen extends StatelessWidget implements Screen {
  static Route route() {
    return AndroidTransition(CategoryListScreen._());
  }

  CategoryListScreen._({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EntityListCubit<Category>>(
      create: (context) => EntityListCubit<Category>(
        context.read<WatchCategoriesUseCase>(),
      ),
      child: EntityListBuilder<Category>(
        onAddPressed: () => Navigator.of(context).push((CategoryFormScreen.route())),
        onOpenItem: (item) => Navigator.of(context).push(CategoryViewScreen.route(item.id)),
        onEditItem: (item) => Navigator.of(context).push((CategoryFormScreen.route(item))),
        itemBuilder: (context, item, selected) {
          return ListTile(
              title: Text(item.name),
              selected: selected,
              leading: Icon(item.icon, color: item.color),
              trailing: AnimatedScale(
                duration: Duration(milliseconds: 100),
                scale: selected ? 1 : 0,
                child: Icon(
                  Icons.check,
                  key: ValueKey(item.id),
                ),
              ));
        },
      ),
    );
  }
}
