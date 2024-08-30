import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import 'package:maps/constants/colors.dart';
import 'package:maps/constants/strings.dart';
import 'package:http/http.dart' as http;
import 'package:maps/data/moduls/places_suggestion.dart';
import 'package:maps/presentation/widgets/my_drawer.dart';

import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _typeAheadController = TextEditingController();
  FloatingSearchBarController _controller = FloatingSearchBarController();
  List<String> searchResults = [];

  late LatLng point;
  List<Place> places = [];
  final MapController _mapcontroller = MapController();
  LocationData? currentLocation;
  List<LatLng> routePoint = [];
  List<Marker> markers = [];
  late bool isDistanceAndTime = false;
  late bool isSearchedPlaceMarkerClicked = false;
  late Dio dio;
  @override
  void initState() {
    super.initState();
    getMyCurrentLocation();
    _controller = FloatingSearchBarController();
  }

  List<dynamic> _places = [];
  bool isloading = false;
  void Function()? onTap;

  Widget buildFloatingSearchBar() {
    final isPortrite =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      margins: const EdgeInsets.fromLTRB(20, 70, 20, 0),
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      controller: _controller,
      hint: 'Search',
      height: 52,
      iconColor: Colors.blue,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 300),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrite ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrite ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onFocusChanged: (_) {
        isDistanceAndTime = false;
        isSearchedPlaceMarkerClicked = true;
      },
      onQueryChanged: searchPlaces,
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          
           
            child: Column(
              
              mainAxisSize: MainAxisSize.min,
              children: _places.map((suggestion) {
                final String placeName = suggestion['properties']['label'];
                final lat = suggestion['geometry']['coordinates'][1];
                final lng = suggestion['geometry']['coordinates'][0];
                
                return ListTile(
                 
                  leading: Container(
                   
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.blue[50],),
                    child:const Center(child: Icon(Icons.place,color:MyColors.redLight,),),
                    
                  ),
                  title: Text(placeName),
                  onTap: () {
                    _controller.close();
                    moveToNewMarker(lat, lng);
                    addDestinationMaker(LatLng(lat, lng));
                  },
                );
              }).toList(),
            ),
          
        );
      },
    );
  }

  void moveToNewMarker(double lat, double lng) {
    _mapcontroller.move(LatLng(lat, lng), 13);
  }



  Future<void> searchPlaces(String query) async {
    setState(() {
      isloading = true;
    });
    final url =
        'https://api.openrouteservice.org/geocode/autocomplete?api_key=$mapApi&text=$query';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        _places = json.decode(response.body)['features'];
      });
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<void> getRoute(LatLng detination) async {
    if (currentLocation == null) return;
    final start =
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
    final response = await http.get(
      Uri.parse(
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$mapApi&start=${start.longitude},${start.latitude}&end=${detination.longitude},${detination.latitude}',
      ),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coords =
          data['features'][0]['geometry']['coordinates'];
      setState(() {
        routePoint = coords.map((coord) => LatLng(coord[1], coord[0])).toList();
        point = detination;
        markers.add(
          Marker(
            width: 80,
            height: 80,
            point: detination,
            child: const Icon(
              Icons.location_on,
              color: MyColors.redLight,
            ),
          ),
        );
      });
    } else {
      const ScaffoldMessenger(
          child: SnackBar(content: Text('there is no route')));
    }
  }


  Future<void> getMyCurrentLocation() async {
    var location = Location();
    try {
      var userLocation = await Location().getLocation();

      setState(() {
        currentLocation = userLocation;
        markers.add(
          Marker(
            width: 80,
            height: 80,
            point: LatLng(userLocation.latitude!, userLocation.longitude!),
            child: const Icon(
              Icons.location_on,
              color: MyColors.redLight,
            ),
          ),
        );
      });
    } catch (e) {
      currentLocation = null;
    }
    location.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        currentLocation = newLocation;
      });
    });
  }

  void addDestinationMaker(LatLng point) {
    setState(() {
      markers.removeRange(1, markers.length);
      markers.add(
        Marker(
          width: 80,
          height: 80,
          point: point,
          child: const Icon(
            Icons.location_on,
            color: MyColors.redLight,
          ),
        ),
      );
      getRoute(point);
    });
  }

  Widget buildMap() {
    return FlutterMap(
        mapController: _mapcontroller,
        options: MapOptions(
          initialZoom: 15,
          onTap: (tapPosition, point) => addDestinationMaker(point),
          initialCenter:
              LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(markers: markers),
          PolylineLayer(polylines: [
            Polyline(
                color: Colors.blue, strokeWidth: 3, points: routePoint),
          ]),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              color: Colors.blueAccent[600],
              padding: const EdgeInsets.all(16),
              child: FloatingActionButton(
                onPressed: () {
                  if (currentLocation != null) {
                    _mapcontroller.move(
                        LatLng(currentLocation!.latitude!,
                            currentLocation!.longitude!),
                        13);
                  }
                  routePoint.removeRange(1, routePoint.length);
                  markers.removeRange(1, markers.length);

                },
                child: const Icon(
                  Icons.location_on,
                  color: MyColors.redLight,
                ),
              ),
            ),
          )
        ]);
  }

  void showDialogProgressIndicator(BuildContext context) {
    AlertDialog alertDialog = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 6,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );
    showDialog(
        barrierColor: Colors.white.withOpacity(0),
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          currentLocation != null
              ? buildMap()
              : const Center(
                  child: CircularProgressIndicator(
                    color: MyColors.redLight,
                  ),
                ),
          buildFloatingSearchBar(),
        ],
      ),
    );
  }
}
