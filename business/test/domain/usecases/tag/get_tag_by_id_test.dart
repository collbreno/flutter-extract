import 'package:business/src/core/_core.dart';
import 'package:business/src/domain/_domain.dart';
import 'package:business/src/domain/usecases/tag/_tag.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/fixture_tag.dart';
import '_mock.mocks.dart';

void main() {
  final fix = FixtureTag();
  late ITagRepository repository;
  late GetTagById useCase;

  setUp(() {
    repository = MockITagRepository();
    useCase = GetTagById(repository);
  });

  test('should get the tag from repository', () async {
    final expected = fix.tag1;

    when(repository.getTagById(expected.id)).thenAnswer((_) async => Right(expected));

    final result = await useCase(expected.id);

    expect(result, Right(expected));

    verify(repository.getTagById(expected.id));
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final id = 'test';
    final failure = UnknownDatabaseFailure();

    when(repository.getTagById(id)).thenAnswer((_) async => Left(failure));

    final result = await useCase(id);

    expect(result, Left(failure));

    verify(repository.getTagById(id));
    verifyNoMoreInteractions(repository);
  });
}
