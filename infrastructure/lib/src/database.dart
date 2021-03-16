import 'package:infrastructure/infrastructure.dart';
import 'package:moor/moor.dart';
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
  ],
  daos: [
    CategoryDao,
    ExpenseDao,
    IconDao,
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
      },
    );
  }
}
