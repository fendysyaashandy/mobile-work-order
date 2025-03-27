import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_app/core/usecase/usecase.dart';
import 'package:work_order_app/feature/work_order/domain/entities/work_order_entity.dart';
import 'package:work_order_app/feature/work_order/domain/usecases/location_type_usecases/get_location_type_detail_usecase.dart';
import 'package:work_order_app/feature/work_order/domain/usecases/location_type_usecases/get_location_types_usecase.dart';
import 'package:work_order_app/feature/work_order/domain/usecases/user_usecases/get_user_detail_usecase.dart';
import 'package:work_order_app/feature/work_order/domain/usecases/user_usecases/get_users_usecase.dart';
import 'package:work_order_app/feature/work_order/domain/usecases/work_order_type_usecases/get_work_order_type_detail_usecase.dart';
import 'package:work_order_app/feature/work_order/domain/usecases/work_order_type_usecases/get_work_order_types_usecase.dart';
import '/feature/work_order/domain/usecases/get_work_orders_usecase.dart';
import '/feature/work_order/domain/usecases/get_work_order_detail_usecase.dart';
import '/feature/work_order/domain/usecases/create_work_order_usecase.dart';
import '/feature/work_order/domain/usecases/update_work_order_usecase.dart';
import '/feature/work_order/domain/usecases/delete_work_order_usecase.dart';
import '/core/resource/data_state.dart';
import 'work_order_event.dart';
import 'work_order_state.dart';

class WorkOrderBloc extends Bloc<WorkOrderEvent, WorkOrderState> {
  int currentPage = 1;
  int totalPages = 1;
  bool isFetching = false;

  final GetWorkOrdersUseCase getWorkOrdersUseCase;
  final GetWorkOrderDetailUseCase getWorkOrderDetailUseCase;
  final CreateWorkOrderUseCase createWorkOrderUseCase;
  final UpdateWorkOrderUseCase updateWorkOrderUseCase;
  final DeleteWorkOrderUseCase deleteWorkOrderUseCase;

  //work order type
  final GetWorkOrderTypesUsecase getWorkOrderTypesUsecase;
  final GetWorkOrderTypeDetailUsecase getWorkOrderTypeDetailUsecase;

  //location type
  final GetLocationTypesUsecase getLocationTypesUsecase;
  final GetLocationTypeDetailUsecase getLocationTypeDetailUsecase;

  //user
  final GetUsersUsecase getUsersUsecase;
  final GetUserDetailUsecase getUserDetailUsecase;

  // final UpdateLocationUseCase updateLocationUseCase;
  // final GetCurrentLocationUseCase getCurrentLocationUseCase;
  // final SetManualLocationUseCase setManualLocationUseCase;
  // final CalculateEndDateTime calculateEndDateTime;

  WorkOrderBloc(
    this.getWorkOrdersUseCase,
    this.getWorkOrderDetailUseCase,
    this.createWorkOrderUseCase,
    this.updateWorkOrderUseCase,
    this.deleteWorkOrderUseCase,

    //work order type
    this.getWorkOrderTypesUsecase,
    this.getWorkOrderTypeDetailUsecase,

    //location type
    this.getLocationTypesUsecase,
    this.getLocationTypeDetailUsecase,

    //user
    this.getUsersUsecase,
    this.getUserDetailUsecase,

    // this.updateLocationUseCase,
    // this.getCurrentLocationUseCase,
    // this.setManualLocationUseCase,
    // this.calculateEndDateTime,
  ) : super(WorkOrderInitial()) {
    on<GetWorkOrdersEvent>(_onGetWorkOrdersEvent);
    on<LoadMoreWorkOrdersEvent>(_onLoadMoreWorkOrdersEvent);
    on<GetWorkOrderDetailEvent>(_onGetWorkOrderDetailEvent);
    on<CreateWorkOrderEvent>(_onCreateWorkOrderEvent);
    on<UpdateWorkOrderEvent>(_onUpdateWorkOrderEvent);
    on<DeleteWorkOrderEvent>(_onDeleteWorkOrderEvent);

    //work order type
    on<GetWorkOrderTypesEvent>(_onGetWorkOrderTypesEvent);
    on<GetWorkOrderTypeDetailEvent>(_onGetWorkOrderTypeDetailEvent);

    //location type
    on<GetLocationTypesEvent>(_onGetLocationTypesEvent);
    on<GetLocationTypeDetailEvent>(_onGetLocationTypeDetailEvent);

    //user
    on<GetUsersEvent>(_onGetUsersEvent);
    on<GetUserDetailEvent>(_onGetUserDetailEvent);

    // on<UpdateLocationEvent>(_onUpdateLocationEvent);
    // on<GetCurrentLocationEvent>(_onGetCurrentLocationEvent);
    // on<SetManualLocationEvent>(_onSetManualLocationEvent);
    // on<CalculateEndDateTimeEvent>(_onCalculateEndDateTimeEvent);
  }

