import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_101/screens/mom/sub/mom_profile_edit_screen.dart';
import 'package:flutter_101/service/hospital_service.dart';
import 'package:flutter_101/service/mother_info_service.dart';
import 'package:flutter_101/service/staff_info_service.dart';
import 'package:flutter_101/utils/global.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MomProfileScreen extends StatefulWidget {
  const MomProfileScreen(): super();

  static const String ROUTE_ID = 'mom_profile_screen';

  @override
  _MomProfileScreenState createState() => _MomProfileScreenState();
}

class _MomProfileScreenState extends State<MomProfileScreen> {

  static const storage = FlutterSecureStorage();

  MotherInfoService motherInfoService = MotherInfoService();
  StaffInfoService staffInfoService = StaffInfoService();
  HospitalService hospitalService = HospitalService();

  late bool firstFlag;

  late String motherName;
  late String motherTel;
  late String motherEmail;
  late String motherPid;
  late int gestationalWeek;
  late int motherAge;
  late double motherWeight;
  late double motherHeight;
  late String imagePath;
  late String tumbonCode;

  @override
  void initState() {
    super.initState();

    motherName = "";
    motherTel = "";
    motherEmail = "";
    motherPid = "";
    gestationalWeek = 0;
    motherAge = 0;
    motherWeight = 0;
    motherHeight = 0;
    imagePath = "";
    tumbonCode = "";

    firstFlag = false;
  }

  onRefresh(bool isVisible) {
    if (isVisible && !firstFlag) {
      firstFlag = true;

      motherName = "";
      motherTel = "";
      motherEmail = "";
      motherPid = "";
      gestationalWeek = 0;
      motherAge = 0;
      motherWeight = 0;
      motherHeight = 0;
      imagePath = "";
      tumbonCode = "";

      _findByUsername();
    } else if (!isVisible) {
      firstFlag = false;
    }
  }

  _findByUsername() {
    storage.read(key: "username").then((username) {
      motherInfoService.findByUsername(username!).then((value) {
        setState(() {
          motherName = "${value.firstname} ${value.lastname}";
          motherTel = value.telPhone;
          motherEmail = value.email;
          motherPid = value.pid;
          gestationalWeek = _findWeekBetweenDate(value.gestationalAge);
          motherAge = 35;
          motherWeight = value.weight;
          motherHeight = value.height;
          imagePath = value.imagePath;
        });

        staffInfoService.findById(value.staffId).then((staffObj) {
          hospitalService.findHospitalById(staffObj.hospitalId).then((hospitalObj) {
            setState(() {
              tumbonCode = hospitalObj.tumbonCode;
            });
          });
        });
      });
    });
  }

  _findWeekBetweenDate(String gestationalAge) {
    final gestationalDate = DateTime.parse(gestationalAge);
    final currentDate = DateTime.now();

    final difference = currentDate.difference(gestationalDate).inDays;

    return (difference / 7).round();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key(MomProfileScreen.ROUTE_ID),
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
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          motherName,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500
                                          ),
                                        ),
                                        const SizedBox(height: 10.0,),
                                        Text(
                                          motherEmail,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 5.0,),
                                        Text(
                                          motherTel,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
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
                                Navigator.of(context, rootNavigator: true).pushNamed(MomProfileEditScreen.ROUTE_ID);
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
                      Text(
                          'อายุครรภ์ $gestationalWeek สัปดาห์',
                          style: const TextStyle(
                            fontSize: 14,
                          )
                      ),
                      const SizedBox(height: 20.0,),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "ข้อมูลคุณแม่",
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
                                              motherEmail,
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
                                              'น้ำหนัก',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              "$motherWeight กก.",
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
                                              'ส่วนสูง',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              "$motherHeight ซม.",
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
                                              'พื้นที่',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              tumbonCode,
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