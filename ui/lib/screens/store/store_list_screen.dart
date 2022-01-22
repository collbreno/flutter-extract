import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/entity_mutable_list_cubit.dart';
import 'package:ui/common/entity_list_builder.dart';
import 'package:ui/navigation/page_transitions.dart';

import 'store_form_screen.dart';

class StoreListScreen extends StatelessWidget {
  const StoreListScreen._({Key? key}) : super(key: key);

  static Route route() {
    return AndroidTransition(StoreListScreen._());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EntityMutableListCubit<Store>(
        watchAllUseCase: context.read<WatchStoresUseCase>(),
        deleteUseCase: context.read<SafeDeleteStoreUseCase>(),
        editItemCallback: (item) => Navigator.of(context).push(StoreFormScreen.route(item)),
        openItemCallback: (item) {
          // TODO: implement
          print('open item');
        },
      ),
      child: EntityListBuilder<Store>(
        appBarTitle: 'Lojas',
        filterItem: (item, text) => item.name.matches(text),
        onAddPressed: () => Navigator.of(context).push(StoreFormScreen.route()),
        itemBuilder: (context, item, selected) {
          return ListTile(
            title: Text(item.name),
            leading: Icon(Icons.store_rounded),
            selected: selected,
            trailing: AnimatedScale(
              duration: Duration(milliseconds: 100),
              scale: selected ? 1 : 0,
              child: Icon(
                Icons.check,
                key: ValueKey(item.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
