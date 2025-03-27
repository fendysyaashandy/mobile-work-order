import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:work_order_app/core/common/input_chip/bloc/chip_field_bloc.dart';
import 'package:work_order_app/core/resource/remote_data_source.dart';
import 'package:work_order_app/feature/work_order/data/data_source/remote/location_type_remote_data_source.dart';
import 'package:work_order_app/feature/work_order/data/data_source/remote/user_remote_data_source.dart';
import 'package:work_order_app/feature/work_order/data/data_source/remote/work_order_type_remote_data_source.dart';
import 'package:work_order_app/feature/work_order/data/repositories/location_type_repository_impl.dart';
import 'package:work_order_app/feature/work_order/data/repositories/user_repository_impl.dart';
import 'package:work_order_app/feature/work_order/data/repositories/work_order_type_repository_impl.dart';
import 'package:work_order_app/feature/work_order/domain/entities/user_entity.dart';
import 'package:work_order_app/feature/work_order/domain/repositories/location_type_repository.dart';
import 'package:work_order_app/feature/work_order/domain/repositories/user_repository.dart';
import 'package:work_order_app/feature/work_order/domain/repositories/work_order_type_repository.dart';
import 'package:work_order_app/feature/work_order/domain/usecases/location_type_usecases/get_location_type_detail_usecase.dart';
import 'package:work_order_app/feature/work_order/domain/usecases/location_type_usecases/get_location_types_usecase.dart';
import 'package:work_order_app/feature/work_order/domain/usecases/update_location_usecase.dart';
import 'package:work_order_app/feature/work_order/domain/usecases/user_usecases/get_user_detail_usecase.dart';
import 'package:work_order_app/feature/work_order/domain/usecases/user_usecases/get_users_usecase.dart';
import 'package:work_order_app/feature/work_order/domain/usecases/work_order_type_usecases/get_work_order_type_detail_usecase.dart';
import 'package:work_order_app/feature/work_order/domain/usecases/work_order_type_usecases/get_work_order_types_usecase.dart';

