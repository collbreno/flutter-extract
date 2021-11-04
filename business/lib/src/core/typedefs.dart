import 'package:business/src/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

typedef FailureOr<T> = Either<Failure, T>;
