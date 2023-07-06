part of 'warehouse_bloc.dart';

@immutable
abstract class WarehouseEvent {
  const WarehouseEvent();
}

class GetWarehouses extends WarehouseEvent {
  const GetWarehouses();
}

class GetWarehouseById extends WarehouseEvent {
  final int id;
  const GetWarehouseById(this.id);
}

class PostWarehouse extends WarehouseEvent {
  final Warehouse warehouse;
  const PostWarehouse(this.warehouse);
}

class PutWarehouse extends WarehouseEvent {
  final Warehouse warehouse;
  const PutWarehouse(this.warehouse);
}
