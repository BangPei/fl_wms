import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'rack_event.dart';
part 'rack_state.dart';

class RackBloc extends Bloc<RackEvent, RackState> {
  RackBloc() : super(RackInitial()) {
    on<RackEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
