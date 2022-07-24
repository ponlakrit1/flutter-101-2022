import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_101/screens/auth_mom_screen.dart';
import 'package:flutter_101/screens/auth_volunteer_screen.dart';

import 'login_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen(): super();

  static const String ROUTE_ID = 'landing_screen';

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  static const storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    _getSharedPreferencesUserType();
  }

  _getSharedPreferencesUserType() async {
    storage.read(key: "user_type").then((value) => {
      if (value == 'MOM') {
          Navigator.pushNamed(context, AuthMomScreen.ROUTE_ID)
      } else if (value == 'STAFF') {
        Navigator.pushNamed(context, AuthVolunteerScreen.ROUTE_ID)
      } else {
        Navigator.pushNamed(context, LoginScreen.ROUTE_ID)
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/asset/imgs/bg/bg-login.PNG"),
              fit: BoxFit.cover,
            ),
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Align(
              alignment: AlignmentDirectional(0, -1),
              child: Image(
                image: AssetImage("lib/asset/imgs/mother.png"),
                height: 200,
                width: 200,
              ),
            ),
          ],
        )
      )
    );
  }

}
