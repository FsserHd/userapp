

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart' as location;
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/model/service/add_service_request.dart';
import 'package:userapp/utils/preference_utils.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/address_controller.dart';

class ServiceLocationPage extends StatefulWidget {
  String type;
  String serviceType;
  ServiceLocationPage(this.type, this.serviceType, {super.key});

  @override
  _ServiceLocationPageState createState() => _ServiceLocationPageState();
}

class _ServiceLocationPageState extends StateMVC<ServiceLocationPage> {

  late AddressController _con;

  _ServiceLocationPageState() : super(AddressController()) {
    _con = controller as AddressController;
  }

  late GoogleMapController mapController;
  late LatLng? _initialPosition = null;
  LatLng _selectedPosition = LatLng(37.7749, -122.4194);
  String _address = '';
  TextEditingController _searchController = TextEditingController();

  final _placesApiKey = 'AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY'; // Replace with your API key
  final _geocoding = location.GoogleMapsGeocoding(apiKey: 'AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY'); // Replace with your API key

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMapTapped(LatLng position) async {
    setState(() {
      _selectedPosition = position;
     _con. request.fLatitude = position.latitude.toString();
      _con.request.fLongitude = position.longitude.toString();
      if(widget.type == "from") {
        _con.serviceCheckZone(context, position.latitude.toString(),
            position.longitude.toString(),widget.serviceType);
      }
    });

    final geocodingResponse = await _geocoding.searchByLocation(
        location.Location(lat: position.latitude, lng: position.longitude),
    );

    if (geocodingResponse.results.isNotEmpty) {
      setState(() {
        _address = geocodingResponse.results.first.formattedAddress ?? '';
        _con.request.fromlocation  = _address;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getCurrentLocation();
    initialLocation();
  }

  initialLocation() async {
    String? latitude = await PreferenceUtils.getLatitude();
    String? longitude = await PreferenceUtils.getLatitude();
    _initialPosition =  LatLng(double.parse(latitude!), double.parse(longitude!));
  }

  void _showBottomSheet(BuildContext context) {

    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var addressType = "Select";


  }

  Future<void> _searchAndNavigate(String s) async {
    try {
      List<geocoding.Location> locations = await geocoding.locationFromAddress(s);
      if (locations.isNotEmpty) {
        final location1 = locations.first;
        final latLng = LatLng(location1.latitude, location1.longitude);

        setState(() {
          _selectedPosition = latLng;
        });

        setState(() {
          _selectedPosition = latLng;
          _con. request.fLatitude = latLng.latitude.toString();
          _con.request.fLongitude = latLng.longitude.toString();
          if(widget.type == "from") {
            _con.serviceCheckZone(context, latLng.latitude.toString(),
                latLng.longitude.toString(),widget.serviceType);
          }
        });

        final geocodingResponse = await _geocoding.searchByLocation(
          location.Location(lat: latLng.latitude, lng: latLng.longitude),
        );

        if (geocodingResponse.results.isNotEmpty) {
          setState(() {
            _address = geocodingResponse.results.first.formattedAddress ?? '';
            _con.request.fromlocation  = _address;
          });
        }

        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: latLng,
              zoom: 14.0,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location not found')),
      );
    }
  }


  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String? currentLatitude = await PreferenceUtils.getLatitude();
    String? currentLongitude = await PreferenceUtils.getLongitude();
    setState(() {
      _initialPosition = LatLng(double.parse(currentLatitude!), double.parse(currentLongitude!));
      _selectedPosition = _initialPosition!;
      _con.request.fLatitude = currentLatitude.toString();
      _con.request.fLongitude = currentLongitude.toString();
       if(widget.type == "from") {
         _con.serviceCheckZone(context, currentLatitude.toString(),
             currentLongitude.toString(),widget.serviceType);
       }
    });

    // mapController.animateCamera(
    //   CameraUpdate.newCameraPosition(
    //     CameraPosition(
    //       target: _initialPosition!,
    //       zoom: 14.0,
    //     ),
    //   ),
    // );

    final geocodingResponse = await _geocoding.searchByLocation(
        location.Location(lat:double.parse(currentLatitude!), lng: double.parse(currentLongitude!)),
    );

    if (geocodingResponse.results.isNotEmpty) {
      setState(() {
        _address = geocodingResponse.results.first.formattedAddress ?? '';
        print("Map data: "+_address);
        _con.request.fromlocation  = _address;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: AppColors.themeColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Choose Location",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: Stack(
        children: [
         _initialPosition!=null ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text("Enter Address",style: AppStyle.font14MediumBlack87.override(fontSize: 12),),
                          Theme(
                            data: Theme.of(context).copyWith(
                              inputDecorationTheme: InputDecorationTheme(
                                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            child: GooglePlacesAutoCompleteTextFormField(
                              maxLines: 1,
                              textEditingController: _searchController,
                              googleAPIKey: _placesApiKey,
                              debounceTime: 400,
                              countries: ['in'],
                              fetchCoordinates: true,
                              onPlaceDetailsWithCoordinatesReceived: (prediction) {
                                final lat = prediction.lat;
                                final lng = prediction.lng;
                                // _goToLocation(lat, lng);
                              },
                              onSuggestionClicked: (prediction) {
                                _searchController.text = prediction.description!;
                               /* _con.serviceCheckZone(
                                  context,
                                  prediction.lat.toString(),
                                  prediction.lng.toString(),
                                );*/
                                _searchAndNavigate(prediction.description!);
                              },
                            ),
                          )
                          ,
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition!,
                    zoom: 12.0,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('selected-location'),
                      position: _selectedPosition,
                    ),
                  },
                  onTap: _onMapTapped,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Address:',
                      style: AppStyle.font18BoldWhite,
                    ),
                    SizedBox(height: 8.0),
                    Text(_address,style: AppStyle.font14MediumBlack87,),
                    SizedBox(height: 8.0),
                    _con.isServiceAvailable ? InkWell(
                      onTap: (){
                        print( _con.request.toJson());
                        if(widget.type == "from") {
                          _con.request.zoneId =
                          _con.serviceZoneResponseModel.data!;
                        }
                        Navigator.pop(context, _con.request);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.themeColor, // Gray fill color
                          borderRadius: BorderRadius.circular(15.0), // Rounded corners
                        ),
                        child: Center(
                          child:   Text("Confirm",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                        ),
                      ),
                    ):Container(),
                  ],
                ),
              ),
            ],
          ):Container(),
          Positioned(
            top: 90.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
