import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/entity_list_cubit.dart';
import 'package:ui/common/multi_select_app_bar.dart';

class EntityListBuilder<T extends Entity> extends StatelessWidget {
  final Widget Function(BuildContext context, T item, bool selected) itemBuilder;
  final VoidCallback? onAddPressed;
  final String appBarTitle;

  const EntityListBuilder({
    Key? key,
    required this.itemBuilder,
    required this.appBarTitle,
    this.onAddPressed,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return BlocBuilder<EntityListCubit<T>, EntityListState<T>>(
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: MultiSelectAppBar(
                defaultAppBar: AppBar(title: Text(appBarTitle)),
                selectedItems: state.selectedItems,
                onClear: () => context.read<EntityListCubit<T>>().onClearSelection(),
                backgroundColorWhenSelected: Theme.of(context).toggleableActiveColor,
                actions: [
                  if (state.selectedItems.length == 1)
                    IconButton(
                      onPressed: () => context.read<EntityListCubit<T>>().onEditPressed(),
                      icon: Icon(Icons.edit),
                    ),
                  IconButton(
                    onPressed: () => context.read<EntityListCubit<T>>().onDeletePressed(),
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
              body: _buildBody(state),
              floatingActionButton: onAddPressed == null
                  ? null
                  : FloatingActionButton(
                      onPressed: onAddPressed,
                      child: Icon(Icons.add),
                    ),
            ),
            if (state.deletionState is DeletionInProgress) ...[
              ModalBarrier(
                dismissible: false,
                color: Colors.black54,
              ),
              AlertDialog(
                title: Text("Aguarde"),
                content: Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 24),
                    Text("Deletando itens"),
                  ],
                ),
              ),
            ]
          ],
        );
      },
    );
  }

  Widget _buildBody(EntityListState<T> state) {
    if (state.items.hasError)
      return _Error(state.items.error!);
    else if (state.items.hasData)
      return _buildList(state.items.data!, state.selectedItems);
    else
      return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(Iterable<T> items, Iterable<String> selectedItems) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items.toList()[index];

        return InkWell(
          onTap: () => context.read<EntityListCubit<T>>().onPressed(item),
          onLongPress: () => context.read<EntityListCubit<T>>().onLongPressed(item),
          child: itemBuilder(context, item, selectedItems.contains(item.id)),
        );
      },
    );
  }
}

class _Error extends StatelessWidget {
  final Object error;

  const _Error(this.error, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          error is NotFoundFailure ? Text("Nenhum resultado encontrado") : Text("Algo deu errado"),
    );
  }
}
