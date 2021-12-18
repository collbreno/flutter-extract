import 'package:business/business.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([], customMocks: [
  MockSpec<StreamUseCase<Category, String>>(as: #MockWatchCategoryUseCase),
])
void main() {}
