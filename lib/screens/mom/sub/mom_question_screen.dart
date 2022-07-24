import 'package:custom_radio_group_list/custom_radio_group_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_101/service/evaluation_form_service.dart';
import 'package:flutter_101/utils/utils.dart';
import 'package:intl/intl.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_101/model/entity/evaluation_result.dart';
import 'package:flutter_101/model/entity/question.dart';
import 'package:flutter_101/model/entity/question_result.dart';
import 'package:flutter_101/service/answer_service.dart';
import 'package:flutter_101/service/evaluation_result_service.dart';
import 'package:flutter_101/service/question_result_service.dart';
import 'package:flutter_101/service/question_service.dart';
import 'package:flutter_101/widget/text_field_custom.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MomQuestionScreen extends StatefulWidget {
  const MomQuestionScreen(): super();

  static const String ROUTE_ID = 'mom_question_screen';

  @override
  _MomQuestionScreenState createState() => _MomQuestionScreenState();
}

class _MomQuestionScreenState extends State<MomQuestionScreen> {

  static const storage = FlutterSecureStorage();

  AnswerService answerService = AnswerService();
  QuestionService questionService = QuestionService();
  QuestionResultService questionResultService = QuestionResultService();
  EvaluationResultService evaluationResultService = EvaluationResultService();
  EvaluationFormService evaluationFormService = EvaluationFormService();

  late bool firstFlag;

  late int evaluationFormId;
  late int momId;
  late String specialCode;
  late int criteriaPoint;

  late List<Question> questionList;
  late List<TextEditingController> textControllers;
  late List<String> answerList;

  @override
  void initState() {
    super.initState();

    questionList = [];
    textControllers = [];
    answerList = [];

    evaluationFormId = 0;
    momId = 0;
    specialCode = "";
    criteriaPoint = 0;

    firstFlag = false;
  }

  onRefresh(bool isVisible) {
    if (isVisible && !firstFlag) {
      firstFlag = true;

      questionList = [];
      textControllers = [];
      answerList = [];

      evaluationFormId = 0;
      momId = 0;
      specialCode = "";
      criteriaPoint = 0;

      _findQuestionAndAnswer();
    } else if (!isVisible) {
      firstFlag = false;
    }
  }

  _findQuestionAndAnswer() {
    storage.read(key: "mom_id").then((id) {
      momId = int.parse(id!);
    });

    storage.read(key: "evaluation_form_id").then((id) {
      evaluationFormId = int.parse(id!);

      evaluationFormService.findEvaluationFormById(evaluationFormId).then((value) {
        setState(() {
          specialCode = value.specialCode;
          criteriaPoint = value.criteria;
        });
      });

      questionService.findByEvaluationFormId(evaluationFormId).then((value) {
        setState(() {
          if (value.isNotEmpty) {
            questionList = value;

            textControllers = List.generate(questionList.length, (i) => TextEditingController());
            answerList = List.generate(questionList.length, (i) => "");

            for(var i = 0; i < questionList.length; i++){
              questionList[i].index = i;

              if (questionList[i].questionType == 2) {
                // FIND ANSWER
                questionList[i].answerOptionList = [];

                answerService.findByQuestionId(questionList[i].questionId).then((ans) {
                  setState(() {
                    if (ans.isNotEmpty) {
                      // questionList[i].answerOptionList?.add({'Value': "", 'Label': ""});

                      for(var j = 0; j < ans.length; j++){
                        questionList[i].answerOptionList?.add({'Value': ans[j].answerPoint.toString(), 'Label': ans[j].answerDetail});
                      }
                    } else {
                      questionList[i].answerOptionList = [];
                    }
                  });
                });
              }
            }
          } else {
            questionList = [];
          }
        });
      });
    });
  }

  saveButtonOnClick(BuildContext context) {
    List<QuestionResult> request = [];

    for (var i in questionList) {
      QuestionResult item = QuestionResult(
          questionResultId: 0,
          result: answerList[i.index!],
          questionId: i.questionId,
          momId: momId
      );

      request.add(item);
    }

    questionResultService.createMultiQuestionResult(request).then((qr) {
      if (qr.isNotEmpty) {
        var totalPoint = getAnswerPoint();

        EvaluationResult req = EvaluationResult(
            evaluationResultId: 0,
            result: totalPoint,
            evaluationDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            resultDetail: getResultDetail(totalPoint, criteriaPoint),
            specialCode: specialCode,
            evaluationFormId: evaluationFormId,
            momId: momId
        );

        evaluationResultService.createEvaluationResult(req).then((value) {
          Utils.createToast("บันทึกสำเร็จ!", context);
          Navigator.of(context).pop();
        });
      }
    });
  }

  getAnswerPoint() {
    double point = 0;

    for(var i = 0; i < answerList.length; i++){
      if (Utils.isNumeric(answerList[i])) {
        point += double.parse(answerList[i]);
      } else {
        if (!Utils.isNullOrEmpty(answerList[i])) {
          point += 1;
        }
      }
    }

    return point.toInt();
  }

  getResultDetail(totalPoint, criteriaPoint) {
    if (totalPoint >= criteriaPoint) {
      return "มีความเสี่ยง";
    } else {
      return "ไม่มีความเสี่ยง";
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key(MomQuestionScreen.ROUTE_ID),
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
                      questionList.isNotEmpty ?
                      _getQuestionListWidgets() :
                      const Text("ไม่พบคำถาม", style: TextStyle(fontSize: 14,),),
                      const SizedBox(height: 20.0,),
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
                              saveButtonOnClick(context);
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

  Widget _getQuestionListWidgets(){
    return Column(
        children: questionList.map((i) => Card(
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
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${i.index! + 1}. ${i.questionDetail}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                        )
                                    ),
                                    i.questionType == 1 ?
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: TextFieldCustom(
                                        hintText: "คำตอบ",
                                        controller: textControllers[i.index!],
                                        isLabel: false,
                                        keyboardType: TextInputType.text,
                                        inputWidth: 0.8,
                                      ),
                                    ) : Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: RadioGroup(
                                          radioListObject: questionList[i.index!].answerOptionList,
                                          selectedItem: 0,
                                          textParameterName: 'Label',
                                          onChanged: (value) {
                                            Map<String, String> mapItem = value;
                                            answerList[i.index!] = mapItem["Value"] ?? "";
                                          },
                                          disabled: false
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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

}