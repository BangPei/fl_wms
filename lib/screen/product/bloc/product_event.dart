part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {
  const ProductEvent();
}

class GetDataTable extends ProductEvent {
  final int start;
  final int length;
  final int orderColumn;
  final String search;
  final String orderDir;
  const GetDataTable({
    required this.start,
    required this.length,
    required this.orderColumn,
    required this.search,
    required this.orderDir,
  });
}

class PostProduct extends ProductEvent {
  final Product product;
  const PostProduct(this.product);
}

class PutProduct extends ProductEvent {
  final Product product;
  const PutProduct(this.product);
}
