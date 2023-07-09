import 'package:fl_wms/models/datatable_model.dart';
import 'package:fl_wms/screen/product/data/product.dart';
import 'package:fl_wms/screen/product/data/product_api.dart';
import 'package:fl_wms/service/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_event.dart';
part 'product_state.dart';

Map<String, dynamic> query = {};
int _draw = 0;
List<String> columns = ['code', 'name', 'brand', 'category', 'updated_at'];

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductLoadingState()) {
    on<PostProduct>(_postProduct);
    on<GetDataTable>(_getDataTable);
    on<PutProduct>(_putProduct);
  }

  void _getDataTable(GetDataTable event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState());
    try {
      _draw = _draw + 1;
      query['draw'] = _draw.toString();
      query['start'] = event.start.toString();
      query['length'] = event.length.toString();
      query['search[value]'] = event.search;
      query["order[0][column]"] = event.orderColumn.toString();
      query["order[0][dir]"] = event.orderDir;
      for (var i = 0; i < columns.length; i++) {
        String str = columns[i];
        query["columns[$i][data]"] = str;
        query["columns[$i][searchable]"] = "true";
        query["columns[$i][orderable]"] = "true";
        query["columns[$i][search][regex]"] = "false";
      }
      DataTableModel _dataTable =
          await Api.getDataTable("/api/product/dataTable", query: query);
      List<Product> products =
          (_dataTable.data ?? []).map((e) => Product.fromJson(e)).toList();
      emit(ProductDataState(products, dataTable: _dataTable));
    } catch (e) {
      emit(ProductErrorState());
    }
  }

  void _postProduct(PostProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState());
    try {
      await ProductApi.postProduct(event.product);
      // emit(const ProductDataState());
    } catch (e) {
      emit(ProductErrorState());
    }
  }

  void _putProduct(PutProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState());
    try {
      await ProductApi.putProduct(event.product.id!, event.product);
      // emit(const ProductDataState());
    } catch (e) {
      emit(ProductErrorState());
    }
  }
}
