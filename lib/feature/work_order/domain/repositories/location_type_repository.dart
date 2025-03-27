import 'package:work_order_app/core/resource/data_state.dart';
import 'package:work_order_app/feature/work_order/domain/entities/location_type_entity.dart';

abstract class LocationTypeRepository {
  Future<DataState<List<LocationTypeEntity>>> getLocationTypes();
  Future<DataState<LocationTypeEntity>> getLocationTypeDetail(int id);
}
