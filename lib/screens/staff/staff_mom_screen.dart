import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_101/model/entity/mother_info.dart';
import 'package:flutter_101/screens/staff/sub/staff_mom_profile_screen.dart';
import 'package:flutter_101/service/hospital_service.dart';
import 'package:flutter_101/service/mother_info_service.dart';
import 'package:flutter_101/service/staff_info_service.dart';
import 'package:flutter_101/utils/global.dart';
import 'package:flutter_101/utils/utils.dart';
import 'package:visibility_detector/visibility_detector.dart';

class StaffMomScreen extends StatefulWidget {
  const StaffMomScreen(): super();

  static const String ROUTE_ID = 'staff_mom_screen';

  @override
  _StaffMomScreenState createState() => _StaffMomScreenState();
}

class _StaffMomScreenState extends State<StaffMomScreen> {

  static const storage = FlutterSecureStorage();

  StaffInfoService staffInfoService = StaffInfoService();
  HospitalService hospitalService = HospitalService();
  MotherInfoService motherInfoService = MotherInfoService();

  late bool firstFlag;

  late String hospitalName;
  late String staffName;
  late int staffId;

  late List<MotherInfo> motherList;

  @override
  void initState() {
    super.initState();

    firstFlag = false;

    hospitalName = "";
    staffName = "";

    motherList = [];
  }

  onRefresh(bool isVisible) {
    if (isVisible && !firstFlag) {
      firstFlag = true;

      hospitalName = "";
      staffName = "";

      motherList = [];

      _findMotherByStaffId();
    } else if (!isVisible) {
      firstFlag = false;
    }
  }

  _findMotherByStaffId() {
    storage.read(key: "username").then((username) => {
      staffInfoService.staffLogin(username!).then((staff) {
        setState(() {
          staffId = staff.staffId;
          staffName = "${staff.firstname} ${staff.lastname}";
        });

        // FIND MOTHER
        motherInfoService.findByStaffId(staffId).then((mother) {
          setState(() {
            if (mother.isNotEmpty) {
              motherList = mother;
            }
          });
        });

        // FIND HOSPITAL NAME
        hospitalService.findHospitalById(staff.hospitalId).then((hospital) {
          setState(() {
            hospitalName = hospital.hospitalName;
          });
        });
      })
    });
  }

  _findMotherByStaffIdAndNameCriteria(String nameCriteria) {
    if (!Utils.isNullOrEmpty(nameCriteria)) {
      motherInfoService.findByStaffIdAndNameCriteria(staffId, nameCriteria).then((mother) {
        setState(() {
          if (mother.isNotEmpty) {
            motherList = mother;
          } else {
            motherList = [];
          }
        });
      });
    } else {
      motherInfoService.findByStaffId(staffId).then((mother) {
        setState(() {
          if (mother.isNotEmpty) {
            motherList = mother;
          } else {
            motherList = [];
          }
        });
      });
    }

  }

  findWeekBetweenDate(String gestationalAge) {
    final gestationalDate = DateTime.parse(gestationalAge);
    final currentDate = DateTime.now();

    final difference = currentDate.difference(gestationalDate).inDays;

    return (difference / 7).round();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key(StaffMomScreen.ROUTE_ID),
      onVisibilityChanged: (VisibilityInfo info) {
        bool isVisible = info.visibleFraction != 0;
        onRefresh(isVisible);
      },
      child: Scaffold(
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
                  padding: const EdgeInsets.only(top: 40, bottom: 60, left: 20, right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage("lib/asset/imgs/mother.png"),
                        height: 150,
                        width: 150,
                      ),
                      const SizedBox(height: 10.0,),
                      const Center(
                        child: Text(
                          "รายชื่อคุณแม่ตั้งครรภ์",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0,),
                      const Center(
                        child: Text(
                          "คุณแม่ตั้งครรภ์ ดูแลโดย",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0,),
                      Center(
                        child: Text(
                          hospitalName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            4, 0, 4, 15),
                        child: Container(
                          width: 300,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.black12,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 0),
                            child: TextFormField(
                              textInputAction: TextInputAction.go,
                              obscureText: false,
                              decoration: const InputDecoration(
                                hintText: 'ค้นหาชื่อ',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius:
                                  BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius:
                                  BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                              ),
                              onFieldSubmitted: (value) {
                                _findMotherByStaffIdAndNameCriteria(value);
                              },
                            ),
                          ),
                        ),
                      ),
                      GridView.builder(
                        primary: false,
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 250.0,
                        ),
                        itemCount: motherList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                              decoration: const BoxDecoration(
                                  color: Color(0xFFFFA5A0),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                          "${Global.rootURL}/uploads/${motherList[index].imagePath}",
                                          width: 50.0,
                                          height: 50.0,
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                            return Image.asset(
                                              'lib/asset/imgs/no-image.png',
                                              width: 50.0,
                                              height: 50.0,
                                              fit: BoxFit.cover,
                                            );
                                          }
                                      ),
                                    ),
                                    const SizedBox(height: 5.0,),
                                    Text(
                                      "${motherList[index].firstname} ${motherList[index].lastname}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0,),
                                    Text(
                                      "${findWeekBetweenDate(motherList[index].gestationalAge)} สัปดาห์",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white
                                      ),
                                    ),
                                    const SizedBox(height: 5.0,),
                                    const Text(
                                      "อสม. ที่ดูแล",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white
                                      ),
                                    ),
                                    const SizedBox(height: 5.0,),
                                    Text(
                                      staffName,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white
                                      ),
                                    ),
                                    RaisedButton(
                                        child: const Text(
                                          'ดูเพิ่มเติม',
                                          style: TextStyle(
                                            color: Color(0xFFFFA5A0),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        color: const Color(0xFFFFD5D2),
                                        onPressed: () {
                                          storage.write(key: "mom_id", value: motherList[index].momId.toString());

                                          Navigator.of(context, rootNavigator: true).pushNamed(StaffMomProfileScreen.ROUTE_ID);
                                        }
                                    ),
                                  ],
                                ),
                              )
                          );
                        },
                      )
                    ],
                  )
              ),
            ),
          )
      ),
    );
  }

}