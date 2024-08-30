import 'package:dio/dio.dart';
import 'package:maps/constants/strings.dart';

class WebServices {
  late Dio dio;
  WebServices() {
    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      receiveDataWhenStatusError: true,
    );
  }

  Future<List<dynamic>> fetchPlaces(String text) async {
    try {
      Response response = await dio.get(
          'https://api.openrouteservice.org/geocode/autocomplete?api_key=$mapApi',
          queryParameters: {
            'api_key': mapApi,
          });
      return response.data;
    } catch (e) {
      return [];
    }
  }
  // Future <void> getLocation(String place)async{

  //   Response response = await dio.get('https://api.openrouteservice.org/geocode/autocomplete?api_key=$mapApi',queryParameters: {

  //     'place':
  //   });
  // }
}
