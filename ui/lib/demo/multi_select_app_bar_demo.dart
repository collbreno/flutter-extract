import 'package:flutter/material.dart';
import 'package:ui/common/multi_select_app_bar.dart';

class MultiSelectAppBarDemo extends StatefulWidget {
  const MultiSelectAppBarDemo({Key? key}) : super(key: key);

  @override
  _MultiSelectAppBarDemoState createState() => _MultiSelectAppBarDemoState();
}

class _MultiSelectAppBarDemoState extends State<MultiSelectAppBarDemo> {
  late final List<String> _items;
  late Set<String> _selectedItems;

  bool get _isSelecting => _selectedItems.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _items = ['Maçã', 'Banana', 'Goiaba', 'Abacaxi'];
    _selectedItems = {};
  }

  void _toggleItem(String item) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MultiSelectAppBar(
        defaultAppBar: AppBar(
          title: Text('Primária'),
          backgroundColor: Colors.blue,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.copy)),
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
        ],
        onClear: () {
          setState(() {
            _selectedItems.clear();
          });
        },
        backgroundColorWhenSelected: Colors.blueAccent,
        selectedItems: _selectedItems.toList(),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (ctx, index) {
          final item = _items[index];
          return ListTile(
            selected: _selectedItems.contains(item),
            onLongPress: _isSelecting ? null : () => _toggleItem(item),
            onTap: !_isSelecting ? null : () => _toggleItem(item),
            title: Text(item),
          );
        },
      ),
    );
  }
}
