import 'package:business/fixtures.dart';
import 'package:infrastructure/src/mappers/subcategory_mapper.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final fix = FixtureSubcategory();

  test('Subcategory mapper', () async {
    final model = fix.subcategory1;
    expect(model, model.toEntity().toModel(parent: model.parent));
  });
}
