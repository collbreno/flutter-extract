import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickerDialog<T> extends StatefulWidget {
  final EdgeInsets contentPadding;
  final int columns;
  final bool Function(T, String)? onSearch;
  final ValueSetter<T> onItemSelected;
  final VoidCallback? onRemove;
  final Widget Function(T) renderer;
  final List<T> items;
  final String title;
  final List<Widget> actions;

  PickerDialog({
    required this.title,
    required this.items,
    required this.renderer,
    required this.onItemSelected,
    this.onSearch,
    this.contentPadding = const EdgeInsets.all(12),
    this.columns = 1,
    this.onRemove,
    this.actions = const [],
  });
  @override
  _PickerDialogState<T> createState() => _PickerDialogState<T>();
}

class _PickerDialogState<T> extends State<PickerDialog<T>> {
  final _staticTitleKey = UniqueKey();
  final _textFieldKey = UniqueKey();
  final _searchButtonKey = UniqueKey();
  final _closeButtonKey = UniqueKey();

  late bool isSearching;
  late List<T> visibleItems;
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    isSearching = false;
    visibleItems = widget.items;
    controller = TextEditingController();

    if (widget.onSearch != null) {
      controller.addListener(() {
        setState(() {
          visibleItems =
              widget.items.where((element) => widget.onSearch!(element, controller.text)).toList();
        });
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 24),
      title: renderTitle(),
      titlePadding: EdgeInsets.all(0),
      content: renderList(),
      actions: widget.actions,
    );
  }

  Widget renderTitle() {
    if (isSearchable) {
      return renderSearchableTitle();
    }
    return renderStaticTitle();
  }

  Widget renderStaticTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 24, bottom: 24),
      key: _staticTitleKey,
      child: Text(
        widget.title,
      ),
    );
  }

  Widget renderTextField() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 12, bottom: 12),
      key: _textFieldKey,
      child: TextField(
        autofocus: true,
        controller: controller,
        decoration: InputDecoration(
          hintText: "Pesquisar",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget renderSearchableTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: isSearching ? renderTextField() : renderStaticTitle(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isSearching ? renderCloseButton() : renderSearchButton(),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
          ),
        )
      ],
    );
  }

  Widget renderCloseButton() {
    return InkWell(
      key: _closeButtonKey,
      onTap: () {
        setState(() {
          controller.clear();
          isSearching = false;
        });
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 48,
        width: 48,
        alignment: Alignment.center,
        child: Icon(Icons.close),
      ),
    );
  }

  Widget renderSearchButton() {
    return InkWell(
      key: _searchButtonKey,
      onTap: () => setState(() => isSearching = true),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 48,
        width: 48,
        alignment: Alignment.center,
        child: Icon(Icons.search),
      ),
    );
  }

  bool get isSearchable => widget.onSearch != null;

  Widget renderList() {
    if (widget.columns > 1) {
      return Container(
        height: 300,
        width: double.maxFinite,
        child: Scrollbar(
          child: GridView.builder(
            itemCount: visibleItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.columns,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  widget.onItemSelected(visibleItems[index]);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: widget.renderer(visibleItems[index]),
                ),
              );
            },
          ),
        ),
      );
    }
    return Container(
      width: double.maxFinite,
      height: 300,
      child: Scrollbar(
        child: ListView.builder(
          itemCount: visibleItems.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                widget.onItemSelected(visibleItems[index]);
                Navigator.pop(context);
              },
              child: widget.renderer(visibleItems[index]),
            );
          },
        ),
      ),
    );
  }
}
