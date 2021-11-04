import 'package:business/fixtures.dart';
import 'package:infrastructure/src/mappers/category_mapper.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final fix = FixtureCategory();

  test('Category mapper', () async {
    final model = fix.category1;
    expect(model, model.toEntity().toModel());
  });
}
