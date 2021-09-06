import 'package:business/business.dart';
import 'package:dartz/dartz.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:infrastructure/src/mappers/_mappers.dart';
import 'package:moor/moor.dart';

class ExpenseRepository implements IExpenseRepository {
  final AppDatabase db;

  ExpenseRepository(this.db);

  @override
  Future<FailureOr<void>> deleteExpenseWithId(String id) {
    // TODO: implement deleteExpenseWithId
    throw UnimplementedError();
  }

  @override
  Future<FailureOr<List<Expense>>> getAllExpenses({ExpenseFilter? filter}) async {
    try {
      final expenses = await db.select(db.expenses).join([
        innerJoin(db.subcategories, db.subcategories.id.equalsExp(db.expenses.subcategoryId)),
        innerJoin(db.categories, db.categories.id.equalsExp(db.subcategories.parentId)),
        innerJoin(db.paymentMethods, db.paymentMethods.id.equalsExp(db.expenses.paymentMethodId)),
        leftOuterJoin(db.stores, db.stores.id.equalsExp(db.expenses.storeId)),
      ]).get();

      if (expenses.isEmpty) {
        return Left(NotFoundFailure());
      }

      final expenseIds = expenses.map((e) => e.read(db.expenses.id));

      final tags = await (db
              .select(db.expenseTags)
              .join([innerJoin(db.tags, db.tags.id.equalsExp(db.expenseTags.tagId))])
                ..where(db.expenseTags.expenseId.isIn(expenseIds)))
          .get();
      final expenseIdToTags = <String, List<Tag>>{};
      for (var row in tags) {
        final tag = row.readTable(db.tags);
        final id = row.read(db.expenseTags.expenseId)!;
        expenseIdToTags.putIfAbsent(id, () => []).add(tag.toModel());
      }

      final files =
          await (db.select(db.expenseFiles)..where((tbl) => tbl.expenseId.isIn(expenseIds))).get();
      final expenseIdToFiles = <String, List<String>>{};
      for (var row in files) {
        final file = row.filePath;
        final id = row.expenseId;
        expenseIdToFiles.putIfAbsent(id, () => []).add(file);
      }

      return Right(
        expenses.map((row) {
          final expense = row.readTable(db.expenses);
          return expense.toModel(
            subcategory: row.readTable(db.subcategories).toModel(
                  parent: row.readTable(db.categories).toModel(),
                ),
            paymentMethod: row.readTable(db.paymentMethods).toModel(),
            store: row.readTable(db.stores).toModel(),
            tags: expenseIdToTags[expense.id] ?? [],
            files: expenseIdToFiles[expense.id] ?? [],
          );
        }).toList(),
      );
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<Expense>> getExpenseById(String id) {
    // TODO: implement getExpenseById
    throw UnimplementedError();
  }

  @override
  Future<FailureOr<int>> getTotalSpent({ExpenseFilter? filter}) {
    // TODO: implement getTotalSpent
    throw UnimplementedError();
  }

  @override
  Future<FailureOr<void>> insertExpense(Expense expense) async {
    try {
      await db.into(db.expenses).insert(expense.toEntity());
      await Future.wait([
        for (var file in expense.files)
          db.into(db.expenseFiles).insert(
                ExpenseFileEntity(
                  expenseId: expense.id,
                  filePath: file,
                  createdAt: expense.createdAt,
                ),
              )
      ]);
      await Future.wait([
        for (var tag in expense.tags)
          db.into(db.expenseTags).insert(
                ExpenseTagEntity(
                  expenseId: expense.id,
                  tagId: tag.id,
                  createdAt: expense.createdAt,
                ),
              )
      ]);
      return Right(Null);
    } on Exception {
      return Left(UnknownDatabaseFailure());
    }
  }

  @override
  Future<FailureOr<bool>> updateExpense(Expense expense) {
    // TODO: implement updateExpense
    throw UnimplementedError();
  }
}
