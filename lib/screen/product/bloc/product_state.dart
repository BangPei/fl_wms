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
  final List<Brand>? brands;
  final List<ItemCategory>? categories;
  const ProductFormState({this.product, this.brands, this.categories});
  List<Object?> get props => [product, categories, brands];
}

class ProductDataState extends ProductState {
  final DataTableModel? dataTable;
  final List<Product> products;
  const ProductDataState(this.products, {this.dataTable});
  List<Object?> get props => [dataTable, products];
}
