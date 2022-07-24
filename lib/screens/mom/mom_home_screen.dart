import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_101/model/entity/evaluation_form.dart';
import 'package:flutter_101/screens/staff/sub/staff_question_screen.dart';
import 'package:flutter_101/service/evaluation_form_service.dart';
import 'package:flutter_101/service/mother_info_service.dart';
import 'package:flutter_101/utils/global.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:intl/intl.dart';

class MomHomeScreen extends StatefulWidget {
  const MomHomeScreen(): super();

  static const String ROUTE_ID = 'mom_home_screen';

  @override
  _MomHomeScreenState createState() => _MomHomeScreenState();
}

class _MomHomeScreenState extends State<MomHomeScreen> {

  static const storage = FlutterSecureStorage();

  EvaluationFormService evaluationFormService = EvaluationFormService();
  MotherInfoService motherInfoService = MotherInfoService();

  late bool firstFlag;

  late String motherName;
  late int gestationalWeek;
  late int gestationalMonth;
  late int motherAge;
  late String gestationalAge;
  late String gestationalAgeDB;
  late String bmi;
  late String bmiText;
  late int momId;

  late List<EvaluationForm> evaluationFormList;

  @override
  void initState() {
    super.initState();

    motherName = "";
    gestationalWeek = 0;
    gestationalMonth = 1;
    motherAge = 0;
    gestationalAge = "";
    gestationalAgeDB = "";
    bmi = "";
    bmiText = "";
    momId = 0;

    evaluationFormList = [];

    firstFlag = false;
  }

  onRefresh(bool isVisible) {
    if (isVisible && !firstFlag) {
      firstFlag = true;

      motherName = "";
      gestationalWeek = 0;
      gestationalMonth = 1;
      motherAge = 0;
      gestationalAge = "";
      gestationalAgeDB = "";
      bmi = "";
      bmiText = "";
      momId = 0;

      evaluationFormList = [];

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
          gestationalWeek = _findWeekBetweenDate(value.gestationalAge);
          gestationalMonth = _findGestationalMonth(gestationalWeek);
          motherAge = 35;
          gestationalAge = _getGestationalAgeWithNameTh(value.gestationalAge);
          gestationalAgeDB = value.gestationalAge;
          momId = value.momId;

          _getBmi(value.height, value.weight);
        });

