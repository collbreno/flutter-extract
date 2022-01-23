import 'package:flutter/material.dart';
import 'package:ui/navigation/screen.dart';
import 'package:ui/screens/category/category_list_screen.dart';
import 'package:ui/screens/new_expense_screen.dart';
import 'package:ui/screens/payment_method/payment_method_list_screen.dart';
import 'package:ui/screens/settings_screen.dart';
import 'package:ui/screens/store/store_list_screen.dart';
import 'package:ui/screens/subcategory/subcategory_list_screen.dart';
import 'package:ui/screens/tag/tag_list_screen.dart';

class HomeScreen extends StatelessWidget implements Screen {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: SizedBox(),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text("Configurações"),
              onTap: () => Navigator.of(context).push(SettingsScreen.route()),
              leading: Icon(Icons.settings),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          ElevatedButton(
            child: Text('Categorias'),
            onPressed: () => Navigator.of(context).push(CategoryListScreen.route()),
          ),
          ElevatedButton(
            child: Text("Subcategorias"),
            onPressed: () => Navigator.of(context).push(SubcategoryListScreen.route()),
          ),
          ElevatedButton(
            child: Text('Tags'),
            onPressed: () => Navigator.of(context).push(TagListScreen.route()),
          ),
          ElevatedButton(
            child: Text('Lojas'),
            onPressed: () => Navigator.of(context).push(StoreListScreen.route()),
          ),
          ElevatedButton(
            child: Text('Métodos de Pagamento'),
            onPressed: () => Navigator.of(context).push(PaymentMethodListScreen.route()),
          ),
        ]
            .map((e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: e,
                ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(NewExpenseScreen.route());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
