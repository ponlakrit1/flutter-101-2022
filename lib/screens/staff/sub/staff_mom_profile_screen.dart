import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_101/screens/staff/sub/staff_evaluation_screen.dart';
import 'package:flutter_101/service/mother_info_service.dart';
import 'package:flutter_101/utils/global.dart';
import 'package:visibility_detector/visibility_detector.dart';

class StaffMomProfileScreen extends StatefulWidget {
  const StaffMomProfileScreen(): super();

  static const String ROUTE_ID = 'staff_mom_profile_screen';

  @override
  _StaffMomProfileScreenState createState() => _StaffMomProfileScreenState();
}

class _StaffMomProfileScreenState extends State<StaffMomProfileScreen> {

  static const storage = FlutterSecureStorage();

  MotherInfoService motherInfoService = MotherInfoService();

  late bool firstFlag;

  late int momId;
  late String motherName;
  late String motherTel;
  late String motherEmail;
  late String motherPid;
  late int gestationalWeek;
  late int motherAge;
  late double motherWeight;
  late double motherHeight;
  late String imagePath;

  @override
  void initState() {
    super.initState();

    momId = 0;
    motherName = "";
    motherTel = "";
    motherEmail = "";
    motherPid = "";
    gestationalWeek = 0;
    motherAge = 0;
    motherWeight = 0;
    motherHeight = 0;
    imagePath = "";

    firstFlag = false;
  }

  onRefresh(bool isVisible) {
    if (isVisible && !firstFlag) {
      firstFlag = true;

      momId = 0;
      motherName = "";
      motherTel = "";
      motherEmail = "";
      motherPid = "";
      gestationalWeek = 0;
      motherAge = 0;
      motherWeight = 0;
      motherHeight = 0;
      imagePath = "";

      _findByMomId();
    } else if (!isVisible) {
      firstFlag = false;
    }
  }

  _findByMomId() {
    storage.read(key: "mom_id").then((momIdValue) {
      motherInfoService.findById(int.parse(momIdValue!)).then((value) {
        setState(() {
          momId = value.momId;
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
      key: const Key(StaffMomProfileScreen.ROUTE_ID),
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
                  padding: const EdgeInsets.only(top: 0, bottom: 60, left: 20, right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: Container(
                      //       child: TextButton(
                      //         style: ButtonStyle(
                      //           foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                      //         ),
                      //         onPressed: () {
                      //           showDialog(
                      //             context: context,
                      //             useSafeArea: true,
                      //             barrierDismissible: false,
                      //             builder: (context) => Container(
                      //                 child: AlertDialog(
                      //                   title: const Text('แจ้งเตือน'),
                      //                   content: SingleChildScrollView(
                      //                     child: ListBody(
                      //                       children: const <Widget>[
                      //                         Text('คุณต้องการออกจากระบบหรือไม่?'),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                   actions: <Widget>[
                      //                     TextButton(
                      //                       child: const Text('ยกเลิก'),
                      //                       onPressed: () {
                      //                         Navigator.of(context).pop();
                      //                       },
                      //                     ),
                      //                     TextButton(
                      //                       child: const Text('ตกลง'),
                      //                       onPressed: () {
                      //                         _onLogout(context);
                      //                       },
                      //                     ),
                      //                   ],
                      //                 )
                      //             ),
                      //           );
                      //         },
                      //         child: const Text('ออกจากระบบ'),
                      //       )
                      //   ),
                      // ),
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
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: Container(
                      //       child: TextButton(
                      //         style: ButtonStyle(
                      //           foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      //         ),
                      //         onPressed: () {
                      //           Navigator.of(context, rootNavigator: true).pushNamed(MomProfileEditScreen.ROUTE_ID);
                      //         },
                      //         child: const Text('แก้ไข'),
                      //       )
                      //   ),
                      // ),
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
                                        height: 80,
                                        width: 80,
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
                                              'เลขบัตรประชาชน',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              motherPid,
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
                          )
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: RaisedButton.icon(
                            icon: const Icon(
                              Icons.analytics,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'ทำแบบประเมิน',
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
                              storage.write(key: "mom_id", value: momId.toString());

                              Navigator.of(context, rootNavigator: true).pushNamed(StaffEvaluationScreen.ROUTE_ID);
                            }
                        ),
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