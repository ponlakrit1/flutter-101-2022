import 'package:dio/dio.dart';
import 'package:flutter_101/model/entity/mother_info.dart';
import 'package:flutter_101/model/res/count_response.dart';
import 'package:flutter_101/model/res/graph_response.dart';
import 'package:flutter_101/service/base_dio.dart';

class MotherInfoService extends BaseDio {

  Future<MotherInfo> motherLogin(String username, String password) async {
    Response<Map<String, dynamic>> response = await dioMethod.get('/mother/auth/$username/$password');

    if (response.statusCode == 201 || response.statusCode == 200) {
      return MotherInfo.fromJson(response.data!);
    } if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

  Future<MotherInfo> findById(int momId) async {
    Response<Map<String, dynamic>> response = await dioMethod.get('/mother/$momId');

    if (response.statusCode == 201 || response.statusCode == 200) {
      return MotherInfo.fromJson(response.data!);
    } if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

  Future<CountResponse> findMotherAmount() async {
    Response<Map<String, dynamic>> response = await dioMethod.get('/mother/count');

    if (response.statusCode == 201 || response.statusCode == 200) {
      return CountResponse.fromJson(response.data!);
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

  Future<List<GraphResponse>> findMotherGraph() async {
    List<GraphResponse> resultList = [];

    Response<List<dynamic>> response = await dioMethod.get('/mother/graph');

    if (response.statusCode == 201 || response.statusCode == 200) {
      List dataItem = response.data!;
      for (var i in dataItem) {
        resultList.add(GraphResponse.fromJson(i));
      }
      return resultList;
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

  Future<List<MotherInfo>> findByStaffIdAndNameCriteria(int staffId, String nameCriteria) async {
    List<MotherInfo> resultList = [];

    Response<List<dynamic>> response = await dioMethod.get('/mother/find/staffId/$staffId/nameCriteria/$nameCriteria');

    if (response.statusCode == 201 || response.statusCode == 200) {
      List dataItem = response.data!;
      for (var i in dataItem) {
        resultList.add(MotherInfo.fromJson(i));
      }
      return resultList;
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

  Future<List<MotherInfo>> findByStaffId(int staffId) async {
    List<MotherInfo> resultList = [];

    Response<List<dynamic>> response = await dioMethod.get('/mother/find/staffId/$staffId');

    if (response.statusCode == 201 || response.statusCode == 200) {
      List dataItem = response.data!;
      for (var i in dataItem) {
        resultList.add(MotherInfo.fromJson(i));
      }
      return resultList;
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

  Future<MotherInfo> findByUsername(String username) async {
    Response<Map<String, dynamic>> response = await dioMethod.get('/mother/find/username/$username');

    if (response.statusCode == 201 || response.statusCode == 200) {
      return MotherInfo.fromJson(response.data!);
    } if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

  Future<MotherInfo> updateMotherInfo(MotherInfo item) async {
    FormData formData = FormData.fromMap({
      "momId": item.momId,
      "username": item.username,
      "password": item.password,
      "firstname": item.firstname,
      "lastname": item.lastname,
      "pid": item.pid,
      "email": item.email,
      "address": item.address,
      "telPhone": item.telPhone,
      "pregnantStatus": item.pregnantStatus,
      "gestationalAge": item.gestationalAge,
      "imagePath": item.imagePath,
      "weight": item.weight,
      "height": item.height,
      "highPressure": item.highPressure,
      "lowPressure": item.lowPressure,
      "bleedingFlag": item.bleedingFlag,
      "staffId": item.staffId,
    });

    if (item.image != "") {
      formData.files.addAll([
        MapEntry('image', await MultipartFile.fromFile(item.image ?? ""),
        ),
      ]);
    }

    Response<Map<String, dynamic>> response = await dioMethod.put(
        '/mother',
        data: formData
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return MotherInfo.fromJson(response.data!);
    } else if(response.statusCode == 409) {
      throw Exception('Failed to update 409');
    } else {
      throw Exception('Failed to update');
    }
  }

}