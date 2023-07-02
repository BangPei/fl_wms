part of 'brand_bloc.dart';

@immutable
abstract class BrandState {
  const BrandState();
}

class BrandLoadingState extends BrandState {
  List<Object?> get props => [];
}

class LoadingTableState extends BrandState {
  List<Object?> get props => [];
}

class BrandErrorState extends BrandState {
  List<Object?> get props => [];
}

class BrandDataState extends BrandState {
  final List<Brand> brands;
  final DataTableModel? dataTable;
  const BrandDataState(this.brands, {this.dataTable});
  List<Object?> get props => [brands, dataTable];
}
