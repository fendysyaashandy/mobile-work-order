import 'package:work_order_app/core/resource/data_state.dart';
import 'package:work_order_app/core/usecase/usecase.dart';
import 'package:work_order_app/feature/work_order/domain/entities/user_entity.dart';
import 'package:work_order_app/feature/work_order/domain/repositories/user_repository.dart';

class GetUsersUsecase
    implements UseCase<Future<DataState<List<UserEntity>>>, NoParams> {
  final UserRepository repository;

  GetUsersUsecase(this.repository);

  @override
  Future<DataState<List<UserEntity>>> call(NoParams params) {
    return repository.getUsers();
  }
}
