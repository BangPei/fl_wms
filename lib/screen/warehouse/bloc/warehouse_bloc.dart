import 'package:fl_wms/screen/warehouse/data/warehouse.dart';
import 'package:fl_wms/screen/warehouse/data/warehouse_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'warehouse_event.dart';
part 'warehouse_state.dart';

class WarehouseBloc extends Bloc<WarehouseEvent, WarehouseState> {
  WarehouseBloc() : super(const WarehouseDataState()) {
    on<PostWarehouse>(_postWarehouse);
    on<PutWarehouse>(_putWarehouse);
  }

  void _postWarehouse(PostWarehouse event, Emitter<WarehouseState> emit) async {
    emit(WarehouseLoadingState());
    try {
      await WarehouseApi.postWarehouse(event.warehouse);
      emit(const WarehouseDataState());
    } catch (e) {
      emit(WarehouseErrorState());
    }
  }

  void _putWarehouse(PutWarehouse event, Emitter<WarehouseState> emit) async {
    emit(WarehouseLoadingState());
    try {
      await WarehouseApi.putWarehouse(event.warehouse.id!, event.warehouse);
      emit(const WarehouseDataState());
    } catch (e) {
      emit(WarehouseErrorState());
    }
  }
}
