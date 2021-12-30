import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/bloc/entity_list_cubit.dart';
import 'package:ui/common/multi_select_app_bar.dart';

class EntityListBuilder<T> extends StatefulWidget {
  final Widget Function(BuildContext context, T item, bool selected) itemBuilder;
  final VoidCallback? onAddPressed;
  final ValueSetter<T>? onOpenItem;
  final ValueSetter<T>? onEditItem;

  const EntityListBuilder({
    Key? key,
    required this.itemBuilder,
    this.onAddPressed,
    this.onOpenItem,
    this.onEditItem,
  }) : super(key: key);

  @override
  _EntityListBuilderState createState() => _EntityListBuilderState<T>();
}

class _EntityListBuilderState<T> extends State<EntityListBuilder<T>> {
  late Set<T> _selectedItems;

  bool get _isSelecting => _selectedItems.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _selectedItems = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MultiSelectAppBar<T>(
        defaultAppBar: AppBar(title: Text("Resultados")),
        selectedItems: _selectedItems.toList(),
        onClear: () => setState(() {
          _selectedItems.clear();
        }),
        backgroundColorWhenSelected: Theme.of(context).toggleableActiveColor,
        actions: _buildMultiSelectAppBarActions(),
      ),
      body: BlocBuilder<EntityListCubit<T>, EntityListState<T>>(
        builder: (context, state) {
          if (state is EntityListLoading<T>)
            return Center(child: CircularProgressIndicator());
          else if (state is EntityListError<T>)
            return _Error(state.error);
          else if (state is EntityListFinished<T>)
            return _buildList(state.items);
          else
            throw ArgumentError(
                'No builder defined for $EntityListState of type ${state.runtimeType}');
        },
      ),
      floatingActionButton: widget.onAddPressed == null
          ? null
          : FloatingActionButton(
              onPressed: widget.onAddPressed,
              child: Icon(Icons.add),
            ),
    );
  }

  Widget _buildList(List<T> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index]!;

        return InkWell(
          onTap: _isSelecting ? () => _toggleItem(item) : () => widget.onOpenItem?.call(item),
          onLongPress: () => _toggleItem(item),
          child: widget.itemBuilder(context, item, _selectedItems.contains(item)),
        );
      },
    );
  }

  void _toggleItem(T item) {
    if (_selectedItems.contains(item)) {
      setState(() {
        _selectedItems.remove(item);
      });
    } else {
      setState(() {
        _selectedItems.add(item);
      });
    }
  }

  List<Widget> _buildMultiSelectAppBarActions() {
    return [
      if (_selectedItems.length == 1)
        IconButton(
          onPressed: () {
            widget.onEditItem?.call(_selectedItems.single);
          },
          icon: Icon(Icons.edit),
        ),
      IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
    ];
  }
}

class _Error extends StatelessWidget {
  final Failure error;

  const _Error(this.error, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          error is NotFoundFailure ? Text("Nenhum resultado encontrado") : Text("Algo deu errado"),
    );
  }
}
