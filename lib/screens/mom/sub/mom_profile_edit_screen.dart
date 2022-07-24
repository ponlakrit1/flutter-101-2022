import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_101/model/entity/mother_info.dart';
import 'package:flutter_101/service/mother_info_service.dart';
import 'package:flutter_101/utils/global.dart';
import 'package:flutter_101/utils/utils.dart';
import 'package:flutter_101/widget/drop_down_custom.dart';
import 'package:flutter_101/widget/text_field_custom.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MomProfileEditScreen extends StatefulWidget {
  const MomProfileEditScreen(): super();

  static const String ROUTE_ID = 'mom_profile_edit_screen';

  @override
  _MomProfileEditScreenState createState() => _MomProfileEditScreenState();
}

class _MomProfileEditScreenState extends State<MomProfileEditScreen> {

  static const storage = FlutterSecureStorage();

  MotherInfoService motherInfoService = MotherInfoService();

  late bool firstFlag;

  final pregnantStatusMapList = [
    {'Value': '0', 'Label': 'ตั้งครรภ์'},
    {'Value': '1', 'Label': 'คลอดแล้ว'},
  ];

  late TextEditingController _firstnameTxt;
  late TextEditingController _lastnameTxt;
  late TextEditingController _emailTxt;
  late TextEditingController _telPhoneTxt;
  late TextEditingController _weightTxt;
  late TextEditingController _heightTxt;
  late TextEditingController _gestationalWeekText;

  late String _pregnantStatusValue = '0';
  late String imagePath;

  late MotherInfo motherInfo;

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
    _weightTxt = TextEditingController();
    _heightTxt = TextEditingController();
    _gestationalWeekText = TextEditingController();
  }

  onRefresh(bool isVisible) {
    if (isVisible && !firstFlag) {
      firstFlag = true;

      imagePath = "";

      _findMotherInfo();
    } else if (!isVisible) {
      firstFlag = false;
    }
  }

  _findMotherInfo() {
    storage.read(key: "username").then((username) => {
      motherInfoService.findByUsername(username!).then((mom) {
        setState(() {
          motherInfo = mom;

          _firstnameTxt.text = mom.firstname;
          _lastnameTxt.text = mom.lastname;
          _emailTxt.text = mom.email;
          _telPhoneTxt.text = mom.telPhone;
          _weightTxt.text = mom.weight.toString();
          _heightTxt.text = mom.height.toString();
          _gestationalWeekText.text = _findWeekBetweenDate(mom.gestationalAge).toString();
          imagePath = mom.imagePath;
        });
      })
    });
  }

  _findWeekBetweenDate(String gestationalAge) {
    final gestationalDate = DateTime.parse(gestationalAge);
    final currentDate = DateTime.now();

    final difference = currentDate.difference(gestationalDate).inDays;

    return (difference / 7).round();
  }

  _updateStaffInfo(BuildContext context) {
    motherInfo.firstname = _firstnameTxt.text;
    motherInfo.lastname = _lastnameTxt.text;
    motherInfo.email = _emailTxt.text;
    motherInfo.telPhone = _telPhoneTxt.text;
    motherInfo.weight = double.parse(_weightTxt.text);
    motherInfo.height = double.parse(_heightTxt.text);
    motherInfo.pregnantStatus = int.parse(_pregnantStatusValue);
    motherInfo.image = _imageLocalPath;

    motherInfoService.updateMotherInfo(motherInfo).then((staff) {
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
      key: const Key(MomProfileEditScreen.ROUTE_ID),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: TextFieldCustom(
                                hintText: "น้ำหนัก",
                                controller: _weightTxt,
                                isLabel: true,
                                keyboardType: TextInputType.number,
                                inputWidth: 0.4,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: TextFieldCustom(
                                hintText: "ส่วนสูง",
                                controller: _heightTxt,
                                isLabel: true,
                                keyboardType: TextInputType.number,
                                inputWidth: 0.4,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 5,
                                child: DropdownCustom(
                                  hintText: "สถานะ",
                                  dropdownValue: _pregnantStatusValue,
                                  dropdownItems: pregnantStatusMapList,
                                  isLabel: true,
                                  inputWidth: 0.4,
                                  onChanged: (value) {
                                    setState(() {
                                      _pregnantStatusValue = value;
                                    });
                                  },
                                )
                            ),
                            Expanded(
                              flex: 5,
                              child: TextFieldCustom(
                                hintText: "อายุครรภ์",
                                controller: _gestationalWeekText,
                                isLabel: true,
                                keyboardType: TextInputType.number,
                                inputWidth: 0.4,
                              ),
                            )
                          ],
                        ),
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