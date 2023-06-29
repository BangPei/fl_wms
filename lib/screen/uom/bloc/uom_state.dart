part of 'uom_bloc.dart';

@immutable
abstract class UomState {
  const UomState();
}

class UomLoadingState extends UomState {
  List<Object?> get props => [];
}

class UomErrorState extends UomState {
  List<Object?> get props => [];
}

class UomDataState extends UomState {
  final List<Uom> uoms;
  const UomDataState(this.uoms);
  List<Object?> get props => [uoms];
}
