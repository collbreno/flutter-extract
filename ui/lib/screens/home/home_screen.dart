import 'package:flutter/material.dart';
import 'package:ui/navigation/screen.dart';
import 'package:ui/screens/category_form_screen.dart';
import 'package:ui/screens/category_list/category_list_screen.dart';
import 'package:ui/screens/new_expense_screen.dart';
import 'package:ui/screens/settings_screen.dart';
import 'package:ui/screens/store_form_screen.dart';
import 'package:ui/screens/tag_form_screen.dart';

class HomeScreen extends StatelessWidget implements Screen {
  const HomeScreen({Key? key}) : super(key: key);

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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(CategoryFormScreen.route());
                },
                child: Text("Adicionar Categoria"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(CategoryListScreen.route());
                },
                child: Text("Ver Categorias"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(TagFormScreen.route());
                },
                child: Text("Adicionar Tag"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(StoreFormScreen.route());
                  },
                  child: Text('Adicionar Loja')),
            ],
          ),
        ),
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
