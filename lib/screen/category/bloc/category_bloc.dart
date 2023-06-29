import 'package:fl_wms/screen/category/data/category.dart';
import 'package:fl_wms/screen/category/data/category_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryLoadingState()) {
    on<GetCategories>(_getCategories);
    on<PostCategory>(_postCategory);
    on<PutCategory>(_putCategory);
  }

  void _getCategories(GetCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoadingState());
    try {
      List<Category> categoried = await CategoryApi.getCategories();
      emit(CategoryDataState(categoried));
    } catch (e) {
      emit(CategoryErrorState());
    }
  }

  void _postCategory(PostCategory event, Emitter<CategoryState> emit) async {
    // emit(BrandLoadingState());
    try {
      await CategoryApi.postCategory(event.category);
      List<Category> categories = await CategoryApi.getCategories();
      emit(CategoryDataState(categories));
    } catch (e) {
      emit(CategoryErrorState());
    }
  }

  void _putCategory(PutCategory event, Emitter<CategoryState> emit) async {
    // emit(BrandLoadingState());
    try {
      await CategoryApi.putCategory(event.category.id!, event.category);
      List<Category> categories = await CategoryApi.getCategories();
      emit(CategoryDataState(categories));
    } catch (e) {
      emit(CategoryErrorState());
    }
  }
}
