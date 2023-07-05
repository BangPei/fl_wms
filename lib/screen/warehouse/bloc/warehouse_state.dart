part of 'warehouse_bloc.dart';

@immutable
abstract class WarehouseState {
  const WarehouseState();
}

class WarehouseLoadingState extends WarehouseState {
  List<Object?> get props => [];
}

class WarehouseErrorState extends WarehouseState {
  List<Object?> get props => [];
}

class WarehouseDataState extends WarehouseState {
  const WarehouseDataState();
  List<Object?> get props => [];
}
