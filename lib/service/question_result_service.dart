import 'package:dio/dio.dart';
import 'package:flutter_101/model/entity/question_result.dart';
import 'package:flutter_101/service/base_dio.dart';

class QuestionResultService extends BaseDio {

  Future<List<QuestionResult>> createMultiQuestionResult(List<QuestionResult> request) async {
    List<QuestionResult> resultList = [];

    Response<List<dynamic>> response = await dioMethod.post(
        '/question-result/multi',
        data: request
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      List dataItem = response.data!;
      for (var i in dataItem) {
        resultList.add(QuestionResult.fromJson(i));
      }
      return resultList;
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

}