import 'package:bloc/bloc.dart';
import 'package:maps/data/moduls/places_suggestion.dart';
import 'package:maps/data/repo/place_repo.dart';


part 'maps_state.dart';


class MapsCubit extends Cubit<MapsState> {
   PlaceRepo placeRepo;
  MapsCubit(this.placeRepo) : super(MapsInitial());


void emitFetfetchPlaces(String text){
  placeRepo.fetchPlaces(text).then((suggestion){
  emit(PlaceLoadded(suggestion));

  });

}}
