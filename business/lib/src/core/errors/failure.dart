import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

abstract class DatabaseFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class UnknownDatabaseFailure extends DatabaseFailure {}

class NotFoundFailure extends DatabaseFailure {}

class EntityBeingUsedFailure extends DatabaseFailure {
  final int usages;

  EntityBeingUsedFailure(this.usages);

  @override
  List<Object?> get props => [usages];
}

class EntityDependencyFailure extends DatabaseFailure {}

class NothingToDeleteFailure extends DatabaseFailure {}
