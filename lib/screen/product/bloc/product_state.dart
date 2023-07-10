part of 'product_bloc.dart';

@immutable
abstract class ProductState {
  const ProductState();
}

class ProductLoadingState extends ProductState {
  List<Object?> get props => [];
}

class ProductErrorState extends ProductState {
  List<Object?> get props => [];
}

class ProductFormState extends ProductState {
  final Product? product;
  const ProductFormState({this.product});
  List<Object?> get props => [product];
}

class ProductDataState extends ProductState {
  final DataTableModel? dataTable;
  final List<Product> products;
  const ProductDataState(this.products, {this.dataTable});
  List<Object?> get props => [dataTable, products];
}
