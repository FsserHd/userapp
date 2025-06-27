

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:userapp/constants/app_colors.dart';
import 'package:userapp/flutter_flow/flutter_flow_theme.dart';
import 'package:userapp/utils/validation_utils.dart';

import '../../../constants/app_style.dart';
import '../../../controller/auth_controller.dart';
import '../../../flutter_flow/flutter_flow_util.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends StateMVC<EditProfilePage> {

  late AuthController _con;

  _EditProfilePageState() : super(AuthController()) {
    _con = controller as AuthController;
  }

  File? _image;

  DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
       // _con.uploadImage(_image!);
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.getProfile();
  }


  void _selectDateTime(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1955),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      // TimeOfDay? selectedTime = await showTimePicker(
      //   context: context,
      //   initialTime: TimeOfDay.now(),
      // );

     // if (selectedTime != null) {
        DateTime finalDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        );
        _con.dobController.text = _dateFormat.format(finalDateTime);
        // Save the selected date and time
        //_con.addServiceRequest.fromtime = _dateTimeController.text;
      //}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themeColor,
      appBar:  AppBar(
        backgroundColor: AppColors.themeColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Edit Profile",style: TextStyle(color: Colors.white,fontFamily: AppStyle.robotoRegular,fontSize: 16),),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 100,),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                      width: 0,
                    ),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0.0),bottomRight: Radius.circular(0.0),topLeft:Radius.circular(20.0),topRight: Radius.circular(20.0) ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(height: 100,),
                          Container(
                            height: 52,
                            child: TextFormField(
                              controller:  _con.nameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200], // Gray fill color
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  hintText: 'Enter Name',
                                  hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.black)
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 52,
                            child: TextFormField(
                              controller: _con.mobileController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200], // Gray fill color
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  hintText: 'Enter Mobile Number',
                                  hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.black)
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 52,
                            child: TextFormField(
                              controller: _con.emailController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200], // Gray fill color
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  hintText: 'Enter Email',
                                  hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.black)
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          InkWell(
                            onTap: (){
                              _selectDateTime(context);
                            },
                            child: Container(
                              height: 52,
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _con.dobController,
                                  onSaved: (e){
                                    //_con.addServiceRequest.fromtime = e;
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[200], // Gray fill color
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      hintText: 'Choose Date of Birth',
                                      hintStyle: AppStyle.font14MediumBlack87.override(color: Colors.black)
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          Container(
                            height: 60,
                            child: DropdownButtonFormField<String>(
                              value:_con.genderType,
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              items: <String>["Select Gender",'Male', 'Female',"Others"].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,style: AppStyle.font14RegularBlack87.override(fontSize: 14),),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _con.genderType = newValue!;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 15,),
                          InkWell(
                            onTap: (){
                              if(ValidationUtils.emptyValidation(_con.nameController.text) && ValidationUtils.emptyValidation(_con.mobileController.text)){
                                _con.updateProfileRequest.name = _con.nameController.text;
                                _con.updateProfileRequest.mobile = _con.mobileController.text;
                                _con.updateProfileRequest.email = _con.emailController.text;
                                _con.updateProfileRequest.dob = _con.dobController.text;
                                _con.updateProfileRequest.gender = _con.genderType;
                                if(_image!=null) {
                                  _con.uploadWithImage(_image!,context);
                                }else{
                                  _con.uploadWithOutImage(context);
                                }
                              }else{
                                ValidationUtils.showAppToast("Name & Mobile Number are required");
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.themeColor, // Gray fill color
                                borderRadius: BorderRadius.circular(15.0), // Rounded corners
                              ),
                              child: Center(
                                child:   Text("Update",style: AppStyle.font14MediumBlack87.override(color: Colors.white)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          _con.profileModel.data!=null ? Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    InkWell(
                      onTap: (){
                        _pickImage(ImageSource.gallery);
                      },
                      child: Stack(
                        children: [
                          _image!=null ? ClipOval(
                            child: Image.file(
                              _image!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ) :_con.profileModel.data!.image!.contains("noimg") ?Image.asset("assets/images/account.png", width: 120,
                            height: 120,): ClipOval(
                            child: Image.network(
                              _con.profileModel.data!.image!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Icon(Icons.edit_calendar_outlined,color: AppColors.themeColor,),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    // _con.profileModel.data!=null ? Text(_con.profileModel.data!.phone!,style: AppStyle.font14MediumBlack87.override(color: CupertinoColors.inactiveGray,fontSize: 16),):Container(),
                  ],
                )),
          ):Container(),
        ],
      ),
    );
  }
}
