part of 'product_bloc.dart';

@immutable
abstract class ProductState {
  const ProductState();
}

class ProductLoadingState extends ProductState {
  List<Object?> get props => [];
}

class ProductStandByState extends ProductState {
  List<Object?> get props => [];
}

class LoadingTableState extends ProductState {
  List<Object?> get props => [];
}

class ProductErrorState extends ProductState {
  List<Object?> get props => [];
}

class ProductDataState extends ProductState {
  const ProductDataState();
  List<Object?> get props => [];
}
