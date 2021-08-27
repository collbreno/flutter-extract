// TODO: Implement expense filter
import 'package:business/business.dart';
import 'package:equatable/equatable.dart';

class ExpenseFilter extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  final Store? store;
  final Category? category;
  final Subcategory? subcategory;
  final int? minValue;
  final int? maxValue;
  final String? searchQuery;

  ExpenseFilter({
    DateTime? startDate,
    DateTime? endDate,
    this.store,
    this.category,
    this.subcategory,
    this.minValue,
    this.maxValue,
    this.searchQuery,
  })  : startDate = startDate?.toDate(),
        endDate = endDate?.toDate();

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        store,
        category,
        subcategory,
        minValue,
        maxValue,
        searchQuery,
      ];
}
