import 'package:fl_wms/screen/brand/data/brand.dart';
import 'package:fl_wms/screen/brand/data/brand_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'brand_event.dart';
part 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  BrandBloc() : super(const BrandDataState()) {
    on<PostBrand>(_postBrand);
    on<PutBrand>(_putBrand);
  }

  void _postBrand(PostBrand event, Emitter<BrandState> emit) async {
    emit(BrandLoadingState());
    try {
      await BrandApi.postBrand(event.brand);
      emit(const BrandDataState());
    } catch (e) {
      emit(BrandErrorState());
    }
  }

  void _putBrand(PutBrand event, Emitter<BrandState> emit) async {
    emit(BrandLoadingState());
    try {
      await BrandApi.putBrand(event.brand.id!, event.brand);
      emit(const BrandDataState());
    } catch (e) {
      emit(BrandErrorState());
    }
  }
}
