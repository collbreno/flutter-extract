import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui/navigation/page_transitions.dart';
import 'package:ui/screens/category_list_screen.dart';
import 'package:ui/screens/new_category_screen.dart';
import 'package:ui/screens/new_expense_screen.dart';
import 'package:ui/screens/new_store_screen.dart';
import 'package:ui/screens/new_tag_screen.dart';
import 'package:ui/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                color: Theme.of(context).accentColor,
              ),
            ),
            ListTile(
              title: Text("Configurações"),
              onTap: _goToSettings,
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
                  Navigator.of(context).push(
                    AndroidTransition(
                      NewCategoryScreen(),
                    ),
                  );
                },
                child: Text("Adicionar Categoria"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    AndroidTransition(
                      CategoryListScreen(),
                    ),
                  );
                },
                child: Text("Ver Categorias"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    AndroidTransition(
                      NewTagScreen(),
                    ),
                  );
                },
                child: Text("Adicionar Tag"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      AndroidTransition(
                        NewStoreScreen(),
                      ),
                    );
                  },
                  child: Text('Adicionar Loja')),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            AndroidTransition(
              NewExpenseScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _goToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsScreen(),
      ),
    );
  }
}