  Future<void> _onGetWorkOrdersEvent(
      GetWorkOrdersEvent event, Emitter<WorkOrderState> emit) async {
    emit(WorkOrderLoading());
    print("🟡 Memuat data Work Order...");
    try {
      currentPage = 1;
      final dataState = await getWorkOrdersUseCase(
          WorkOrderParams(page: currentPage, limit: 20));
      if (dataState is PaginatedDataSuccess<List<WorkOrderEntity>>) {
        print("📥 Data yang diterima sebelum parsing: ${dataState.data}");
        print("✅ Data Work Order berhasil dimuat: ${dataState.data!.length}");

        if (dataState.data!.isEmpty) {
          print("❌ Data berhasil diambil tetapi kosong setelah parsing!");
        }
        totalPages = dataState.totalPages;
        emit(WorkOrderLoaded(dataState.data!));
      } else if (dataState is DataFailed) {
        print("❌ Gagal memuat Work Order: ${dataState.error}");
        emit(WorkOrderError(dataState.error.toString()));
      }
    } catch (e) {
      print("❌ Error saat mengambil Work Order: $e");
      emit(WorkOrderError("Terjadi kesalahan saat mengambil data: $e"));
    }
  }

  Future<void> _onLoadMoreWorkOrdersEvent(
      LoadMoreWorkOrdersEvent event, Emitter<WorkOrderState> emit) async {
    if (currentPage >= totalPages || isFetching) return;
    isFetching = true;
    currentPage++;

    final dataState = await getWorkOrdersUseCase(
        WorkOrderParams(page: currentPage, limit: event.limit));

    if (dataState is PaginatedDataSuccess) {
      final updatedList =
          List<WorkOrderEntity>.from((state as WorkOrderLoaded).workOrders)
            ..addAll(dataState.data!);
      emit(WorkOrderLoaded(updatedList));
    }
    isFetching = false;
  }

  Future<void> _onGetWorkOrderDetailEvent(
      GetWorkOrderDetailEvent event, Emitter<WorkOrderState> emit) async {
    emit(WorkOrderLoading());
    try {
      final dataState = await getWorkOrderDetailUseCase(event.id);
      if (dataState is DataSuccess) {
        emit(WorkOrderDetailLoaded(dataState.data!));
      } else if (dataState is DataFailed) {
        emit(WorkOrderError(dataState.error.toString()));
      }
    } catch (e) {
      emit(WorkOrderError(
          "Terjadi kesalahan saat mengambil detail pekerjaan: $e"));
    }
  }

  Future<void> _onCreateWorkOrderEvent(
      CreateWorkOrderEvent event, Emitter<WorkOrderState> emit) async {
    emit(WorkOrderLoading());
    try {
      final dataState = await createWorkOrderUseCase(event.workOrder);
      if (dataState is DataSuccess) {
        emit(WorkOrderCreated(dataState.data!));
      } else if (dataState is DataFailed) {
        emit(WorkOrderError(dataState.error.toString()));
      }
    } catch (e) {
      emit(WorkOrderError("Gagal membuat pekerjaan: $e"));
    }
  }

  Future<void> _onUpdateWorkOrderEvent(
      UpdateWorkOrderEvent event, Emitter<WorkOrderState> emit) async {
    emit(WorkOrderLoading());
    try {
      final dataState = await updateWorkOrderUseCase(event.workOrder);
      if (dataState is DataSuccess) {
        emit(WorkOrderUpdated(dataState.data!));
      } else if (dataState is DataFailed) {
        emit(WorkOrderError(dataState.error.toString()));
      }
    } catch (e) {
      emit(WorkOrderError("Gagal memperbarui pekerjaan: $e"));
    }
  }

