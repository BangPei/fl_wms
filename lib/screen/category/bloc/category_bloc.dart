import 'package:fl_wms/screen/category/data/item_category.dart';
import 'package:fl_wms/screen/category/data/category_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(const CategoryDataState()) {
    on<PostCategory>(_postCategory);
    on<PutCategory>(_putCategory);
  }

  void _postCategory(PostCategory event, Emitter<CategoryState> emit) async {
    emit(CategoryLoadingState());
    try {
      await CategoryApi.postCategory(event.category);
      emit(const CategoryDataState());
    } catch (e) {
      emit(CategoryErrorState());
    }
  }

  void _putCategory(PutCategory event, Emitter<CategoryState> emit) async {
    emit(CategoryLoadingState());
    try {
      await CategoryApi.putCategory(event.category.id!, event.category);
      emit(const CategoryDataState());
    } catch (e) {
      emit(CategoryErrorState());
    }
  }
}
