import 'package:business/business.dart';
import 'package:business/fixtures.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:infrastructure/src/mappers/_mappers.dart';

class ForeignKeyUtils {
  ForeignKeyUtils(this.db);

  final AppDatabase db;

  late final FixtureCategory fixCategory = FixtureCategory();
  late final FixtureSubcategory fixSubcategory = FixtureSubcategory();
  late final FixturePaymentMethod fixPaymentMethod = FixturePaymentMethod();
  late final FixtureStore fixStore = FixtureStore();
  late final FixtureTag fixTag = FixtureTag();

  Future<void> insertExpenseFKDependencies(Expense expense) async {
    await _insertSubcategoryIfNeeded(expense.subcategory);
    await _insertPaymentMethodIfNeeded(expense.paymentMethod);
    if (expense.store != null) {
      await _insertStoreIfNeeded(expense.store!);
    }
    await Future.wait([
      for (var tag in expense.tags) _insertTagIfNeeded(tag),
    ]);
  }

  Future<void> insertSubcategoryFKDependencies(Subcategory subcategory) async {
    await _insertCategoryIfNeeded(subcategory.parent);
  }

  Future<void> _insertCategoryIfNeeded(Category category) async {
    final categoryFromDb = await (db.select(db.categories)
          ..where((tbl) => tbl.id.equals(category.id)))
        .getSingleOrNull();
    if (categoryFromDb == null) {
      await db.into(db.categories).insert(category.toEntity());
    }
  }

  Future<void> _insertSubcategoryIfNeeded(Subcategory subcategory) async {
    final subcategoryFromDb = await (db.select(db.subcategories)
          ..where((tbl) => tbl.id.equals(subcategory.id)))
        .getSingleOrNull();
    if (subcategoryFromDb == null) {
      await insertSubcategoryFKDependencies(subcategory);
      await db.into(db.subcategories).insert(subcategory.toEntity());
    }
  }

  Future<void> _insertStoreIfNeeded(Store store) async {
    final storeFromDb =
        await (db.select(db.stores)..where((tbl) => tbl.id.equals(store.id))).getSingleOrNull();
    if (storeFromDb == null) {
      await db.into(db.stores).insert(store.toEntity());
    }
  }

  Future<void> _insertTagIfNeeded(Tag tag) async {
    final tagFromDb =
        await (db.select(db.tags)..where((tbl) => tbl.id.equals(tag.id))).getSingleOrNull();
    if (tagFromDb == null) {
      await db.into(db.tags).insert(tag.toEntity());
    }
  }

  Future<void> _insertPaymentMethodIfNeeded(PaymentMethod paymentMethod) async {
    final pmFromDb = await (db.select(db.paymentMethods)
          ..where((tbl) => tbl.id.equals(paymentMethod.id)))
        .getSingleOrNull();
    if (pmFromDb == null) {
      await db.into(db.paymentMethods).insert(paymentMethod.toEntity());
    }
  }
}
