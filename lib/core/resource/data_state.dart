abstract class DataState<T> {
  final T? data;
  final dynamic error;

  const DataState({this.data, this.error});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(dynamic error) : super(error: error);
}

class PaginatedDataSuccess<T> extends DataSuccess<T> {
  final int totalPages;
  final int currentPage;

  const PaginatedDataSuccess(T data,
      {required this.totalPages, required this.currentPage})
      : super(data);
}
