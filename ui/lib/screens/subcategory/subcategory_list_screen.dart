import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/entity_mutable_list_cubit.dart';
import 'package:ui/common/entity_list_builder.dart';
import 'package:ui/navigation/page_transitions.dart';
import 'package:ui/navigation/screen.dart';
import 'package:ui/screens/subcategory/subcategory_form_screen.dart';

class SubcategoryListScreen extends StatelessWidget implements Screen {
  static Route route() {
    return AndroidTransition(SubcategoryListScreen._());
  }

  const SubcategoryListScreen._({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EntityMutableListCubit<Subcategory>>(
      create: (context) => EntityMutableListCubit<Subcategory>(
        watchAllUseCase: context.read<WatchSubcategoriesUseCase>(),
        deleteUseCase: context.read<DeleteSubcategoryUseCase>(),
        editItemCallback: (item) => Navigator.of(context).push(SubcategoryFormScreen.route(item)),
        openItemCallback: (item) {},
      ),
      child: EntityListBuilder<Subcategory>(
        appBarTitle: 'Subcategorias',
        filterItem: (item, text) => item.name.matches(text) || item.parent.name.matches(text),
        onAddPressed: () => Navigator.of(context).push(SubcategoryFormScreen.route()),
        itemBuilder: (context, item, selected) {
          return ListTile(
              title: Text(item.name),
              subtitle: Text(item.parent.name),
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
