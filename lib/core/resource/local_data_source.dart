import '/core/resource/data_state.dart';

abstract class LocalDataSource<T> {
  Future<DataState<List<T>>> fetchAll();
  Future<DataState<T>> fetchById(int id);
  Future<DataState<void>> create(T item);
  Future<DataState<void>> update(T item);
  Future<DataState<void>> delete(int id);
}
