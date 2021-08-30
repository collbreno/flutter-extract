import 'package:business/fixtures.dart';
import 'package:infrastructure/src/mappers/tag_mapper.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final fix = FixtureTag();

  test('Tag mapper', () async {
    final model = fix.tag1;
    expect(model, model.toEntity().toModel());
  });
}