  Future<void> _onDeleteWorkOrderEvent(
      DeleteWorkOrderEvent event, Emitter<WorkOrderState> emit) async {
    emit(WorkOrderLoading());
    try {
      final dataState = await deleteWorkOrderUseCase(event.id);
      if (dataState is DataSuccess) {
        emit(WorkOrderDeleted());
      } else if (dataState is DataFailed) {
        emit(WorkOrderError(dataState.error.toString()));
      }
    } catch (e) {
      emit(WorkOrderError("Gagal menghapus pekerjaan: $e"));
    }
  }

  //work order type
  Future<void> _onGetWorkOrderTypesEvent(
      GetWorkOrderTypesEvent event, Emitter<WorkOrderState> emit) async {
    emit(WorkOrderLoading());
    try {
      final dataState = await getWorkOrderTypesUsecase(const NoParams());
      if (dataState is DataSuccess) {
        emit(WorkOrderTypesLoaded(dataState.data!));
      } else if (dataState is DataFailed) {
        emit(WorkOrderError(dataState.error.toString()));
      }
    } catch (e) {
      emit(WorkOrderError("Gagal mengambil tipe pekerjaan: $e"));
    }
  }

  Future<void> _onGetWorkOrderTypeDetailEvent(
      GetWorkOrderTypeDetailEvent event, Emitter<WorkOrderState> emit) async {
    emit(WorkOrderLoading());
    try {
      final dataState = await getWorkOrderTypeDetailUsecase(event.id);
      if (dataState is DataSuccess) {
        emit(WorkOrderTypeDetailLoaded(dataState.data!));
      } else if (dataState is DataFailed) {
        emit(WorkOrderError(dataState.error.toString()));
      }
    } catch (e) {
      emit(WorkOrderError("Gagal mengambil detail tipe pekerjaan: $e"));
    }
  }

  //location type
  Future<void> _onGetLocationTypesEvent(
      GetLocationTypesEvent event, Emitter<WorkOrderState> emit) async {
    emit(WorkOrderLoading());
    try {
      final dataState = await getLocationTypesUsecase(const NoParams());
      if (dataState is DataSuccess) {
        emit(LocationTypesLoaded(dataState.data!));
      } else if (dataState is DataFailed) {
        emit(WorkOrderError(dataState.error.toString()));
      }
    } catch (e) {
      emit(WorkOrderError("Gagal mengambil tipe lokasi: $e"));
    }
  }

  Future<void> _onGetLocationTypeDetailEvent(
      GetLocationTypeDetailEvent event, Emitter<WorkOrderState> emit) async {
    emit(WorkOrderLoading());
    try {
      final dataState = await getLocationTypeDetailUsecase(event.id);
      if (dataState is DataSuccess) {
        emit(LocationTypeDetailLoaded(dataState.data!));
      } else if (dataState is DataFailed) {
        emit(WorkOrderError(dataState.error.toString()));
      }
    } catch (e) {
      emit(WorkOrderError("Gagal mengambil detail tipe lokasi: $e"));
    }
  }

  //user
  Future<void> _onGetUsersEvent(
      GetUsersEvent event, Emitter<WorkOrderState> emit) async {
    emit(WorkOrderLoading());
    try {
      final dataState = await getUsersUsecase(const NoParams());
      print("UserBloc - Loaded Users: ${dataState}");
      if (dataState is DataSuccess) {
        emit(UsersLoaded(dataState.data!));
      } else if (dataState is DataFailed) {
        emit(WorkOrderError(dataState.error.toString()));
      }
    } catch (e) {
      emit(WorkOrderError("Gagal mengambil pengguna: $e"));
    }
  }

  Future<void> _onGetUserDetailEvent(
      GetUserDetailEvent event, Emitter<WorkOrderState> emit) async {
    emit(WorkOrderLoading());
    try {
      final dataState = await getUserDetailUsecase(event.id);
      if (dataState is DataSuccess) {
        emit(UserDetailLoaded(dataState.data!));
      } else if (dataState is DataFailed) {
        emit(WorkOrderError(dataState.error.toString()));
      }
    } catch (e) {
      emit(WorkOrderError("Gagal mengambil detail pengguna: $e"));
    }
  }
}
