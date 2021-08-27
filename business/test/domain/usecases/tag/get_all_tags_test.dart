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
  late GetAllTags useCase;

  setUp(() {
    repository = MockITagRepository();
    useCase = GetAllTags(repository);
  });

  test('should get all tags from repository', () async {
    final expected = [fix.tag1, fix.tag2];

    when(repository.getAllTags()).thenAnswer((_) async => Right(expected));

    final result = await useCase();

    expect(result, Right(expected));

    verify(repository.getAllTags());
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final failure = UnknownDatabaseFailure();

    when(repository.getAllTags()).thenAnswer((_) async => Left(failure));

    final result = await useCase();

    expect(result, Left(failure));

    verify(repository.getAllTags());
    verifyNoMoreInteractions(repository);
  });
}
