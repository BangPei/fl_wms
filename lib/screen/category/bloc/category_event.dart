part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {
  const CategoryEvent();
}

class PostCategory extends CategoryEvent {
  final Category category;
  const PostCategory(this.category);
}

class PutCategory extends CategoryEvent {
  final Category category;
  const PutCategory(this.category);
}
