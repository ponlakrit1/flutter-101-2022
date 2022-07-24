import 'package:dio/dio.dart';
import 'package:flutter_101/model/entity/evaluation_form.dart';
import 'package:flutter_101/service/base_dio.dart';

class EvaluationFormService extends BaseDio {

  Future<List<EvaluationForm>> findAvailableEvaluationForm(String pregnantWeek, int momId) async {
    List<EvaluationForm> resultList = [];

    Response<List<dynamic>> response = await dioMethod.get('/evaluation-form/find/available/$pregnantWeek/$momId');

    if (response.statusCode == 201 || response.statusCode == 200) {
      List dataItem = response.data!;
      for (var i in dataItem) {
        resultList.add(EvaluationForm.fromJson(i));
      }
      return resultList;
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

  Future<EvaluationForm> findEvaluationFormById(int evaluationFormId) async {
    Response<Map<String, dynamic>> response = await dioMethod.get('/evaluation-form/$evaluationFormId');

    if (response.statusCode == 201 || response.statusCode == 200) {
      return EvaluationForm.fromJson(response.data!);
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

}