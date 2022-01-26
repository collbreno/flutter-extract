import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:infrastructure/src/tables/expense_draft_files.dart';
import 'package:infrastructure/src/tables/expense_draft_tags.dart';
import 'package:infrastructure/src/tables/expense_drafts.dart';
import 'package:infrastructure/src/tables/expense_files.dart';
import 'package:infrastructure/src/triggers/expense_draft_trigger.dart';
import 'package:infrastructure/src/triggers/expenses_triggers.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Categories,
    Expenses,
    ExpenseTags,
    ExpenseFiles,
    ExpenseDrafts,
    ExpenseDraftFiles,
    ExpenseDraftTags,
    PaymentMethods,
    Stores,
    Subcategories,
    Tags,
    ExpensesHistory,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  AppDatabase.fromFile(File file) : super(NativeDatabase(file));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
      onCreate: (m) async {
        await m.createAll();
        await m.createTrigger(Trigger(
          ExpenseDraftTriggers.delete_draft_after_insert_expense,
          'delete_draft_after_insert_expense',
        ));
        await m.createTrigger(Trigger(
          ExpensesTriggers.save_history_after_update_expense,
          'save_history_after_update_expense',
        ));
        await m.createTrigger(Trigger(
          ExpensesTriggers.save_history_after_delete_expense,
          'save_history_after_delete_expense',
        ));
      },
    );
  }
}
