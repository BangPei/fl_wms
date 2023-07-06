import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'palette_event.dart';
part 'palette_state.dart';

class PaletteBloc extends Bloc<PaletteEvent, PaletteState> {
  PaletteBloc() : super(PaletteInitial()) {
    on<PaletteEvent>((event, emit) {});
  }
}
