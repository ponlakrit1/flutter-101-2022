import 'package:dio/dio.dart';
import 'package:flutter_101/model/entity/hospital.dart';
import 'package:flutter_101/service/base_dio.dart';

class HospitalService extends BaseDio {

  Future<Hospital> findHospitalById(int hospitalId) async {
    Response<Map<String, dynamic>> response = await dioMethod.get('/hospital/$hospitalId');

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Hospital.fromJson(response.data!);
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

}