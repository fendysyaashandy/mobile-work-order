import 'package:work_order_app/core/resource/data_state.dart';
import 'package:work_order_app/feature/work_order/data/data_source/remote/user_remote_data_source.dart';
import 'package:work_order_app/feature/work_order/data/models/user_model.dart';
import 'package:work_order_app/feature/work_order/domain/entities/user_entity.dart';
import 'package:work_order_app/feature/work_order/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<DataState<List<UserEntity>>> getUsers() async {
    try {
      // Panggil data dari remote data source
      final response = await remoteDataSource.fetchUsers();
      print("UserRepository - Fetched Users: ${response}");
      if (response is DataSuccess<List<UserModel>>) {
        final entities =
            response.data!.map((model) => model.toEntity()).toList();
        return DataSuccess(entities);
      } else {
        return DataFailed(response.error!);
      }
    } catch (e) {
      return DataFailed("Terjadi kesalahan: $e");
    }
  }

  @override
  Future<DataState<UserEntity>> getUserDetail(int id) async {
    final response = await remoteDataSource.fetchUserDetail(id);
    if (response is DataSuccess<UserModel>) {
      return DataSuccess(response.data!.toEntity());
    } else {
      return DataFailed(response.error!);
    }
  }
}
