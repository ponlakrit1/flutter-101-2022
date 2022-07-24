import 'package:dio/dio.dart';
import 'package:flutter_101/model/entity/answer.dart';
import 'package:flutter_101/service/base_dio.dart';

class AnswerService extends BaseDio {

  Future<List<Answer>> findByQuestionId(int questionId) async {
    List<Answer> resultList = [];

    Response<List<dynamic>> response = await dioMethod.get('/answer/all/$questionId');

    if (response.statusCode == 201 || response.statusCode == 200) {
      List dataItem = response.data!;
      for (var i in dataItem) {
        resultList.add(Answer.fromJson(i));
      }
      return resultList;
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

}