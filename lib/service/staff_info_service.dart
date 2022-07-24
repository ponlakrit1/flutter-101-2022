import 'package:dio/dio.dart';
import 'package:flutter_101/model/entity/staff_info.dart';
import 'package:flutter_101/model/res/count_response.dart';
import 'base_dio.dart';

class StaffInfoService extends BaseDio {

  Future<StaffInfo> staffLogin(String email) async {
    Response<List<dynamic>> response = await dioMethod.get('/staff/find/email-like/$email/3');

    if (response.statusCode == 201 || response.statusCode == 200) {
      List dataItem = response.data!;
      return StaffInfo.fromJson(dataItem[0]);
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

  Future<CountResponse> findStaffAmountByStaffLevel(int staffLevel) async {
    Response<Map<String, dynamic>> response = await dioMethod.get('/staff/count/$staffLevel');

    if (response.statusCode == 201 || response.statusCode == 200) {
      return CountResponse.fromJson(response.data!);
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

  Future<StaffInfo> findById(int staffId) async {
    Response<Map<String, dynamic>> response = await dioMethod.get('/staff/$staffId');

    if (response.statusCode == 201 || response.statusCode == 200) {
      return StaffInfo.fromJson(response.data!);
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

  Future<StaffInfo> updateStaffInfo(StaffInfo item) async {
    FormData formData = FormData.fromMap({
      "staffId": item.staffId,
      "email": item.email,
      "firstname": item.firstname,
      "lastname": item.lastname,
      "address": item.address,
      "telPhone": item.telPhone,
      "staffLevel": item.staffLevel,
      "imagePath": item.imagePath,
      "hospitalId": item.hospitalId,
    });

    if (item.image != "") {
      formData.files.addAll([
        MapEntry('image', await MultipartFile.fromFile(item.image ?? ""),
        ),
      ]);
    }

    Response<Map<String, dynamic>> response = await dioMethod.put(
        '/staff',
        data: formData
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return StaffInfo.fromJson(response.data!);
    } else if(response.statusCode == 409) {
      throw Exception('Failed to update 409');
    } else {
      throw Exception('Failed to update');
    }
  }

}