import 'package:infrastructure/infrastructure.dart';
import 'package:infrastructure/src/triggers/expenses_triggers.dart';
import 'package:moor/moor.dart';

part 'database.g.dart';

@UseMoor(
  tables: [
    Categories,
    Expenses,
    Icons,
    PaymentMethods,
    Stores,
    Subcategories,
    Tags,
    ExpenseTags,
    ExpensesHistory,
  ],
  daos: [
    CategoryDao,
    SubcategoryDao,
    ExpenseDao,
    IconDao,
    StoreDao,
    PaymentMethodDao,
    TagDao,
    ExpensesHistoryDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

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
