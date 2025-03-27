import 'package:dio/dio.dart';
import 'package:work_order_app/core/resource/data_state.dart';
import 'package:work_order_app/core/resource/remote_data_source.dart';
import 'package:work_order_app/feature/work_order/data/models/user_model.dart';

class UserRemoteDataSource extends RemoteDatasource {
  UserRemoteDataSource() : super();

  Future<DataState<List<UserModel>>> fetchUsers() async {
    try {
      final response = await dio.get('/user');
      final data = response.data
          .map<UserModel>((json) => UserModel.fromMap(json))
          .toList();
      return DataSuccess(data);
    } catch (e) {
      return DataFailed(DioException(
        error: e,
        requestOptions: RequestOptions(path: '/user'),
      ));
    }
  }

  Future<DataState<UserModel>> fetchUserDetail(int id) async {
    try {
      final response = await dio.get('/user/$id');
      final data = UserModel.fromMap(response.data);
      return DataSuccess(data);
    } catch (e) {
      return DataFailed(DioException(
        error: e,
        requestOptions: RequestOptions(path: '/user/$id'),
      ));
    }
  }
}
