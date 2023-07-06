import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'rack_event.dart';
part 'rack_state.dart';

class RackBloc extends Bloc<RackEvent, RackState> {
  RackBloc() : super(RackInitial()) {
    on<RackEvent>((event, emit) {});
  }
}
