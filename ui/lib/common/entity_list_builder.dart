import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/entity_mutable_list_cubit.dart';
import 'package:ui/common/multi_select_app_bar.dart';
import 'package:ui/common/search_app_bar.dart';

class EntityListBuilder<T extends Entity> extends StatefulWidget {
  final Widget Function(BuildContext context, T item, bool selected) itemBuilder;
  final VoidCallback? onAddPressed;
  final String appBarTitle;
  final bool Function(T item, String text) filterItem;

  const EntityListBuilder({
    Key? key,
    required this.itemBuilder,
    required this.appBarTitle,
    required this.filterItem,
    this.onAddPressed,
  }) : super(key: key);

  @override
  State<EntityListBuilder<T>> createState() => _EntityListBuilderState<T>();
}

class _EntityListBuilderState<T extends Entity> extends State<EntityListBuilder<T>> {
  late String _query;

  @override
  void initState() {
    _query = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntityMutableListCubit<T>, EntityMutableListState<T>>(
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: MultiSelectAppBar(
                defaultAppBar: SearchAppBar(
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                    });
                  },
                  title: Text(widget.appBarTitle),
                ),
                selectedItems: state.selectedItems,
                onClear: () => context.read<EntityMutableListCubit<T>>().onClearSelection(),
                backgroundColorWhenSelected: Theme.of(context).toggleableActiveColor,
                actions: [
                  if (state.selectedItems.length == 1)
                    IconButton(
                      onPressed: () => context.read<EntityMutableListCubit<T>>().onEditPressed(),
                      icon: Icon(Icons.edit),
                    ),
                  IconButton(
                    onPressed: () => context.read<EntityMutableListCubit<T>>().onDeletePressed(),
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
              body: _buildBody(state),
              floatingActionButton: widget.onAddPressed == null
                  ? null
                  : FloatingActionButton(
                      onPressed: widget.onAddPressed,
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
            ],
            if (state.deletionState is DeletionWithError) ...[
              ModalBarrier(
                dismissible: false,
                color: Colors.black54,
              ),
              AlertDialog(
                title: Text("Ops"),
                content: Row(
                  children: [
                    Text("Algo deu errado"),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildBody(EntityMutableListState<T> state) {
    if (state.items.hasData) {
      final filteredItems = state.items.data!.where((item) => widget.filterItem(item, _query));
      return filteredItems.isEmpty
          ? _Error(NotFoundFailure())
          : _buildList(filteredItems, state.selectedItems);
    } else if (state.items.hasError)
      return _Error(state.items.error!);
    else
      return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(Iterable<T> items, Iterable<String> selectedItems) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items.toList()[index];

        return InkWell(
          onTap: () => context.read<EntityMutableListCubit<T>>().onPressed(item),
          onLongPress: () => context.read<EntityMutableListCubit<T>>().onLongPressed(item),
          child: widget.itemBuilder(context, item, selectedItems.contains(item.id)),
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
