part of 'brand_bloc.dart';

@immutable
abstract class BrandEvent {
  const BrandEvent();
}

class GetBrandDataTable extends BrandEvent {
  final int? start;
  final int? length;
  final String? searchText;
  final Map<String, dynamic>? query;
  const GetBrandDataTable({
    this.start,
    this.searchText,
    this.length,
    this.query,
  });
}

class GetBrandDataTableExtend extends BrandEvent {
  final int? start;
  final int? length;
  final String? searchText;
  final Map<String, dynamic>? query;
  const GetBrandDataTableExtend({
    this.start,
    this.searchText,
    this.length,
    this.query,
  });
}

class GetBrands extends BrandEvent {
  const GetBrands();
}

class PostBrand extends BrandEvent {
  final Brand brand;
  const PostBrand(this.brand);
}

class PutBrand extends BrandEvent {
  final Brand brand;
  const PutBrand(this.brand);
}
