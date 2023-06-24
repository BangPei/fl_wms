part of 'brand_bloc.dart';

@immutable
abstract class BrandEvent {
  const BrandEvent();
}

class GetBrands extends BrandEvent {
  List<Object?> get props => [];
}