import '/feature/work_order/data/data_source/local/work_order_local_data_source.dart';
import '/feature/work_order/data/data_source/remote/work_order_remote_data_source.dart';
import '/feature/work_order/data/repositories/work_order_repository_impl.dart';
import '/feature/work_order/domain/repositories/work_order_repository.dart';
import '/feature/work_order/domain/usecases/get_work_orders_usecase.dart';
import '/feature/work_order/domain/usecases/create_work_order_usecase.dart';
import '/feature/work_order/domain/usecases/get_work_order_detail_usecase.dart';
import '/feature/work_order/domain/usecases/update_work_order_usecase.dart';
import '/feature/work_order/domain/usecases/delete_work_order_usecase.dart';
import '/feature/work_order/domain/usecases/get_current_location_usecase.dart';
import '/feature/work_order/domain/usecases/set_manual_location_usecase.dart';
import '/feature/work_order/domain/usecases/calculate_end_usecase.dart';
import '/feature/work_order/presentation/bloc/work_order_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  try {
    print("🔧 Memulai inisialisasi dependency...");

    // **1️⃣ External Dependencies**

    final database = await openDatabase(
      join(await getDatabasesPath(), 'work_order_database.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE work_orders (
            id INTEGER PRIMARY KEY,
            title TEXT,
            startDateTime TEXT,
            duration INTEGER,
            durationUnit TEXT,
            endDateTime TEXT,
            latitude REAL,
            longitude REAL,
            creator INTEGER,
            statusId INTEGER,
            workOrderTypeId INTEGER,
            locationTypeId INTEGER,
            requiresApproval INTEGER
          )
        ''');
      },
    );
    sl.registerLazySingleton<Database>(() => database);
    print("✅ Database terdaftar");

    // **2️⃣ Data Sources**
    sl.registerLazySingleton<WorkOrderRemoteDataSource>(
        () => WorkOrderRemoteDataSource());
    print("✅ WorkOrderRemoteDataSource terdaftar");

    sl.registerLazySingleton<WorkOrderLocalDataSource>(
        () => WorkOrderLocalDataSource(sl<Database>()));
    print("✅ WorkOrderLocalDataSource terdaftar");

    sl.registerLazySingleton<WorkOrderTypeRemoteDataSource>(
        () => WorkOrderTypeRemoteDataSource());
    print("✅ WorkOrderTypeRemoteDataSource terdaftar");

    sl.registerLazySingleton<LocationTypeRemoteDataSource>(
        () => LocationTypeRemoteDataSource());
    print("✅ LocationTypeRemoteDataSource terdaftar");

    sl.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSource());
    print("✅ UserRemoteDataSource terdaftar");

    // **3️⃣ Repository**
    sl.registerLazySingleton<WorkOrderRepository>(() => WorkOrderRepositoryImpl(
          sl<WorkOrderRemoteDataSource>(), // remoteDataSource
          sl<WorkOrderLocalDataSource>(), // localDataSource
        ));
    print("✅ WorkOrderRepository terdaftar");

    sl.registerLazySingleton<WorkOrderTypeRepository>(
        () => WorkOrderTypeRepositoryImpl(
              sl<WorkOrderTypeRemoteDataSource>(), // remoteDataSource
            ));
    print("✅ WorkOrderTypeRepository terdaftar");

    sl.registerLazySingleton<LocationTypeRepository>(
        () => LocationTypeRepositoryImpl(
              sl<LocationTypeRemoteDataSource>(), // remoteDataSource
            ));
    print("✅ LocationTypeRepository terdaftar");

    sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
          sl<UserRemoteDataSource>(), // remoteDataSource
        ));
    print("✅ UserRepository terdaftar");

    // **4️⃣ Use Cases**
    sl.registerLazySingleton(
        () => GetWorkOrdersUseCase(sl<WorkOrderRepository>()));
    sl.registerLazySingleton(
        () => CreateWorkOrderUseCase(sl<WorkOrderRepository>()));
    sl.registerLazySingleton(
        () => GetWorkOrderDetailUseCase(sl<WorkOrderRepository>()));
    sl.registerLazySingleton(
        () => UpdateWorkOrderUseCase(sl<WorkOrderRepository>()));
    sl.registerLazySingleton(
        () => DeleteWorkOrderUseCase(sl<WorkOrderRepository>()));

    //work order type
    sl.registerLazySingleton(
        () => GetWorkOrderTypesUsecase(sl<WorkOrderTypeRepository>()));
    sl.registerLazySingleton(
        () => GetWorkOrderTypeDetailUsecase(sl<WorkOrderTypeRepository>()));

    //location type
    sl.registerLazySingleton(
        () => GetLocationTypesUsecase(sl<LocationTypeRepository>()));
    sl.registerLazySingleton(
        () => GetLocationTypeDetailUsecase(sl<LocationTypeRepository>()));

    //user
    sl.registerLazySingleton(() => GetUsersUsecase(sl<UserRepository>()));
    sl.registerLazySingleton(() => GetUserDetailUsecase(sl<UserRepository>()));

    // sl.registerLazySingleton(
    //     () => UpdateLocationUseCase(sl<WorkOrderRepository>()));
    // sl.registerLazySingleton(
    //     () => GetCurrentLocationUseCase(sl<WorkOrderRepository>()));
    // sl.registerLazySingleton(() => CalculateEndDateTime());
    print("✅ Semua use case terdaftar");

    // **5️⃣ Bloc**
    sl.registerFactory(() => WorkOrderBloc(
          sl<GetWorkOrdersUseCase>(),
          sl<GetWorkOrderDetailUseCase>(),
          sl<CreateWorkOrderUseCase>(),
          sl<UpdateWorkOrderUseCase>(),
          sl<DeleteWorkOrderUseCase>(),

          //work order type
          sl<GetWorkOrderTypesUsecase>(),
          sl<GetWorkOrderTypeDetailUsecase>(),

          //location type
          sl<GetLocationTypesUsecase>(),
          sl<GetLocationTypeDetailUsecase>(),

          //user
          sl<GetUsersUsecase>(),
          sl<GetUserDetailUsecase>(),

          // sl<UpdateLocationUseCase>(),
          // sl<GetCurrentLocationUseCase>(),
          // sl<CalculateEndDateTime>(),
        ));
    print("✅ WorkOrderBloc terdaftar");

    // Register ChipFieldBloc
    sl.registerFactory(() => ChipFieldBloc());
    print("✅ ChipFieldBloc terdaftar");

    print("🎉 Semua dependency berhasil diinisialisasi!");
  } catch (e, stacktrace) {
    print("❌ Gagal menginisialisasi dependency: $e");
    print(stacktrace);
  }
}
