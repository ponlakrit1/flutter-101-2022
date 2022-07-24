import 'package:dio/dio.dart';
import 'package:flutter_101/model/entity/evaluation_result.dart';
import 'package:flutter_101/service/base_dio.dart';

class EvaluationResultService extends BaseDio {

  Future<EvaluationResult> createEvaluationResult(EvaluationResult request) async {
    Response<Map<String, dynamic>> response = await dioMethod.post(
        '/evaluation-result',
        data: request
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return EvaluationResult.fromJson(response.data!);
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

}