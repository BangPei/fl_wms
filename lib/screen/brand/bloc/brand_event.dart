part of 'brand_bloc.dart';

@immutable
abstract class BrandEvent {
  const BrandEvent();
}

class PostBrand extends BrandEvent {
  final Brand brand;
  const PostBrand(this.brand);
}

class PutBrand extends BrandEvent {
  final Brand brand;
  const PutBrand(this.brand);
}
