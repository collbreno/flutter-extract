import 'package:animations/animations.dart';
import 'package:built_collection/built_collection.dart';
import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/common/expense_list_item.dart';
import 'package:ui/screens/expense_detail_screen.dart';

class ExpenseItemsDemo extends StatefulWidget {
  const ExpenseItemsDemo({Key? key}) : super(key: key);

  @override
  _ExpenseItemsDemoState createState() => _ExpenseItemsDemoState();
}

class _ExpenseItemsDemoState extends State<ExpenseItemsDemo> {
  @override
  Widget build(BuildContext context) {
    final expense = Expense(
      id: 'a',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      date: DateTime.now(),
      description: 'Casa > Aeroporto',
      paymentMethod: PaymentMethod(
        id: 'b',
        name: 'Crédito',
        color: Colors.purple,
        icon: Icons.credit_card,
      ),
      subcategory: Subcategory(
        id: 'a',
        icon: Icons.directions_car,
        name: 'Uber',
        color: Colors.black,
        parent: Category(
          id: 'a',
          name: 'Transporte',
          color: Colors.purple[800]!,
          icon: Icons.directions_bus,
        ),
      ),
      value: 2480,
      tags: BuiltList([
        Tag(id: '', name: 'Almoço', color: Colors.grey),
        Tag(id: '', name: 'Splid', color: Colors.grey, icon: Icons.horizontal_split),
        Tag(id: '', name: 'Fluminense', color: Colors.grey),
        Tag(id: '', name: 'Maracanã', color: Colors.grey, icon: Icons.sports_soccer),
        Tag(id: '', name: 'Amanda', color: Colors.pink, icon: Icons.favorite),
        Tag(id: '', name: 'Barney', color: Colors.grey),
      ]),
      store: Store(name: 'Santa Marta', id: 'a'),
      files: BuiltList(['file1, file2, file3']),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Items'),
      ),
      body: Center(
        child: OpenContainer(
          openBuilder: (ctx, closeBuilder) {
            return ExpenseDetailScreen(expense: expense);
          },
          closedBuilder: (ctx, openBuilder) {
            return ExpenseListItem(
              onTap: openBuilder,
              expense: expense,
            );
          },
        ),
      ),
    );
  }
}
