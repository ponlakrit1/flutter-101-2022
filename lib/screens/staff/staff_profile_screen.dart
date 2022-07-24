import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_101/screens/staff/sub/staff_profile_edit_screen.dart';
import 'package:flutter_101/service/hospital_service.dart';
import 'package:flutter_101/service/staff_info_service.dart';
import 'package:flutter_101/utils/global.dart';
import 'package:visibility_detector/visibility_detector.dart';

class StaffProfileScreen extends StatefulWidget {
  const StaffProfileScreen(): super();

  static const String ROUTE_ID = 'staff_profile_screen';

  @override
  _StaffProfileScreenState createState() => _StaffProfileScreenState();
}

class _StaffProfileScreenState extends State<StaffProfileScreen> {

  static const storage = FlutterSecureStorage();

  StaffInfoService staffInfoService = StaffInfoService();
  HospitalService hospitalService = HospitalService();

  late bool firstFlag;

  late String staffName;
  late String staffEmail;
  late String staffTel;
  late String hospitalName;
  late String hospitalTumbon;
  late String imagePath;

  @override
  void initState() {
    super.initState();

    firstFlag = false;

    staffName = "";
    staffEmail = "";
    staffTel = "";
    hospitalName = "";
    hospitalTumbon = "";
    imagePath = "";
  }

  onRefresh(bool isVisible) {
    if (isVisible && !firstFlag) {
      firstFlag = true;

      staffName = "";
      staffEmail = "";
      staffTel = "";
      hospitalName = "";
      hospitalTumbon = "";
      imagePath = "";

      _findStaffInfo();
    } else if (!isVisible) {
      firstFlag = false;
    }
  }

  _findStaffInfo() {
    storage.read(key: "username").then((username) => {
      staffInfoService.staffLogin(username!).then((staff) {
        setState(() {
          staffName = "${staff.firstname} ${staff.lastname}";
          staffEmail = staff.email;
          staffTel = staff.telPhone;
          imagePath = staff.imagePath;
        });

        // FIND HOSPITAL NAME
        hospitalService.findHospitalById(staff.hospitalId).then((hospital) {
          setState(() {
            hospitalName = hospital.hospitalName;
            hospitalTumbon = hospital.tumbonCode;
          });
        });
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key(StaffProfileScreen.ROUTE_ID),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                            child: TextButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  useSafeArea: true,
                                  barrierDismissible: false,
                                  builder: (context) => Container(
                                      child: AlertDialog(
                                        title: const Text('แจ้งเตือน'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const <Widget>[
                                              Text('คุณต้องการออกจากระบบหรือไม่?'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('ยกเลิก'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('ตกลง'),
                                            onPressed: () {
                                              _onLogout(context);
                                            },
                                          ),
                                        ],
                                      )
                                  ),
                                );
                              },
                              child: const Text('ออกจากระบบ'),
                            )
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: ClipOval(
                              child: Image.network(
                                  "${Global.rootURL}/uploads/$imagePath",
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    return Image.asset(
                                      'lib/asset/imgs/no-image.png',
                                      width: 100.0,
                                      height: 100.0,
                                      fit: BoxFit.cover,
                                    );
                                  }
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Card(
                              margin: const EdgeInsets.only(left: 20.0),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 5,
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
                                  child: Text(
                                    staffName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                            child: TextButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                              ),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).pushNamed(StaffProfileEditScreen.ROUTE_ID);
                              },
                              child: const Text('แก้ไข'),
                            )
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "สถานะ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFB5D8FF)
                          ),
                          height: 150.0,
                          width: 200.0,
                          child: const Center(
                            child: Image(
                              fit: BoxFit.contain,
                              image: AssetImage("lib/asset/imgs/mother.png"),
                              height: 100,
                              width: 100,
                            ),
                          )
                      ),
                      const SizedBox(height: 15.0,),
                      const Text(
                          'เจ้าหน้าที่ อสม.',
                          style: TextStyle(
                            fontSize: 14,
                          )
                      ),
                      const SizedBox(height: 20.0,),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "ข้อมูล",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      GridView.count(
                        primary: false,
                        shrinkWrap: true,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        crossAxisCount: 2,
                        children: [
                          Container(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      const Image(
                                        image: AssetImage("lib/asset/imgs/mother.png"),
                                        height: 60,
                                        width: 60,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Email',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              staffEmail,
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                          ),
                          Container(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      const Image(
                                        image: AssetImage("lib/asset/imgs/mother.png"),
                                        height: 60,
                                        width: 60,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'เบอร์โทร',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              staffTel,
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                          ),
                          Container(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      const Image(
                                        image: AssetImage("lib/asset/imgs/mother.png"),
                                        height: 60,
                                        width: 60,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'รพสต.',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              hospitalName,
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                          ),
                          Container(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      const Image(
                                        image: AssetImage("lib/asset/imgs/mother.png"),
                                        height: 60,
                                        width: 60,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'พื้นที่',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              hospitalTumbon,
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                          )
                        ],
                      )
                    ],
                  )
              ),
            ),
          )
      ),
    );
  }

  _onLogout(BuildContext context) {
    storage.delete(key: "username");

    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

}