import 'package:flutter/material.dart';
import 'package:flutter_101/utils/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: Routes.routes(),
      initialRoute: Routes.initScreen(),
      theme: ThemeData(
        fontFamily: 'Kanit',
      ),
    );
  }
}
