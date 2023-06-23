import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'palette_event.dart';
part 'palette_state.dart';

class PaletteBloc extends Bloc<PaletteEvent, PaletteState> {
  PaletteBloc() : super(PaletteInitial()) {
    on<PaletteEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
