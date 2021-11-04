import 'package:business/fixtures.dart';
import 'package:infrastructure/src/mappers/store_mapper.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final fix = FixtureStore();

  test('Store mapper', () async {
    final model = fix.store1;
    expect(model, model.toEntity().toModel());
  });
}
