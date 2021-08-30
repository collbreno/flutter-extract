import 'package:business/fixtures.dart';
import 'package:infrastructure/src/mappers/expense_mapper.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final fix = FixtureExpense();

  test('Expense mapper', () async {
    final model = fix.expense1;
    expect(
      model,
      model.toEntity().toModel(
            files: model.files,
            paymentMethod: model.paymentMethod,
            store: model.store,
            subcategory: model.subcategory,
            tags: model.tags,
          ),
    );
  });
}
