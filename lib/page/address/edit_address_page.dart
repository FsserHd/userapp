

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/model/address/adders_response_model.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_style.dart';
import '../../controller/address_controller.dart';

class EditAddressPage extends StatefulWidget {
  Data addressBean;
  EditAddressPage(this.addressBean, {super.key});

  @override
  _EditAddressPageState createState() => _EditAddressPageState();

}

class _EditAddressPageState extends StateMVC<EditAddressPage> {

  late AddressController _con;

  _EditAddressPageState() : super(AddressController()) {
    _con = controller as AddressController;
  }

  late GoogleMapController mapController;
  late LatLng _initialPosition;
  late LatLng _selectedPosition;
  String _address = '';


  final _placesApiKey = 'AIzaSyAllf0gGdRTTog1ChI62srhdNZ-hVsEYe0'; // Replace with your API key
  final _geocoding = GoogleMapsGeocoding(apiKey: 'AIzaSyAllf0gGdRTTog1ChI62srhdNZ-hVsEYe0'); // Replace with your API key

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMapTapped(LatLng position) async {
    setState(() {
      _selectedPosition = position;
      _con.serviceCheckZone(context, position.latitude.toString(), position.longitude.toString());
    });
    final geocodingResponse = await _geocoding.searchByLocation(
      Location(lat: position.latitude, lng: position.longitude),
    );

    if (geocodingResponse.results.isNotEmpty) {
      setState(() {
        _address = geocodingResponse.results.first.formattedAddress ?? '';
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getCurrentLocation();
    _initialPosition = LatLng(double.parse(widget.addressBean.latitude!), double.parse(widget.addressBean.longitude!));
    _selectedPosition = LatLng(double.parse(widget.addressBean.latitude!), double.parse(widget.addressBean.longitude!));
    setState(() {
      _address = widget.addressBean.address!;
    });
  }


  void _showBottomSheet(BuildContext context) {

    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var addressType = widget.addressBean.addresstype;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Form(
              key: _con.addressKey,
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
                      initialValue: widget.addressBean.name,
                      onSaved: (e){
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
                      initialValue: widget.addressBean.mobile,
                      onSaved: (e){
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
                      _con.addressKey.currentState!.save();
                      _con.addressModel.addresstype = addressType;
                      _con.addressModel.address = _address;
                      _con.addressModel.latitude = _selectedPosition.latitude.toString();
                      _con.addressModel.longitude = _selectedPosition.longitude.toString();
                      _con.editAddress(context,widget.addressBean.addressId!);
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

    final geocodingResponse = await _geocoding.searchByLocation(
      Location(lat: position.latitude, lng: position.longitude),
    );

    if (geocodingResponse.results.isNotEmpty) {
      setState(() {
        _address = geocodingResponse.results.first.formattedAddress ?? '';
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
        title: Text("Select Location",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
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
            top: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    ) ;
  }
}
