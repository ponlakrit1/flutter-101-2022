import 'package:dio/dio.dart';
import 'package:flutter_101/model/entity/question.dart';
import 'package:flutter_101/service/base_dio.dart';

class QuestionService extends BaseDio {

  Future<List<Question>> findByEvaluationFormId(int evaluationFormId) async {
    List<Question> resultList = [];

    Response<List<dynamic>> response = await dioMethod.get('/question/all/$evaluationFormId');

    if (response.statusCode == 201 || response.statusCode == 200) {
      List dataItem = response.data!;
      for (var i in dataItem) {
        resultList.add(Question.fromJson(i));
      }
      return resultList;
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

}