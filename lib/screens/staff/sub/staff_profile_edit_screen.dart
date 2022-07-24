import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_101/model/entity/staff_info.dart';
import 'package:flutter_101/service/staff_info_service.dart';
import 'package:flutter_101/utils/global.dart';
import 'package:flutter_101/utils/utils.dart';
import 'package:flutter_101/widget/text_field_custom.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visibility_detector/visibility_detector.dart';

class StaffProfileEditScreen extends StatefulWidget {
  const StaffProfileEditScreen(): super();

  static const String ROUTE_ID = 'staff_profile_edit_screen';

  @override
  _StaffProfileEditScreenState createState() => _StaffProfileEditScreenState();
}

class _StaffProfileEditScreenState extends State<StaffProfileEditScreen> {

  static const storage = FlutterSecureStorage();

  StaffInfoService staffInfoService = StaffInfoService();

  late bool firstFlag;

  late String imagePath;

  late TextEditingController _firstnameTxt;
  late TextEditingController _lastnameTxt;
  late TextEditingController _emailTxt;
  late TextEditingController _telPhoneTxt;

  late StaffInfo staffInfo;

  final ImagePicker _picker = ImagePicker();
  late String _imageLocalPath = "";
  File? imageFile;

  @override
  void initState() {
    super.initState();

    firstFlag = false;

    imagePath = "";

    _firstnameTxt = TextEditingController();
    _lastnameTxt = TextEditingController();
    _emailTxt = TextEditingController();
    _telPhoneTxt = TextEditingController();
  }

  onRefresh(bool isVisible) {
    if (isVisible && !firstFlag) {
      imagePath = "";

      firstFlag = true;
      _findStaffInfo();
    } else if (!isVisible) {
      firstFlag = false;
    }
  }

  _findStaffInfo() {
    storage.read(key: "username").then((username) => {
      staffInfoService.staffLogin(username!).then((staff) {
        setState(() {
          staffInfo = staff;

          _firstnameTxt.text = staff.firstname;
          _lastnameTxt.text = staff.lastname;
          _emailTxt.text = staff.email;
          _telPhoneTxt.text = staff.telPhone;
          imagePath = staff.imagePath;
        });
      })
    });
  }

  _updateStaffInfo(BuildContext context) {
    staffInfo.firstname = _firstnameTxt.text;
    staffInfo.lastname = _lastnameTxt.text;
    staffInfo.email = _emailTxt.text;
    staffInfo.telPhone = _telPhoneTxt.text;
    staffInfo.image = _imageLocalPath;

    staffInfoService.updateStaffInfo(staffInfo).then((staff) {
      Utils.createToast("บันทึกแก้ไขสำเร็จ!", context);
      Navigator.of(context).pop();
    });
  }

  _imgFromGallery() async {
    XFile? xFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if(xFile != null){
      setState(() {
        imageFile = File(xFile.path);
        _imageLocalPath = File(xFile.path).path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key(StaffProfileEditScreen.ROUTE_ID),
      onVisibilityChanged: (VisibilityInfo info) {
        bool isVisible = info.visibleFraction != 0;
        onRefresh(isVisible);
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.black54, //change your color here
            ),
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/asset/imgs/bg/bg-staff-main.PNG"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 60, left: 20, right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          ClipOval(
                            child: _imageLocalPath != "" ? Image.file(imageFile!) : Image.network(
                                "${Global.rootURL}/uploads/$imagePath",
                                width: 150.0,
                                height: 150.0,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return Image.asset(
                                    'lib/asset/imgs/no-image.png',
                                    width: 150.0,
                                    height: 150.0,
                                    fit: BoxFit.cover,
                                  );
                                }
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 125.0, top: 110.0),
                            child: IconButton(
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: Colors.black,
                                size: 30.0,
                              ),
                              onPressed: () {
                                _imgFromGallery();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0,),
                      TextFieldCustom(
                        hintText: "ชื่อ",
                        controller: _firstnameTxt,
                        isLabel: true,
                        keyboardType: TextInputType.text,
                        inputWidth: 0.8,
                      ),
                      TextFieldCustom(
                        hintText: "สกุล",
                        controller: _lastnameTxt,
                        isLabel: true,
                        keyboardType: TextInputType.text,
                        inputWidth: 0.8,
                      ),
                      TextFieldCustom(
                        hintText: "Email",
                        controller: _emailTxt,
                        isLabel: true,
                        keyboardType: TextInputType.text,
                        inputWidth: 0.8,
                      ),
                      TextFieldCustom(
                        hintText: "เบอร์โทรศัพท์",
                        controller: _telPhoneTxt,
                        isLabel: true,
                        keyboardType: TextInputType.text,
                        inputWidth: 0.8,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: RaisedButton.icon(
                            icon: const Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'บันทึก',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.5,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: const Color(0xFF8EC1FD),
                            onPressed: () {
                              _updateStaffInfo(context);
                            }
                        ),
                      ),
                    ],
                  )
              ),
            ),
          )
      ),
    );
  }

}