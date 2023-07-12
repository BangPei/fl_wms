part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {
  const CategoryEvent();
}

class PostCategory extends CategoryEvent {
  final ItemCategory category;
  const PostCategory(this.category);
}

class PutCategory extends CategoryEvent {
  final ItemCategory category;
  const PutCategory(this.category);
}
