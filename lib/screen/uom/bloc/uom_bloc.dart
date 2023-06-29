import 'package:fl_wms/screen/uom/data/uom_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/uom.dart';

part 'uom_event.dart';
part 'uom_state.dart';

class UomBloc extends Bloc<UomEvent, UomState> {
  UomBloc() : super(UomLoadingState()) {
    on<GetUoms>(_getUoms);
    on<PostUom>(_postUom);
    on<PutUom>(_putUom);
  }

  void _getUoms(GetUoms event, Emitter<UomState> emit) async {
    emit(UomLoadingState());
    try {
      List<Uom> uoms = await UomApi.getUoms();
      emit(UomDataState(uoms));
    } catch (e) {
      emit(UomErrorState());
    }
  }

  void _postUom(PostUom event, Emitter<UomState> emit) async {
    // emit(BrandLoadingState());
    try {
      await UomApi.postUom(event.uom);
      List<Uom> uoms = await UomApi.getUoms();
      emit(UomDataState(uoms));
    } catch (e) {
      emit(UomErrorState());
    }
  }

  void _putUom(PutUom event, Emitter<UomState> emit) async {
    // emit(BrandLoadingState());
    try {
      await UomApi.putUom(event.uom.id!, event.uom);
      List<Uom> uoms = await UomApi.getUoms();
      emit(UomDataState(uoms));
    } catch (e) {
      emit(UomErrorState());
    }
  }
}
