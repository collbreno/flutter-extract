part of 'new_category_cubit.dart';

@immutable
abstract class NewCategoryState extends Equatable {}

class NewCategoryInitial extends NewCategoryState {
  @override
  List<Object?> get props => [];
}

class NewCategoryLoading extends NewCategoryState {
  @override
  List<Object?> get props => [];
}

class NewCategoryError extends NewCategoryState {
  final Failure error;

  NewCategoryError(this.error);

  @override
  List<Object?> get props => [error];
}
