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
  late UpdateTag useCase;

  setUp(() {
    repository = MockITagRepository();
    useCase = UpdateTag(repository);
  });

  test('should get the tag from repository', () async {
    final expected = fix.tag1;

    when(repository.updateTag(expected)).thenAnswer((_) async => Right(true));

    final result = await useCase(expected);

    expect(result, Right(true));

    verify(repository.updateTag(expected));
    verifyNoMoreInteractions(repository);
  });

  test('should return database failure when repository fails', () async {
    final failure = UnknownDatabaseFailure();

    when(repository.updateTag(fix.tag1)).thenAnswer((_) async => Left(failure));

    final result = await useCase(fix.tag1);

    expect(result, Left(failure));

    verify(repository.updateTag(fix.tag1));
    verifyNoMoreInteractions(repository);
  });
}
