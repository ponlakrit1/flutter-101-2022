import 'package:flutter/material.dart';
import 'package:flutter_101/screens/staff/sub/staff_question_screen.dart';
import 'package:flutter_101/service/evaluation_form_service.dart';
import 'package:intl/intl.dart';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_101/model/entity/evaluation_form.dart';
import 'package:flutter_101/model/entity/mother_info.dart';
import 'package:flutter_101/service/mother_info_service.dart';
import 'package:visibility_detector/visibility_detector.dart';

class StaffEvaluationScreen extends StatefulWidget {
  const StaffEvaluationScreen(): super();

  static const String ROUTE_ID = 'staff_evaluation_screen';

  @override
  _StaffEvaluationScreenState createState() => _StaffEvaluationScreenState();
}

class _StaffEvaluationScreenState extends State<StaffEvaluationScreen> {

  DatePickerController dp = DatePickerController();
  static const storage = FlutterSecureStorage();

  EvaluationFormService evaluationFormService = EvaluationFormService();
  MotherInfoService motherInfoService = MotherInfoService();

  late bool firstFlag;

  late int momId;
  late String gestationalDate;
  late String motherName;

  late MotherInfo motherInfo;
  late List<EvaluationForm> evaluationFormList;

  @override
  void initState() {
    super.initState();

    firstFlag = false;

    motherName = "";
    momId = 0;
    gestationalDate = "";

    evaluationFormList = [];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      dp.animateToDate(DateTime.now());
    });
  }

  onRefresh(bool isVisible) {
    if (isVisible && !firstFlag) {
      firstFlag = true;

      motherName = "";
      momId = 0;
      gestationalDate = "";

      evaluationFormList = [];

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        dp.animateToDate(DateTime.now());
      });

      _findMotherInfo();
    } else if (!isVisible) {
      firstFlag = false;
    }
  }

  _findMotherInfo() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String formattedDate = dateFormat.format(DateTime.now());

    storage.read(key: "mom_id").then((id) => {
      motherInfoService.findById(int.parse(id!)).then((mom) {
        setState(() {
          motherInfo = mom;

          motherName = "${mom.firstname} ${mom.lastname}";
          momId = mom.momId;
          gestationalDate = mom.gestationalAge;

          evaluationFormService.findAvailableEvaluationForm(_findWeekBetweenDate(formattedDate).toString(), momId).then((value) {
            setState(() {
              if (value.isNotEmpty) {
                evaluationFormList = value;
              } else {
                evaluationFormList = [];
              }
            });
          });
        });
      })
    });
  }

  _findEvaluationFormByDate(DateTime inputDate) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String formattedDate = dateFormat.format(inputDate);

    evaluationFormService.findAvailableEvaluationForm(_findWeekBetweenDate(formattedDate).toString(), momId).then((value) {
      setState(() {
        if (value.isNotEmpty) {
          evaluationFormList = value;
        } else {
          evaluationFormList = [];
        }
      });
    });
  }

  _findWeekBetweenDate(String inputDate) {
    final inputDateTime = DateTime.parse(inputDate);
    final gestationalDateTime = DateTime.parse(gestationalDate);

    final difference = inputDateTime.difference(gestationalDateTime).inDays;

    return (difference / 7).round();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key(StaffEvaluationScreen.ROUTE_ID),
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
                image: AssetImage("lib/asset/imgs/bg/bg-evaluation.PNG"),
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
                      Center(
                        child: Text(
                          "แบบประเมินของ $motherName",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      const Center(
                        child: Text(
                          "แบบประเมินเกี่ยวกับคุณแม่เพื่อดูความเสี่ยงต่างๆที่อาจจะเกิดขึ้นกับคุณแม่",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      SizedBox(
                        height: 100.0,
                        child: DatePicker(
                          DateTime.now().subtract(const Duration(days: 14)),
                          initialSelectedDate: DateTime.now(),
                          selectionColor: const Color(0xFF8EC1FD),
                          selectedTextColor: Colors.white,
                          locale: "th_TH",
                          controller: dp,
                          onDateChange: (date) {
                            setState(() {
                              _findEvaluationFormByDate(date);
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      evaluationFormList.isNotEmpty ?
                      _getEvaluationFormListWidgets() :
                      const Text("ไม่พบแบบประเมินที่ต้องทำประจำสัปดาห์นี้", style: TextStyle(fontSize: 14,),),
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
                                        '${_currentWeekDisplay(gestationalDate)}',
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