import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'uom_event.dart';
part 'uom_state.dart';

class UomBloc extends Bloc<UomEvent, UomState> {
  UomBloc() : super(UomInitial()) {
    on<UomEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
