import 'package:fl_wms/models/datatable_model.dart';
import 'package:fl_wms/screen/brand/data/brand.dart';
import 'package:fl_wms/screen/brand/data/brand_api.dart';
import 'package:fl_wms/service/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'brand_event.dart';
part 'brand_state.dart';

int _draw = 0;

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  BrandBloc() : super(BrandLoadingState()) {
    on<GetBrandDataTable>(_getBrandDataTable);
    on<GetBrandDataTableExtend>(_getBrandDataTableExtend);
    on<GetBrands>(_getBrands);
    on<PostBrand>(_postBrand);
    on<PutBrand>(_putBrand);
  }

  void _getBrandDataTableExtend(
      GetBrandDataTableExtend event, Emitter<BrandState> emit) async {
    try {
      _draw = _draw + 1;
      DataTableModel dataTable = await Api.getBrandDataTable(
        "/api/brand/dataTable",
        start: event.start,
        length: event.length,
        draw: _draw,
        searchText: event.searchText,
      );
      List<Brand> brands =
          (dataTable.data ?? []).map((e) => Brand.fromJson(e)).toList();
      emit(BrandDataState(brands, dataTable: dataTable));
    } catch (e) {
      emit(BrandErrorState());
    }
  }

  void _getBrandDataTable(
      GetBrandDataTable event, Emitter<BrandState> emit) async {
    emit(BrandLoadingState());
    try {
      _draw = _draw + 1;
      DataTableModel dataTable = await Api.getBrandDataTable(
        "/api/brand/dataTable",
        start: event.start,
        length: event.length,
        draw: _draw,
        searchText: event.searchText,
      );
      List<Brand> brands =
          (dataTable.data ?? []).map((e) => Brand.fromJson(e)).toList();
      emit(BrandDataState(brands, dataTable: dataTable));
    } catch (e) {
      emit(BrandErrorState());
    }
  }

  void _getBrands(GetBrands event, Emitter<BrandState> emit) async {
    emit(BrandLoadingState());
    try {
      List<Brand> brands = await BrandApi.getBrands();
      emit(BrandDataState(brands));
    } catch (e) {
      emit(BrandErrorState());
    }
  }

  void _postBrand(PostBrand event, Emitter<BrandState> emit) async {
    // emit(BrandLoadingState());
    try {
      await BrandApi.postBrand(event.brand);
      List<Brand> brands = await BrandApi.getBrands();
      emit(BrandDataState(brands));
    } catch (e) {
      emit(BrandErrorState());
    }
  }

  void _putBrand(PutBrand event, Emitter<BrandState> emit) async {
    // emit(BrandLoadingState());
    try {
      await BrandApi.putBrand(event.brand.id!, event.brand);
      List<Brand> brands = await BrandApi.getBrands();
      emit(BrandDataState(brands));
    } catch (e) {
      emit(BrandErrorState());
    }
  }
}
