import 'dart:convert';

import 'package:fl_wms/models/datatable_model.dart';
import 'package:fl_wms/screen/brand/data/brand.dart';
import 'package:fl_wms/screen/brand/data/brand_api.dart';
import 'package:fl_wms/screen/category/data/item_category.dart';
import 'package:fl_wms/screen/category/data/category_api.dart';
import 'package:fl_wms/screen/product/data/product.dart';
import 'package:fl_wms/screen/product/data/product_api.dart';
import 'package:fl_wms/service/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

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
    on<ProductStandbyForm>(_productStandByForm);
    on<SearchProduct>(_searchProduct);
  }

  void _getDataTable(GetDataTable event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState());
    try {
      _draw = _draw + 1;
      query['draw'] = _draw.toString();
      for (var i = 0; i < columns.length; i++) {
        String str = columns[i];
        query["columns[$i][data]"] = str;
        query["columns[$i][searchable]"] = "true";
        query["columns[$i][orderable]"] = "true";
        query["columns[$i][search][regex]"] = "false";
      }
      query["order[0][column]"] = event.orderColumn.toString();
      query["order[0][dir]"] = event.orderDir;
      query['start'] = event.start.toString();
      query['length'] = event.length.toString();
      query['search'] = event.search;
      // query['category_id'] = "1";
      query['search.regex'] = "false";

      DataTableModel dataTable =
          await Api.getDataTable("/api/product/dataTable", query: query);
      List<Product> products =
          (dataTable.data ?? []).map((e) => Product.fromJson(e)).toList();
      emit(ProductDataState(products, dataTable: dataTable));
    } catch (e) {
      emit(ProductErrorState());
    }
  }

  void _searchProduct(SearchProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState());
    try {
      var data = Uri.http(Api.url, "/api/product/dataTable-filter",
          {"search": event.str, "length": "10", "start": "0"});
      var callback = await http.get(data, headers: {
        "content-type": "application/json",
        'X-Requested-With': 'XMLHttpRequest',
      });
      // await Api.getDataTable("/api/product/dataTable-filter?${event.str}");
      var body = jsonDecode(callback.body);
      DataTableModel dataTable = DataTableModel.fromJson(body);
      List<Product> products =
          (dataTable.data ?? []).map((e) => Product.fromJson(e)).toList();
      emit(ProductDataState(products, dataTable: dataTable));
      // emit(const ProductFormState());
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

  void _productStandByForm(
      ProductStandbyForm event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState());
    try {
      List<ItemCategory> categories = await CategoryApi.getCategories();
      List<Brand> brands = await BrandApi.getBrands();
      Product product = Product();
      if (event.id != null) {
        product = await ProductApi.getProduct(event.id!);
      }
      emit(ProductFormState(
          product: product, categories: categories, brands: brands));
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
