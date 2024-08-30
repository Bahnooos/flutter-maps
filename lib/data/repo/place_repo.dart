import 'package:maps/data/moduls/places_suggestion.dart';
import 'package:maps/data/web_services.dart';

class PlaceRepo {
  final WebServices webServices;

  PlaceRepo(this.webServices);
  
  Future<List<Place>> fetchPlaces(String text) async {
   final placeSuggestion =await webServices.fetchPlaces(text);
   return placeSuggestion.map((place)=> Place.fromJson(place)).toList();

}}