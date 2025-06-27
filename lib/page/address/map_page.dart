

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart' ;
import 'package:google_maps_webservice/places.dart' as places;
import 'package:google_maps_webservice/places.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/controller/address_controller.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/utils/loader.dart';
import 'package:userapp/utils/preference_utils.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';


class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends StateMVC<MapPage> {

  late AddressController _con;

  _MapPageState() : super(AddressController()) {
    _con = controller as AddressController;
  }

  late GoogleMapController mapController;
  late LatLng _initialPosition = LatLng(10.8027117, 78.2978937);
  LatLng _selectedPosition = LatLng(10.8027117, 78.2978937);
  String _address = '';
  TextEditingController _searchController = TextEditingController();

  final apiKey = 'AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY'; // Replace with your API key
  final _geocoding = GoogleMapsGeocoding(apiKey: 'AIzaSyBRxE8E6WSJaIzLPx7zpGHEbo5djXx3bTY'); // Replace with your API key

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

  }

  Future<void> _searchAndNavigate(String s) async {
    try {
      List<geocoding.Location> locations = await geocoding.locationFromAddress(s);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);

        setState(() {
          _selectedPosition = latLng;
        });

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


  void _onMapTapped(LatLng position) async {
    setState(() {
      _selectedPosition = position;
      _con.serviceCheckZone(context, position.latitude.toString(), position.longitude.toString());
    });
    try {
      // Get the address using the geocoding package
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // If the placemark is found, update the address
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _address = "${place.street}, ${place.locality}, ${place.country}";
        });
      }
    } catch (e) {
      print(e);
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

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Padding for keyboard
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Recipient Details',
                      style: AppStyle.font14MediumBlack87.override(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 50,
                      child: TextFormField(
                        onChanged: (e){
                          _con.addressModel.name = e;
                        },
                        decoration: InputDecoration(
                          labelText: 'Recipient Name',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 50,
                      child: TextFormField(
                        onChanged: (e){
                          _con.addressModel.mobile = e;
                        },
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: DropdownButtonFormField<String>(
                        value: addressType,
                        decoration: InputDecoration(
                          labelText: 'Address Type',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        items: <String>["Select",'Home', 'Office'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            addressType = newValue!;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: (){
                        _con.addressModel.addresstype = addressType;
                        _con.addressModel.address = _address;
                        _con.addressModel.latitude = _selectedPosition.latitude.toString();
                        _con.addressModel.longitude = _selectedPosition.longitude.toString();
                        _con.addAddress(context);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.themeColor, // Gray fill color
                          borderRadius: BorderRadius.circular(15.0), // Rounded corners
                        ),
                        child: Center(
                          child:   Text("Processed",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _selectedPosition = _initialPosition;
      _con.serviceCheckZone(context, position.latitude.toString(), position.longitude.toString());
    });

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _initialPosition,
          zoom: 14.0,
        ),
      ),
    );

    try {
      // Get the address using the geocoding package
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // If the placemark is found, update the address
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _address = "${place.street}, ${place.locality}, ${place.country}";
        });
      }
    } catch (e) {
      print(e);
    }
  }



  Future<void> displayPrediction(places.Prediction p) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: apiKey);
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    setState(() {
      _selectedPosition = LatLng(lat, lng);
      mapController?.moveCamera(CameraUpdate.newLatLng(_selectedPosition));
    });
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
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.search),
        //     onPressed: _handlePressButton,
        //   ),
        // ],
      ),
      body: Stack(
        children: [
          if(_initialPosition!=null)
        Column(
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
                              googleAPIKey: apiKey,
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
                        _showBottomSheet(context);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.themeColor, // Gray fill color
                          borderRadius: BorderRadius.circular(15.0), // Rounded corners
                        ),
                        child: Center(
                          child:   Text("Processed",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                        ),
                      ),
                    ):Container(),
                  ],
                ),
              ),
            ],
          ),
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
