part of 'maps_cubit.dart';

sealed class MapsState {}

final class MapsInitial extends MapsState {}

class PlaceLoadded extends MapsState {
   final List<Place> place;

  PlaceLoadded(this.place);

}
