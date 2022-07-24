import 'package:flutter/material.dart';

class Utils {

  static createToast(String text, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
        )
    );
  }

  static isNullOrEmpty(text) {
    if(text == null || text == ''){
      return true;
    } else {
      return false;
    }
  }

  static bool isNumeric(text) {
    if (text == null || text == '') {
      return false;
    }
    return double.tryParse(text) != null;
  }

}