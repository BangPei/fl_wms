import 'package:fl_wms/screen/product/data/product.dart';
import 'package:fl_wms/screen/product/data/product_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(const ProductDataState()) {
    on<PostProduct>(_postProduct);
    on<PutProduct>(_putProduct);
  }

  void _postProduct(PostProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState());
    try {
      await ProductApi.postProduct(event.product);
      emit(const ProductDataState());
    } catch (e) {
      emit(ProductErrorState());
    }
  }

  void _putProduct(PutProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState());
    try {
      await ProductApi.putProduct(event.product.id!, event.product);
      emit(const ProductDataState());
    } catch (e) {
      emit(ProductErrorState());
    }
  }
}
