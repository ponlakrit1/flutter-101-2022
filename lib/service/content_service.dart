import 'package:dio/dio.dart';
import 'package:flutter_101/model/entity/content.dart';
import 'package:flutter_101/service/base_dio.dart';

class ContentService extends BaseDio {

  Future<List<Content>> findAll() async {
    List<Content> resultList = [];

    Response<List<dynamic>> response = await dioMethod.get('/content/');

    if (response.statusCode == 201 || response.statusCode == 200) {
      List dataItem = response.data!;
      for (var i in dataItem) {
        resultList.add(Content.fromJson(i));
      }
      return resultList;
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

  Future<List<Content>> findAllByIsActive() async {
    List<Content> resultList = [];

    Response<List<dynamic>> response = await dioMethod.get('/content/active');

    if (response.statusCode == 201 || response.statusCode == 200) {
      List dataItem = response.data!;
      for (var i in dataItem) {
        resultList.add(Content.fromJson(i));
      }
      return resultList;
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

  Future<Content> findById(int contentId) async {
    Response<Map<String, dynamic>> response = await dioMethod.get('/content/$contentId');

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Content.fromJson(response.data!);
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Service failed');
    }
  }

}