        evaluationFormService.findAvailableEvaluationForm(gestationalWeek.toString(), momId).then((value) {
          setState(() {
            if (value.isNotEmpty) {
              evaluationFormList = value;
            } else {
              evaluationFormList = [];
            }
          });
        });
      });
    });
  }

  _findGestationalMonth(gestationalWeek) {
    int month = gestationalWeek ~/ 4;

    if (month <= 0) {
      month = 1;
    } else if (month > 9) {
      month = 9;
    }

    return month;
  }

  _findWeekBetweenDate(String gestationalAge) {
    final gestationalDate = DateTime.parse(gestationalAge);
    final currentDate = DateTime.now();

    final difference = currentDate.difference(gestationalDate).inDays;

    return (difference / 7).round();
  }

  _getGestationalAgeWithNameTh(String gestationalAge) {
    final gestationalDate = DateTime.parse(gestationalAge);
    final monthTh = Global.monthTh[gestationalDate.month - 1];

    return "${gestationalDate.day} $monthTh ${gestationalDate.year}";
  }

  _getBmi(double height, double weight) {
    final heightM = height / 100;
    final bmiNum = weight / (heightM * heightM);

    if (bmiNum < 18.5) {
      bmiText = "น้ำหนักน้อย / ผอม";
    } else if (bmiNum >= 18.5 && bmiNum < 23) {
      bmiText = "ปกติ (สุขภาพดี)";
    } else if (bmiNum >= 23 && bmiNum < 25) {
      bmiText = "ท้วม / โรคอ้วนระดับ 1";
    } else if (bmiNum >= 35 && bmiNum < 30) {
      bmiText = "อ้วน / โรคอ้วนระดับ 2";
    } else if (bmiNum >= 30) {
      bmiText = "อ้วนมาก / โรคอ้วนระดับ 3";
    }

    bmi = bmiNum.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key(MomHomeScreen.ROUTE_ID),
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
                image: AssetImage("lib/asset/imgs/bg/bg-mom-main.PNG"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 60),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          motherName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 5,
                                child: Column(
                                  children: [
                                    Text(
                                        gestationalAge,
                                        style: const TextStyle(
                                          fontSize: 21,
                                          color: Colors.white,
                                        )
                                    ),
                                    const SizedBox(height: 10.0,),
                                    Stack(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                                            child: Container(
                                              width: MediaQuery.of(context).size.width * 0.45,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.only(
                                                      topRight:  Radius.circular(10.0),
                                                      bottomRight: Radius.circular(10.0)
                                                  )
                                              ),
                                              child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                            'BMI $bmi',
                                                            style: const TextStyle(
                                                              fontSize: 18,
                                                              color: Colors.black,
                                                            )
                                                        ),
                                                        Text(
                                                            bmiText,
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.black,
                                                            )
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                              ),
                                            )
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                                          child: Row(
                                            children: const [
                                              Image(
                                                image: AssetImage("lib/asset/imgs/mother.png"),
                                                height: 100,
                                                width: 100,
                                              ),
                                              // Text(
                                              //     'อายุ $motherAge ปี',
                                              //     style: TextStyle(
                                              //       fontSize: 20,
                                              //     )
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                            ),
                            Expanded(
                              flex: 5,
                              child: Card(
                                color: const Color(0xFF8AF2C5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 5,
                                child: Container(
                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Image(
                                                  image: AssetImage("lib/asset/imgs/smiling-face.png"),
                                                  height: 50,
                                                  width: 50,
                                                ),
                                                Container(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Column(
                                                      children: const [
                                                        Text(
                                                            'ไม่พบความเสี่ยง',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                            )
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 15.0,),
                                            Row(
                                              children: [
                                                const Text(
                                                    'ผลประเมิน',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    )
                                                ),
                                                const SizedBox(width: 10.0,),
                                                RaisedButton(
                                                    child: const Text(
                                                      'ดูข้อมูล',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                    ),
                                                    color: Colors.white,
                                                    onPressed: () {
                                                    }
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 15.0,),
                            Image(
                              image: AssetImage("lib/asset/imgs/mom/${gestationalMonth}M.png"),
                              height: 150,
                              width: 150,
                            ),
                            const SizedBox(height: 15.0,),
                            Text(
                                'อายุครรภ์ $gestationalWeek สัปดาห์',
                                style: const TextStyle(
                                  fontSize: 24,
                                )
                            ),
                            const SizedBox(height: 20.0,),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  'แบบประเมิน',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )
                              ),
                            ),
                            const SizedBox(height: 10.0,),
                            evaluationFormList.isNotEmpty ?
                            _getEvaluationFormListWidgets() :
                            const Text("ไม่พบแบบประเมินที่ต้องทำประจำสัปดาห์นี้", style: TextStyle(fontSize: 14,),),
                          ],
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

  Widget _getEvaluationFormListWidgets(){
    return Column(
        children: evaluationFormList.map((i) => Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 5,
          child: Container(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 5.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Image(
                            image: AssetImage("lib/asset/imgs/evaluation-icon.png"),
                            height: 70,
                            width: 70,
                          ),
                          const SizedBox(width: 5.0,),
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        i.evaluationName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                        )
                                    ),
                                    Text(
                                        'ทำได้ถึง',
                                        style: const TextStyle(
                                            fontSize: 14
                                        )
                                    ),
                                    Text(
                                        '${_currentWeekDisplay(gestationalAgeDB)}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.deepOrangeAccent
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                            onPressed: () {
                              storage.write(key: "evaluation_form_id", value: i.evaluationFormId.toString());
                              storage.write(key: "mom_id", value: momId.toString());

                              Navigator.of(context, rootNavigator: true).pushNamed(StaffQuestionScreen.ROUTE_ID);
                            },
                            child: const Text('เริ่มทำเลย'),
                          )
                        ],
                      ),
                    ],
                  )
              )
          ),
        ),
        ).toList()
    );
  }

  _currentWeekDisplay(String pregnantWeek) {
    final inputDateTime = DateTime.parse(pregnantWeek);
    final currentDateTime = DateTime.now();

    final difference = currentDateTime.difference(inputDateTime).inDays;

    int differenceRound = ((difference / 7).round() * 7);
    int differenceRoundNexWeek = (((difference / 7).round() + 1) * 7);

    final displayDate = inputDateTime.add(Duration(days: differenceRound));
    final displayDateNextWeek = inputDateTime.add(Duration(days: differenceRoundNexWeek));

    return DateFormat('dd-MM-yyyy').format(displayDate) + " - " + DateFormat('dd-MM-yyyy').format(displayDateNextWeek);
  }

}