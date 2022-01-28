import 'package:business/business.dart';
import 'package:mockito/annotations.dart';
import 'package:uuid/uuid.dart';

@GenerateMocks([
  Uuid
], customMocks: [
  MockSpec<StreamUseCase<Category, String>>(as: #MockWatchCategoryUseCase),
  MockSpec<NoParamStreamUseCase<List<Category>>>(as: #MockWatchCategoriesUseCase),
  MockSpec<FutureUseCase<void, String>>(as: #MockDeleteCategoryUseCase),
  MockSpec<FutureUseCase<void, Tag>>(as: #MockInsertTagUseCase),
  MockSpec<FutureUseCase<void, Tag>>(as: #MockUpdateTagUseCase),
])
void main() {}
