import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'warehouse_event.dart';
part 'warehouse_state.dart';

class WarehouseBloc extends Bloc<WarehouseEvent, WarehouseState> {
  WarehouseBloc() : super(WarehouseInitial()) {
    on<WarehouseEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
