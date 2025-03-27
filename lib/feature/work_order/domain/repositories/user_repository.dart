import 'package:work_order_app/core/resource/data_state.dart';
import 'package:work_order_app/feature/work_order/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<DataState<List<UserEntity>>> getUsers();
  Future<DataState<UserEntity>> getUserDetail(int id);
}
