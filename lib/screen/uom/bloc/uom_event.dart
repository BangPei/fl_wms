part of 'uom_bloc.dart';

@immutable
abstract class UomEvent {
  const UomEvent();
}

class GetUoms extends UomEvent {
  const GetUoms();
}

class PostUom extends UomEvent {
  final Uom uom;
  const PostUom(this.uom);
}

class PutUom extends UomEvent {
  final Uom uom;
  const PutUom(this.uom);
}
