part of 'brand_bloc.dart';

@immutable
abstract class BrandState {
  const BrandState();
}

class BrandLoadingState extends BrandState {
  List<Object?> get props => [];
}

class BrandStandByState extends BrandState {
  List<Object?> get props => [];
}

class LoadingTableState extends BrandState {
  List<Object?> get props => [];
}

class BrandErrorState extends BrandState {
  List<Object?> get props => [];
}

class BrandDataState extends BrandState {
  const BrandDataState();
  List<Object?> get props => [];
}
