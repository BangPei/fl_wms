part of 'brand_bloc.dart';

@immutable
abstract class BrandEvent {
  const BrandEvent();
}

class GetBrands extends BrandEvent {
  const GetBrands();
}

class PostBrand extends BrandEvent {
  final Brand brand;
  const PostBrand(this.brand);
}
