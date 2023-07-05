part of 'category_bloc.dart';

@immutable
abstract class CategoryState {
  const CategoryState();
}

class CategoryLoadingState extends CategoryState {
  List<Object?> get props => [];
}

class CategoryErrorState extends CategoryState {
  List<Object?> get props => [];
}

class CategoryDataState extends CategoryState {
  const CategoryDataState();
  List<Object?> get props => [];
}
