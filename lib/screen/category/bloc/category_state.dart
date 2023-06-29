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
  final List<Category> categories;
  const CategoryDataState(this.categories);
  List<Object?> get props => [categories];
}
