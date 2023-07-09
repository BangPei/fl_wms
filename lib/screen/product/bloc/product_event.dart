part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {
  const ProductEvent();
}

class PostProduct extends ProductEvent {
  final Product product;
  const PostProduct(this.product);
}

class PutProduct extends ProductEvent {
  final Product product;
  const PutProduct(this.product);
}
