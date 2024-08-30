class Place {
  late String place;
  Place.fromJson(Map<String,dynamic>json){
    place=json['geocoding']['query']['parsed_text']['city'];
  }
}