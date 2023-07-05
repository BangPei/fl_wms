import 'package:fl_wms/screen/uom/data/uom.dart';
import 'package:fl_wms/screen/uom/data/uom_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'uom_event.dart';
part 'uom_state.dart';

class UomBloc extends Bloc<UomEvent, UomState> {
  UomBloc() : super(const UomDataState()) {
    on<PostUom>(_postUom);
    on<PutUom>(_putUom);
  }

  void _postUom(PostUom event, Emitter<UomState> emit) async {
    emit(UomLoadingState());
    try {
      await UomApi.postUom(event.uom);
      emit(const UomDataState());
    } catch (e) {
      emit(UomErrorState());
    }
  }

  void _putUom(PutUom event, Emitter<UomState> emit) async {
    emit(UomLoadingState());
    try {
      await UomApi.putUom(event.uom.id!, event.uom);
      emit(const UomDataState());
    } catch (e) {
      emit(UomErrorState());
    }
  }
}
